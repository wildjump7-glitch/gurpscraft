### core_data / DESIGN.md

---

## **1. Purpose**

`core_data` provides **data loading, validation, and schema support** for all other GURPScraft modules.  
It ensures that every module can define its content (items, spells, biomes, factions, etc.) in clean Lua tables with:

- Safe loading  
- Optional schema validation  
- Template expansion  
- Error‑tolerant debugging  
- Consistent data access patterns  

This module is **optional but strongly recommended** for large games or teams.

It contains **no game logic** and **no engine logic** — only data infrastructure.

---

## **2. Responsibilities**

### **2.1 Data Loading**
- Load `.lua` data files from a module’s `data/` directory.
- Return tables in a predictable, validated format.
- Provide helper functions for:
  - Loading a single file
  - Loading all files in a directory
  - Merging multiple data sources

### **2.2 Schema Validation (Optional)**
- Allow modules to define simple schemas:
  - Required keys  
  - Expected types  
  - Allowed values  
- Validate data tables against schemas.
- Log warnings (never fatal errors) when data is malformed.

### **2.3 Template System**
- Allow data tables to inherit from templates.
- Support:
  - Shallow inheritance  
  - Deep inheritance  
  - Overriding fields  
  - Merging lists  

### **2.4 Data Registry Helpers**
- Provide a consistent pattern for:
  - Registering data entries  
  - Retrieving entries by ID  
  - Iterating over all entries  
  - Checking for duplicates  

### **2.5 Error Handling**
- Never crash the engine due to bad data.
- Log clear, actionable warnings.
- Provide debug tools to inspect loaded data.

---

## **3. Non‑Responsibilities**

- No gameplay logic.
- No item, spell, biome, or faction definitions.
- No worldgen, combat, or actor logic.
- No JSON parsing unless explicitly added (Lua tables are preferred).
- No saving or persistence (handled by other modules).

---

## **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.get_modpath`
  - `minetest.log`

### **Internal**
- `core_foundation` (for logging + utilities)

---

## **5. Public API Surface**

All public functions are exposed via `core_data/api.lua`.

### **5.1 File Loading**
- `data.load_file(path)`  
  Loads a single Lua file and returns its table.

- `data.load_dir(path)`  
  Loads all `.lua` files in a directory and returns a merged table.

### **5.2 Registry Helpers**
- `data.new_registry(name)`  
  Creates a registry object with:
  - `register(id, def)`
  - `get(id)`
  - `all()`
  - `validate(schema)`

### **5.3 Schema Validation**
- `data.validate(def, schema, context)`  
  Validates a table against a schema.

Schema example:

```lua
{
  id = "string",
  damage = "number",
  tags = { "table", optional = true },
}
```

### **5.4 Template Expansion**
- `data.apply_template(def, template)`  
- `data.expand_templates(defs, template_table)`  

Supports:
- Inheritance  
- Overriding  
- Deep merging  

### **5.5 Debug Tools**
- `data.debug.dump_registry(name)`  
- `data.debug.list_missing_keys(schema, defs)`  

---

## **6. Internal Structure**

`core_data/internal/` contains implementation details:

- `loader.lua`
  - File/directory loading
  - Safe execution wrappers

- `schema.lua`
  - Schema validation logic

- `json.lua` (optional)
  - Only included if JSON support is desired

- `templates.lua`
  - Template inheritance logic

These are not exposed directly.

---

## **7. Data Directory Structure**

Modules using `core_data` should follow:

```
module/
  data/
    items.lua
    weapons.lua
    spells.lua
    biomes.lua
    factions.lua
```

Each file returns a Lua table.

Example:

```lua
return {
  fireball = {
    damage = 30,
    cost = 10,
    school = "fire",
  }
}
```

---

## **8. Debug Tools**

`core_data/debug/` may include:

- `data_inspector.lua`
  - Chat commands to inspect loaded data
  - Print schemas
  - Validate all module data

Debug tools must be safe to disable.

---

## **9. Integration Notes (Luanti Compatibility)**

- Uses `minetest.get_modpath` to locate data directories.
- Uses `dofile` or `loadfile` safely wrapped to avoid crashes.
- Logs warnings using `core_foundation.log.warn`.
- Never registers nodes, items, or entities.

---

## **10. Success Criteria**

`core_data` is correct when:

- Modules can load data tables without writing boilerplate.
- Schemas catch common mistakes early.
- Template inheritance works predictably.
- No crashes occur due to malformed data.
- Debug tools help developers inspect and validate content.

---
