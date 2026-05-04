### **core_anomalies / DESIGN.md**

---

# **1. Purpose**

`core_anomalies` is the **environmental hazard and supernatural anomaly system** for the GURPScraft engine.  
It provides a unified, data‑driven framework for:

- Anomalies (static or dynamic environmental hazards)  
- Artifacts (items produced by anomalies)  
- Hazard fields (radiation, psychic zones, distortion fields)  
- Trigger logic (proximity, line‑of‑sight, timed pulses)  
- Environmental interactions (weather, dimension rules, survival systems)  

This module is intentionally **genre‑agnostic**.  
It supports everything from:

- STALKER‑style anomalies  
- SCP‑style containment breaches  
- Fantasy magical zones  
- Sci‑fi spatial distortions  
- Horror reality tears  
- Post‑apocalypse radiation pockets  

It defines *how anomalies behave*, not *what anomalies exist*.

---

# **2. Responsibilities**

### **2.1 Anomaly Registry**
Defines and manages anomaly types:
- Unique anomaly IDs  
- Visual effects  
- Trigger conditions  
- Hazard intensity  
- Behavior scripts  
- Artifact drop tables  
- Dimension/biome restrictions  

Anomalies are fully data‑driven via:
```
core_anomalies/data/anomaly_types.lua
```

### **2.2 Artifact System**
Defines:
- Artifact IDs  
- Effects (buffs, debuffs, stat modifiers)  
- Rarity  
- Spawn rules  
- Stability (optional decay)  

Artifacts integrate with:
- `core_items` (item definitions)  
- `core_stats` (stat modifiers)  
- `core_effects` (visual cues)  

### **2.3 Hazard Fields**
Implements:
- Radiation fields  
- Psychic pressure  
- Gravity distortions  
- Temperature anomalies  
- Corruption zones  
- Dimensional instability  

Hazards may:
- Apply periodic damage  
- Apply status effects  
- Modify physics  
- Modify perception  
- Trigger screen effects  

### **2.4 Trigger Logic**
Supports:
- Proximity triggers  
- Line‑of‑sight triggers  
- Touch triggers  
- Timed pulses  
- Random pulses  
- Actor‑specific triggers (e.g., only affect living actors)  

### **2.5 Anomaly Behavior**
Implements:
- Idle behavior  
- Active behavior  
- Pulsing  
- Chasing (for mobile anomalies)  
- Teleportation  
- Field expansion/contraction  
- Artifact generation  

### **2.6 Integration with Other Modules**
- `core_worldgen` → anomaly placement  
- `core_dimension` → dimension‑specific anomalies  
- `core_survival` → radiation, temperature, diseases  
- `core_effects` → visual/audio effects  
- `core_combat` → damage types  
- `core_stats` → resistance traits  
- `core_factions` → faction‑specific reactions  

---

# **3. Non‑Responsibilities**

- No combat logic (damage calculation belongs to `core_combat`)  
- No item definitions (belongs to `core_items`)  
- No worldgen logic (placement belongs to `core_worldgen`)  
- No UI logic (belongs to `core_ui`)  
- No actor AI (belongs to `core_actor`)  

This module only defines anomaly behavior and hazard effects.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.register_entity`
  - `minetest.add_particlespawner`
  - `minetest.sound_play`
  - `minetest.get_objects_inside_radius`
  - `minetest.after`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (anomaly definitions)
- `core_effects` (visual/audio effects)
- `core_survival` (radiation, temperature)
- `core_stats` (resistances, traits)
- `core_combat` (damage types)
- `core_dimension` (dimension rules)

---

# **5. Public API Surface**

All public functions are exposed via `core_anomalies/api.lua`.

### **5.1 Anomaly Registry**
- `anomalies.register(id, def)`
- `anomalies.get(id)`
- `anomalies.all()`

### **5.2 Spawning**
- `anomalies.spawn(id, pos, data)`
- `anomalies.despawn(entity)`
- `anomalies.spawn_random(pos, biome_id, dimension_id)`

### **5.3 Hazard Fields**
- `anomalies.apply_hazard(actor, anomaly_id, intensity)`
- `anomalies.get_hazard_intensity(pos)`
- `anomalies.get_hazard_type(id)`

### **5.4 Artifact Generation**
- `anomalies.generate_artifact(anomaly_id)`
- `anomalies.get_artifact_table(anomaly_id)`

### **5.5 Trigger Logic**
- `anomalies.check_trigger(anomaly, actor)`
- `anomalies.run_trigger(anomaly, actor)`

### **5.6 Behavior**
- `anomalies.update(anomaly, dtime)`
- `anomalies.run_behavior(anomaly, dtime)`

---

# **6. Internal Structure**

`core_anomalies/internal/` contains implementation details:

### **anomaly_logic.lua**
- State machine  
- Trigger evaluation  
- Behavior execution  
- Hazard application  

### **artifact_spawner.lua**
- Artifact generation  
- Rarity weighting  
- Drop tables  

### **hazard_effects.lua**
- Radiation  
- Temperature  
- Psychic pressure  
- Corruption  
- Dimensional instability  

These files are not exposed directly.

---

# **7. Data Structure**

`core_anomalies/data/` contains:

### **anomaly_types.lua**
Example:
```lua
return {
  gravity_well = {
    name = "Gravity Well",
    triggers = { proximity = 6 },
    hazard = { type = "gravity", intensity = 3 },
    effects = { particle = "gravity_swirl", sound = "gravity_hum" },
    artifacts = { "dense_core", chance = 0.1 },
    behavior = "gravity_behavior",
  }
}
```

### **artifact_types.lua**
Example:
```lua
return {
  dense_core = {
    name = "Dense Core",
    rarity = "rare",
    effects = {
      stats = { ST = +2 },
      physics = { mass = +10 },
    }
  }
}
```

---

# **8. Debug Tools**

`core_anomalies/debug/` may include:

- `anomaly_visualizer.lua`
  - Shows hazard radius  
  - Shows trigger zones  
  - Shows anomaly state  

- `spawn_anomaly.lua`
  - Spawns any anomaly at a position  

---

# **9. Integration Notes (Luanti Compatibility)**

- Anomalies are implemented as invisible or semi‑visible entities.
- Hazard fields use periodic globalstep checks.
- Particle and sound effects use `core_effects`.
- Artifact generation integrates with `core_items`.

---

# **10. Success Criteria**

`core_anomalies` is correct when:

- Anomalies behave consistently and predictably.
- Hazard fields apply correct effects.
- Artifacts generate according to data tables.
- Triggers work reliably (proximity, LOS, timed).
- Behavior scripts are fully data‑driven.
- No game‑specific content exists in this module.

---

