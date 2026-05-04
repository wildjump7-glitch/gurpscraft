### **core_items / DESIGN.md**

---

# **1. Purpose**

`core_items` is the **universal item definition and registration system** for the GURPScraft engine.  
It provides a **data‑driven, modular, extensible** framework for defining:

- Weapons  
- Ammo  
- Armor  
- Consumables  
- Attachments  
- Crafting components  
- Generic items  
- Tags, categories, and metadata  
- Item effects (stat modifiers, status effects, triggers)

This module contains **no game‑specific content** and **no combat logic**.  
It defines *what* items are and *how* they behave at a systemic level.

All content is defined in `data/*.lua` files.

---

# **2. Responsibilities**

### **2.1 Item Registry**
- Register items by ID.
- Prevent duplicate IDs.
- Provide lookup functions.
- Provide iteration over all items.
- Support inheritance via templates (through `core_data`).

### **2.2 Item Categories**
Support the following item types (extensible):

- `weapon`
- `ammo`
- `armor`
- `consumable`
- `attachment`
- `material`
- `tool`
- `misc`

Each category has its own schema and expected fields.

### **2.3 Item Tags**
Items may define tags such as:
- `"ranged"`
- `"melee"`
- `"firearm"`
- `"magic"`
- `"heavy"`
- `"food"`
- `"medical"`

Tags allow:
- Filtering  
- AI decision‑making  
- Crafting rules  
- UI grouping  

### **2.4 Item Effects**
Items may define effects that apply when:
- Equipped  
- Used  
- Consumed  
- Attached  
- Triggered by conditions  

Effects may include:
- Stat modifiers (via `core_stats`)
- Status effects (via `core_effects`)
- Healing / damage
- Buffs / debuffs
- Scripted callbacks (safe, limited)

### **2.5 Crafting Support**
Defines:
- Crafting recipes  
- Required tools  
- Required stations  
- Output items  
- Optional skill checks  

Actual crafting logic lives in `core_machines`.

### **2.6 Attachment System**
Supports:
- Weapon attachments  
- Armor attachments  
- Tool upgrades  
- Slot definitions  
- Compatibility rules  

### **2.7 Item Metadata**
Supports:
- Stack size  
- Weight  
- Durability  
- Wear  
- Value  
- Rarity  

### **2.8 Integration with Inventory**
`core_items` defines item behavior.  
`core_inventory` handles:
- Equipment slots  
- Encumbrance  
- Quickslots  

---

# **3. Non‑Responsibilities**

- No combat logic (damage, recoil, penetration).
- No inventory logic (slots, encumbrance).
- No UI logic.
- No worldgen item spawning.
- No faction or actor logic.
- No machine processing logic.

Those belong to other modules.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.register_craftitem`
  - `minetest.register_tool`
  - `minetest.register_node` (rarely used here)
  - `minetest.register_craft`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (data loading, schema validation)
- `core_stats` (stat modifiers)
- `core_effects` (status effects)

---

# **5. Public API Surface**

All public functions are exposed via `core_items/api.lua`.

### **5.1 Registry**
- `items.register(id, def)`
- `items.get(id)`
- `items.all()`
- `items.exists(id)`

### **5.2 Tags**
- `items.has_tag(id, tag)`
- `items.get_by_tag(tag)`
- `items.get_tags(id)`

### **5.3 Effects**
- `items.apply_effects(actor, item_id, context)`
- `items.get_effects(item_id)`

### **5.4 Crafting**
- `items.get_recipe(id)`
- `items.get_recipes_by_output(id)`
- `items.get_recipes_by_tag(tag)`

### **5.5 Attachments**
- `items.get_attachment_slots(item_id)`
- `items.get_compatible_attachments(item_id)`
- `items.apply_attachment(item_id, attachment_id)`

---

# **6. Internal Structure**

`core_items/internal/` contains implementation details:

### **registry.lua**
- Stores all item definitions.
- Ensures unique IDs.
- Provides lookup and iteration.

### **item_tags.lua**
- Manages tag indexing.
- Provides fast tag‑based queries.

### **item_effects.lua**
- Applies stat modifiers.
- Applies status effects.
- Handles scripted callbacks.

---

# **7. Data Structure**

`core_items/data/` contains:

### **weapons.lua**
Example:
```lua
return {
  pistol = {
    type = "weapon",
    tags = { "ranged", "firearm" },
    weight = 1.2,
    durability = 100,
    effects = {
      equip = { stats = { DX = +1 } }
    }
  }
}
```

### **ammo.lua**
Example:
```lua
return {
  nine_mm = {
    type = "ammo",
    caliber = "9mm",
    stack_max = 50,
  }
}
```

### **armor.lua**
Example:
```lua
return {
  kevlar_vest = {
    type = "armor",
    armor_class = 2,
    weight = 5.0,
  }
}
```

### **consumables.lua**
Example:
```lua
return {
  medkit = {
    type = "consumable",
    effects = {
      use = { heal = 25 }
    }
  }
}
```

### **attachments.lua**
Example:
```lua
return {
  red_dot = {
    type = "attachment",
    slot = "optic",
    effects = {
      equip = { stats = { aim_speed = +0.1 } }
    }
  }
}
```

### **crafting.lua**
Example:
```lua
return {
  pistol_recipe = {
    output = "pistol",
    ingredients = {
      steel = 2,
      springs = 1,
    },
    tools = { "workbench" },
  }
}
```

---

# **8. Debug Tools**

`core_items/debug/` may include:

- `give_item.lua`
  - Chat command to spawn any item.
- `item_inspector.lua`
  - Prints item definitions.
- `tag_browser.lua`
  - Lists items by tag.

---

# **9. Integration Notes (Luanti Compatibility)**

- Items are registered using:
  - `minetest.register_craftitem`
  - `minetest.register_tool`
  - `minetest.register_node` (rarely)
- Wear/durability uses Luanti’s built‑in wear system.
- Crafting recipes use `minetest.register_craft`.
- Item metadata uses itemstack metadata.

---

# **10. Success Criteria**

`core_items` is correct when:

- Items can be defined entirely through data files.
- Tags and categories work consistently.
- Effects apply cleanly through `core_stats` and `core_effects`.
- Attachments and crafting are data‑driven.
- No game‑specific content exists in this module.
- Other modules (combat, inventory, survival) can rely on item definitions without modification.

---