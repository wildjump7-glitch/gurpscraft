### **core_dimension / DESIGN.md**

---

# **1. Purpose**

`core_dimension` is the **multi‑dimension framework** for the GURPScraft engine.  
It provides a unified, data‑driven system for defining, loading, and transitioning between:

- Overworlds  
- Underworlds  
- Pocket dimensions  
- Dream realms  
- Backrooms‑style infinite spaces  
- Astral planes  
- Sci‑fi planets or ships  
- Magical realms  
- Hazard zones  

This module contains **no worldgen logic**, **no combat logic**, and **no game‑specific content**.  
It defines *how dimensions work*, not *what dimensions exist*.

---

# **2. Responsibilities**

### **2.1 Dimension Registry**
Defines and manages dimension types:
- Unique dimension IDs  
- Names, descriptions  
- Worldgen profile (links to `core_worldgen`)  
- Gravity multiplier  
- Time rules (frozen, accelerated, reversed)  
- Weather rules  
- Lighting rules  
- Entry/exit rules  
- Spawn rules  
- Environmental modifiers  

Dimensions are fully data‑driven via:
```
core_dimension/data/dimension_defs.lua
```

### **2.2 Teleportation System**
Provides:
- Safe teleportation  
- Cross‑dimension transitions  
- Entry/exit validation  
- Teleport cooldowns  
- Teleport effects (via `core_effects`)  
- Teleport anchors  

Supports:
- Portals  
- Rifts  
- Spells (via `core_magic`)  
- Machines (via `core_machines`)  
- Anomalies (via `core_anomalies`)  

### **2.3 Dimension Rulesets**
Each dimension may define:
- Gravity multiplier  
- Weather overrides  
- Fog color/density  
- Skybox  
- Time speed  
- Survival modifiers (temperature, radiation)  
- Physics overrides (jump height, swim speed)  
- Combat modifiers (optional)  

Rulesets are applied:
- On player entry  
- On periodic updates  
- On environmental changes  

### **2.4 Dimension Loading & Unloading**
Handles:
- Initializing dimension state  
- Applying rulesets  
- Cleaning up dimension‑specific effects  
- Managing persistent dimension data  

### **2.5 Integration with Worldgen**
Dimensions may:
- Use different worldgen pipelines  
- Use different biome sets  
- Use different structure sets  
- Use different noise profiles  

### **2.6 Integration with Other Modules**
- `core_worldgen` → dimension‑specific worldgen  
- `core_survival` → temperature, radiation, oxygen  
- `core_effects` → skybox, fog, weather  
- `core_physics` → gravity  
- `core_anomalies` → dimension‑specific anomalies  
- `core_factions` → dimension‑specific faction behavior  

---

# **3. Non‑Responsibilities**

- No worldgen (delegated to `core_worldgen`)  
- No combat logic  
- No item logic  
- No actor AI  
- No UI  
- No anomaly behavior  

This module only defines dimension rules and transitions.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.set_player_velocity`
  - `minetest.set_player_control`
  - `minetest.set_sky`
  - `minetest.set_clouds`
  - `minetest.set_timeofday`
  - `minetest.after`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (dimension definitions)
- `core_effects` (teleport FX, skybox overlays)
- `core_worldgen` (dimension worldgen)
- `core_survival` (environmental effects)
- `core_physics` (gravity)
- `core_anomalies` (dimension‑specific anomalies)

---

# **5. Public API Surface**

All public functions are exposed via `core_dimension/api.lua`.

### **5.1 Dimension Registry**
- `dimension.register(id, def)`
- `dimension.get(id)`
- `dimension.all()`

### **5.2 Teleportation**
- `dimension.teleport(actor, dimension_id, pos, params)`
- `dimension.teleport_safe(actor, dimension_id)`
- `dimension.can_enter(actor, dimension_id)`
- `dimension.can_exit(actor, dimension_id)`

### **5.3 Rulesets**
- `dimension.apply_rules(actor, dimension_id)`
- `dimension.get_rules(dimension_id)`
- `dimension.update_rules(actor, dtime)`

### **5.4 Dimension State**
- `dimension.get_current(actor)`
- `dimension.set_current(actor, dimension_id)`
- `dimension.get_spawn_point(dimension_id)`

### **5.5 Events**
- `dimension.on_enter(actor, dimension_id)`
- `dimension.on_exit(actor, dimension_id)`

---

# **6. Internal Structure**

`core_dimension/internal/` contains implementation details:

### **dimension_loader.lua**
- Loads dimension definitions  
- Validates schemas  
- Registers dimension metadata  

### **teleport.lua**
- Teleport logic  
- Safety checks  
- Cooldowns  
- FX triggers  

### **rulesets.lua**
- Gravity  
- Weather  
- Fog  
- Time rules  
- Survival modifiers  

These files are not exposed directly.

---

# **7. Data Structure**

`core_dimension/data/` contains:

### **dimension_defs.lua**
Example:
```lua
return {
  overworld = {
    name = "Overworld",
    gravity = 1.0,
    skybox = "sky_overworld.png",
    fog = { color = "#a0c0ff", density = 0.02 },
    worldgen = "default",
    spawn = { x = 0, y = 10, z = 0 },
  },

  backrooms = {
    name = "Backrooms",
    gravity = 1.0,
    skybox = "sky_backrooms.png",
    fog = { color = "#ffffaa", density = 0.1 },
    time_frozen = true,
    worldgen = "backrooms_gen",
    survival = { sanity_drain = 1.5 },
  }
}
```

---

# **8. Debug Tools**

`core_dimension/debug/` may include:

- `dimension_portal.lua`
  - Spawns a test portal  
  - Teleports player to any dimension  

- `dimension_inspector.lua`
  - Shows current dimension  
  - Shows active ruleset  
  - Shows gravity, fog, skybox  

---

# **9. Integration Notes (Luanti Compatibility)**

- Uses `player:set_sky`, `set_clouds`, and HUD overlays for skyboxes.
- Uses `player:set_physics_override` for gravity.
- Uses `minetest.after` for delayed teleportation.
- Dimension transitions must be safe:
  - No teleport into solid nodes  
  - No teleport into unloaded mapblocks  

---

# **10. Success Criteria**

`core_dimension` is correct when:

- Dimensions can be defined entirely through data files.
- Teleportation is safe and consistent.
- Rulesets apply correctly on entry and update.
- Worldgen integrates cleanly with dimension IDs.
- Environmental effects (fog, sky, gravity) work reliably.
- No game‑specific content exists in this module.

---

