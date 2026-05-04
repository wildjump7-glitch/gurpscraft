### **core_survival / DESIGN.md**

---

# **1. Purpose**

`core_survival` is the **environmental and physiological simulation system** for the GURPScraft engine.  
It provides a unified, data‑driven framework for:

- Hunger  
- Thirst  
- Temperature  
- Weather exposure  
- Radiation  
- Diseases & infections  
- Poisoning  
- Fatigue (distinct from stamina)  
- Environmental damage  
- Status effects related to survival  

This module contains **no worldgen**, **no combat logic**, **no item definitions**, and **no game‑specific values**.  
It defines *how survival systems work*, not *what specific survival challenges exist*.

---

# **2. Responsibilities**

### **2.1 Hunger System**
Tracks:
- Hunger value  
- Hunger rate  
- Starvation thresholds  
- Starvation damage  
- Food item integration (via `core_items`)  

Hunger affects:
- Stamina regen (via `core_physics`)  
- Movement speed  
- Skill checks (via `core_stats`)  

### **2.2 Thirst System**
Tracks:
- Hydration value  
- Thirst rate  
- Dehydration thresholds  
- Dehydration damage  

Thirst affects:
- Stamina drain  
- Heatstroke risk  
- Vision blur (via `core_effects`)  

### **2.3 Temperature System**
Implements:
- Body temperature  
- Environmental temperature  
- Clothing insulation (via `core_items` + `core_inventory`)  
- Wind chill  
- Heatstroke  
- Hypothermia  

Temperature affects:
- Stamina drain  
- Movement speed  
- Health regeneration  
- Screen effects  

### **2.4 Radiation System**
Supports:
- Radiation exposure  
- Accumulated dose  
- Dose decay  
- Radiation sickness stages  
- Trait‑based resistance (via `core_stats`)  

Radiation integrates with:
- `core_anomalies` (hazard fields)  
- `core_worldgen` (biome radiation)  
- `core_items` (protective gear)  

### **2.5 Disease System**
Implements:
- Disease definitions  
- Infection chance  
- Incubation periods  
- Symptoms  
- Cures (via consumables)  
- Contagion rules  

Diseases are defined in:
```
core_survival/data/diseases.lua
```

### **2.6 Poisoning & Toxins**
Handles:
- Poison stacks  
- Toxin types  
- Damage over time  
- Antidotes  
- Trait‑based resistance  

### **2.7 Fatigue (Long‑Term Exhaustion)**
Distinct from stamina:
- Stamina = short‑term energy  
- Fatigue = long‑term exhaustion  

Fatigue affects:
- Max stamina  
- Movement speed  
- Skill checks  
- Sleep requirements  

### **2.8 Environmental Damage**
Supports:
- Lava/acid  
- Extreme cold/heat  
- Toxic gas  
- Vacuum (via `core_dimension`)  
- Drowning (via `core_physics`)  

### **2.9 Integration with Other Modules**
- `core_stats` → trait modifiers  
- `core_inventory` → clothing/armor insulation  
- `core_effects` → screen effects  
- `core_dimension` → dimension‑specific survival rules  
- `core_worldgen` → biome temperature/radiation  
- `core_anomalies` → hazard fields  
- `core_physics` → stamina & movement penalties  

---

# **3. Non‑Responsibilities**

- No combat damage  
- No item definitions  
- No worldgen  
- No UI  
- No actor AI  
- No faction logic  

