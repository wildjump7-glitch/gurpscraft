# **CODING_STANDARDS.md**

## **1. Philosophy**

All code in this repository must follow these principles:

- **Data‑driven first**  
  No hardcoded gameplay content in core modules.  
  All content must come from `/data/` files.

- **Modular boundaries are sacred**  
  No module may reach into another module’s internals.  
  Only use public APIs.

- **Predictable, boring, maintainable code**  
  Prefer clarity over cleverness.  
  Prefer explicit over implicit.  
  Prefer composition over inheritance.

- **Luanti‑compatible, non‑hallucinated APIs only**  
  Only use documented Luanti APIs.  
  If unsure, check the Luanti source or docs.

- **No side effects during load**  
  Modules must initialize cleanly and deterministically.

---

## **2. File & Folder Structure**

Each module must follow this structure:

```
module_name/
    init.lua
    api.lua
    DESIGN.md
    internal/
        *.lua
    data/
        *.lua
    debug/
        *.lua
```

### **2.1 init.lua**
- Loads data  
- Loads internal modules  
- Exposes the public API  
- Registers nodes/entities if applicable  
- Must not contain logic beyond initialization

### **2.2 api.lua**
- Only public functions  
- No internal helpers  
- No side effects  
- No direct access to other modules’ internals

### **2.3 internal/**
- Implementation details  
- Private helpers  
- State machines  
- Logic not meant for external use

### **2.4 data/**
- Pure Lua tables  
- No logic  
- No side effects  
- No references to other modules

### **2.5 debug/**
- Tools for developers  
- Must not affect gameplay  
- Must be disabled by default

---

## **3. Naming Conventions**

### **3.1 Variables**
- `snake_case` for variables  
- `UPPER_SNAKE_CASE` for constants  
- `camelCase` is forbidden

### **3.2 Functions**
- `snake_case`  
- Verb‑first naming  
  - `apply_damage`  
  - `get_stats`  
  - `spawn_actor`

### **3.3 Modules**
- `core_xxx` for core modules  
- `game_xxx` for game modules  
- Never abbreviate module names

### **3.4 Files**
- One responsibility per file  
- File names must match their purpose  
  - `stats.lua`  
  - `damage.lua`  
  - `integrity.lua`

---

## **4. Lua Style Rules**

### **4.1 Tables**
- Always use explicit keys  
- Never rely on array order unless documented  
- Prefer shallow tables unless necessary

### **4.2 Functions**
- No nested functions unless closures are required  
- No anonymous functions in public APIs  
- Keep functions under ~50 lines when possible

### **4.3 Comments**
- Use `--` for single line  
- Use `--[[ ]]` for multi‑line  
- Every public function must have a docstring

### **4.4 Error Handling**
- Use `core_foundation.error()` for fatal errors  
- Use `core_foundation.warn()` for non‑fatal issues  
- Never silently fail

---

## **5. Module Interaction Rules**

### **5.1 Allowed**
- Calling another module’s public API  
- Reading data from another module’s `/data/` folder  
- Using shared utilities from `core_foundation`

### **5.2 Forbidden**
- Accessing another module’s `internal/` folder  
- Modifying another module’s state directly  
- Creating circular dependencies  
- Hardcoding references to game content

---

## **6. Data‑Driven Rules**

### **6.1 All gameplay content must be defined in `/data/`**
Examples:
- Stats  
- Items  
- Biomes  
- Spells  
- Machines  
- Vehicles  
- Anomalies  
- Diseases  
- Materials  
- Recipes  

### **6.2 No logic in data files**
Data files must return pure tables.

### **6.3 No cross‑module references in data**
Data must be self‑contained.

---

## **7. Logging & Debugging**

### **7.1 Logging**
Use:
```
core_foundation.log("module", "message")
```

### **7.2 Debug Tools**
- Must live in `/debug/`  
- Must not run unless explicitly enabled  
- Must not modify game state unless intended

---

## **8. Performance Rules**

- Avoid global lookups  
- Cache Luanti API calls  
- Use VoxelManip for bulk operations  
- Avoid per‑node ABMs unless absolutely necessary  
- Prefer node timers or globalstep batching

---

## **9. AI & Copilot Rules**

These rules exist specifically to guide GitHub Copilot:

### **9.1 Copilot must follow DESIGN.md exactly**
No deviations.  
No invented APIs.  
No invented features.

### **9.2 Copilot must not create game content in core modules**
All content belongs in `game_wasteland`.

### **9.3 Copilot must not reference undocumented Luanti APIs**
If an API is not in the Luanti source or docs, it does not exist.

### **9.4 Copilot must keep modules isolated**
No internal cross‑module access.

### **9.5 Copilot must generate deterministic, maintainable code**
No clever hacks.  
No magic.  
No hidden state.

---

## **10. Testing & Validation**

### **10.1 Every module must include:**
- A self‑test debug tool  
- A validation function for data files  
- A sanity check on initialization

### **10.2 Destruction, vehicles, and worldgen require stress tests**
- Collapse propagation  
- Vehicle physics  
- Anomaly fields  
- Multi‑block structures  
- Chunk‑scale worldgen  

---

# **End of CODING_STANDARDS.md**

---


