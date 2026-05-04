### **core_crafting / DESIGN.md**

---

# **1. Purpose**

`core_crafting` is the **unified crafting, recipe, and item‑transformation framework** for the GURPScraft engine.  
It provides a **data‑driven, tag‑based, shapeless/shaped, skill‑aware** crafting system that works across:

- Player crafting (grid, shapeless, tag‑based)  
- Station crafting (workbenches, forges, labs, altars)  
- Machine crafting (via `core_machines`)  
- Magic crafting (scrolls, potions, runes)  
- Survival crafting (field repairs, improvised tools)  
- Reverse‑engineering (discovering recipes through experimentation)  

This module contains **no game‑specific recipes**, **no item definitions**, and **no UI**.  
It defines *how crafting works*, not *what can be crafted*.

---

# **2. Responsibilities**

### **2.1 Recipe Registry**
Defines and manages all recipe types:
- Shapeless recipes  
- Shaped recipes  
- Tag‑based recipes  
- Station‑specific recipes  
- Skill‑gated recipes  
- Multi‑output recipes  
- Conditional recipes (dimension, biome, faction, anomaly proximity)  

Recipes are fully data‑driven via:
```
core_crafting/data/recipes.lua
```

### **2.2 Crafting Logic**
Implements:
- Ingredient matching  
- Tag matching (e.g., `"metal_ingot"`, `"herb"`, `"cloth"`)  
- Tool requirements  
- Station requirements  
- Skill checks (via `core_stats`)  
- Failure outcomes (reduced output, scrap, nothing)  
- Critical success outcomes (bonus items, improved quality)  

### **2.3 Player Crafting**
Supports:
- Shapeless crafting  
- Shaped grid crafting  
- Tag‑based crafting  
- Crafting preview  
- Crafting validation  
- Crafting time (optional)  

### **2.4 Station Crafting**
Integrates with:
- Workbenches  
- Forges  
- Chemistry stations  
- Magical altars  
- Anomaly stabilizers  
- Fabricators  

Station crafting includes:
- Required tools  
- Required environment (heat, water, magic, radiation)  
- Required skill level  
- Required faction reputation (optional)  

### **2.5 Reverse‑Engineering**
Supports:
- Discovering recipes by experimenting  
- Unlocking recipes by disassembling items  
- Unlocking recipes by reading books/scrolls  
- Unlocking recipes by faction rank  
- Unlocking recipes by skill level  

Reverse‑engineering integrates with:
- `core_items` (item metadata)  
- `core_stats` (skill checks)  

### **2.6 Crafting Quality**
Implements:
- Item quality tiers  
- Quality modifiers (durability, damage, weight, value)  
- Skill‑based quality bonuses  
- Station‑based quality bonuses  

### **2.7 Integration with Other Modules**
- `core_items` → item metadata, tags  
- `core_inventory` → item handling  
- `core_stats` → skill checks, traits  
- `core_machines` → machine processing  
- `core_magic` → magical crafting  
- `core_survival` → improvised crafting, field repairs  
- `core_factions` → faction‑locked recipes  

---

# **3. Non‑Responsibilities**

- No item definitions  
- No machine logic  
- No UI  
- No worldgen  
- No combat logic  
- No actor AI  

This module only defines crafting mechanics.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.register_craft`
  - `minetest.get_craft_result`
  - `minetest.get_craft_recipe`
  - `minetest.after`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (recipe definitions)
- `core_items` (item metadata)
- `core_inventory` (item handling)
- `core_stats` (skill checks)
- `core_machines` (machine crafting)
- `core_magic` (magical crafting)
- `core_survival` (environmental crafting)

---

# **5. Public API Surface**

All public functions are exposed via `core_crafting/api.lua`.

### **5.1 Recipe Registry**
- `crafting.register_recipe(id, def)`
- `crafting.get_recipe(id)`
- `crafting.get_recipes_by_output(item_id)`
- `crafting.get_recipes_by_tag(tag)`
- `crafting.all_recipes()`

### **5.2 Crafting Execution**
- `crafting.can_craft(actor, recipe_id)`
- `crafting.craft(actor, recipe_id)`
- `crafting.get_craft_result(actor, recipe_id)`
- `crafting.get_failure_result(actor, recipe_id)`
- `crafting.get_critical_success_result(actor, recipe_id)`

### **5.3 Ingredient Matching**
- `crafting.match_ingredients(input_list, recipe_def)`
- `crafting.match_tags(input_list, tag_list)`
- `crafting.match_tools(actor, recipe_def)`

### **5.4 Skill Integration**
- `crafting.get_skill_modifier(actor, recipe_id)`
- `crafting.roll_crafting_check(actor, recipe_id)`

### **5.5 Reverse‑Engineering**
- `crafting.reverse_engineer(actor, item_id)`
- `crafting.unlock_recipe(actor, recipe_id)`
- `crafting.get_unlocked_recipes(actor)`

### **5.6 Quality System**
- `crafting.calculate_quality(actor, recipe_id)`
- `crafting.apply_quality(itemstack, quality)`

---

# **6. Internal Structure**

`core_crafting/internal/` contains implementation details:

### **recipe_match.lua**
- Ingredient matching  
- Tag matching  
- Tool validation  

### **craft_logic.lua**
- Crafting execution  
- Skill checks  
- Failure/critical success logic  

### **reverse_engineering.lua**
- Unlocking recipes  
- Disassembly logic  

### **quality.lua**
- Quality calculation  
- Quality modifiers  

These files are not exposed directly.

---

# **7. Data Structure**

`core_crafting/data/` contains:

### **recipes.lua**
Example:
```lua
return {
  iron_sword = {
    type = "shaped",
    pattern = {
      " I ",
      " I ",
      " S ",
    },
    key = {
      I = { tag = "metal_ingot" },
      S = "stick",
    },
    output = { item = "iron_sword", count = 1 },
    tools = { "hammer" },
    station = "forge",
    skill = { weapon_smithing = 10 },
  }
}
```

### **reverse_engineering.lua**
Example:
```lua
return {
  iron_sword = {
    difficulty = 8,
    unlocks = { "iron_sword" },
  }
}
```

### **quality_profiles.lua**
Example:
```lua
return {
  poor = { durability = -20 },
  normal = {},
  fine = { durability = +10 },
  masterwork = { durability = +25, damage = +2 },
}
```

---

# **8. Debug Tools**

`core_crafting/debug/` may include:

- `craft_test.lua`
  - Tests any recipe  
  - Shows ingredient matching  
  - Shows skill rolls  

- `reverse_test.lua`
  - Tests reverse‑engineering outcomes  

---

# **9. Integration Notes (Luanti Compatibility)**

- Uses `minetest.register_craft` for basic recipes.
- Advanced recipes use custom logic layered on top.
- Player crafting integrates with formspecs (UI provided by game module).
- Station crafting integrates with node metadata.
- Machine crafting integrates with `core_machines`.

---

# **10. Success Criteria**

`core_crafting` is correct when:

- Recipes are fully data‑driven.  
- Tag‑based and shaped/shapeless crafting work consistently.  
- Skill checks modify outcomes correctly.  
- Reverse‑engineering unlocks recipes reliably.  
- Quality tiers apply cleanly to items.  
- No game‑specific content exists in this module.  

---