This module only simulates survival conditions.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.get_node`
  - `minetest.get_heat`
  - `minetest.get_humidity`
  - `minetest.after`
  - `minetest.get_objects_inside_radius`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (disease definitions, survival constants)
- `core_stats` (traits, resistances)
- `core_inventory` (clothing, armor)
- `core_effects` (screen effects)
- `core_physics` (stamina, movement)
- `core_dimension` (dimension rules)
- `core_anomalies` (hazard fields)

---

# **5. Public API Surface**

All public functions are exposed via `core_survival/api.lua`.

### **5.1 Hunger**
- `survival.get_hunger(actor)`
- `survival.modify_hunger(actor, delta)`
- `survival.set_hunger(actor, value)`
- `survival.apply_starvation(actor)`

### **5.2 Thirst**
- `survival.get_thirst(actor)`
- `survival.modify_thirst(actor, delta)`
- `survival.set_thirst(actor, value)`
- `survival.apply_dehydration(actor)`

### **5.3 Temperature**
- `survival.get_temperature(actor)`
- `survival.update_temperature(actor, dtime)`
- `survival.apply_hypothermia(actor)`
- `survival.apply_heatstroke(actor)`

### **5.4 Radiation**
- `survival.get_radiation(actor)`
- `survival.modify_radiation(actor, delta)`
- `survival.apply_radiation_sickness(actor)`

### **5.5 Disease**
- `survival.infect(actor, disease_id)`
- `survival.cure(actor, disease_id)`
- `survival.update_diseases(actor, dtime)`

### **5.6 Poison**
- `survival.apply_poison(actor, toxin_id, amount)`
- `survival.update_poison(actor, dtime)`

### **5.7 Fatigue**
- `survival.get_fatigue(actor)`
- `survival.modify_fatigue(actor, delta)`
- `survival.apply_exhaustion(actor)`

### **5.8 Environmental Damage**
- `survival.apply_environmental_damage(actor, damage_type, amount)`
- `survival.check_environment(actor)`

---

# **6. Internal Structure**

`core_survival/internal/` contains implementation details:

### **hunger.lua**
- Hunger decay  
- Starvation thresholds  

### **thirst.lua**
- Thirst decay  
- Dehydration thresholds  

### **temperature.lua**
- Body temperature  
- Environmental temperature  
- Clothing insulation  

### **radiation.lua**
- Dose accumulation  
- Sickness stages  

### **disease.lua**
- Infection logic  
- Symptom progression  
- Contagion  

### **poison.lua**
- Poison stacks  
- Damage over time  

### **fatigue.lua**
- Long‑term exhaustion  
- Sleep requirements  

### **environment.lua**
- Lava/acid  
- Toxic gas  
- Vacuum  
- Drowning integration  

These files are not exposed directly.

---

# **7. Data Structure**

`core_survival/data/` contains:

### **survival_constants.lua**
Example:
```lua
return {
  hunger_rate = 0.1,
  thirst_rate = 0.15,
  temperature_decay = 0.05,
}
```

### **diseases.lua**
Example:
```lua
return {
  flu = {
    incubation = 300,
    symptoms = {
      { time = 0, effect = { stamina = -10 } },
      { time = 600, effect = { DX = -1 } },
    },
    cure = "antiviral_med",
  }
}
```

### **toxins.lua**
Example:
```lua
return {
  venom = {
    damage_per_tick = 2,
    duration = 30,
  }
}
```

---

# **8. Debug Tools**

`core_survival/debug/` may include:

- `survival_overlay.lua`
  - Shows hunger, thirst, temperature, radiation  
  - Shows disease states  

- `apply_hazard.lua`
  - Applies any survival hazard for testing  

---

# **9. Integration Notes (Luanti Compatibility)**

- Uses globalstep for periodic survival updates.
- Uses `minetest.get_node` for environmental checks.
- Uses HUD overlays (via `core_ui`) for survival indicators.
- Uses `core_effects` for screen effects (blur, frost, heat haze).
- Uses `core_physics` for stamina/movement penalties.

---

# **10. Success Criteria**

`core_survival` is correct when:

- Hunger, thirst, temperature, and radiation behave predictably.
- Diseases progress according to data definitions.
- Environmental hazards apply correct effects.
- Survival systems integrate cleanly with physics, stats, and UI.
- No game‑specific content exists in this module.

---

