### **core_machines / DESIGN.md**

---

# **1. Purpose**

`core_machines` is the **unified processing, crafting, automation, and energy framework** for the GURPScraft engine.  
It provides a modular, data‑driven system for:

- Crafting stations  
- Processing machines  
- Power systems (mechanical, electrical, magical, anomalous)  
- Item pipelines  
- Automation logic  
- Machine states (idle, working, jammed, overheated)  
- Multi‑block structures (optional)  

This module contains **no game‑specific recipes**, **no item definitions**, and **no worldgen**.  
It defines *how machines work*, not *what machines exist*.

---

# **2. Responsibilities**

### **2.1 Machine Registry**
Defines and manages machine types:
- Unique machine IDs  
- Node definitions  
- Processing capabilities  
- Power requirements  
- Input/output slots  
- Crafting speed  
- Heat generation  
- Failure modes  

Machine definitions are fully data‑driven via:
```
core_machines/data/machines.lua
```

### **2.2 Processing System**
Implements:
- Recipe matching  
- Processing timers  
- Multi‑input/multi‑output recipes  
- Batch processing  
- Conditional processing (e.g., requires heat, water, magic)  
- Skill‑based bonuses (via `core_stats`)  

### **2.3 Crafting Stations**
Supports:
- Workbenches  
- Forges  
- Chemistry stations  
- Magical altars  
- Anomaly stabilizers  
- Fabricators  
- 3D printers  

Crafting stations use:
- Recipes from `core_items`  
- Skill checks from `core_stats`  
- Effects from `core_effects`  

### **2.4 Power System**
Provides a flexible, pluggable power framework:
- Mechanical power (gears, belts, windmills)  
- Electrical power (generators, batteries, grids)  
- Magical power (mana conduits, ley lines)  
- Anomalous power (unstable, pulsing, dangerous)  

Power networks support:
- Transmission  
- Storage  
- Loss  
- Overload  
- Power tiers  

### **2.5 Automation**
Implements:
- Item input/output  
- Filters  
- Sorting  
- Conveyors  
- Pipes  
- Hoppers  
- Inserters  
- Robotic arms  

Automation integrates with:
- `core_inventory` (item validation)  
- `core_items` (item metadata)  

### **2.6 Machine States**
Machines can be:
- Idle  
- Working  
- Out of power  
- Jammed  
- Overheated  
- Broken  

Each state:
- Has visual effects (via `core_effects`)  
- Has sound effects  
- May affect processing speed  

### **2.7 Multi‑Block Machines (Optional)**
Supports:
- Large furnaces  
- Reactors  
- Fabrication bays  
- Dimensional stabilizers  
- Industrial complexes  

Multi‑block machines:
- Validate structure shape  
- Share power  
- Share inventory  
- Have unified control panels  

### **2.8 Integration with Other Modules**
- `core_items` → recipes, item metadata  
- `core_inventory` → input/output slots  
- `core_effects` → machine FX  
- `core_stats` → skill‑based crafting bonuses  
- `core_dimension` → dimension‑specific machine behavior  
- `core_anomalies` → anomalous power sources  
- `core_survival` → heat, radiation, toxicity  

---

# **3. Non‑Responsibilities**

- No item definitions  
- No combat logic  
- No worldgen  
- No UI (beyond machine GUIs)  
- No actor AI  
- No faction logic  

This module only defines machine behavior and processing.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.register_node`
  - `minetest.register_abm`
  - `minetest.register_lbm`
  - `minetest.get_meta`
  - `minetest.swap_node`
  - `minetest.add_particlespawner`
  - `minetest.sound_play`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (machine definitions)
- `core_items` (recipes)
- `core_inventory` (item handling)
- `core_effects` (visual/audio effects)
- `core_stats` (skill modifiers)
- `core_dimension` (dimension rules)
- `core_survival` (heat, radiation)

---

# **5. Public API Surface**

All public functions are exposed via `core_machines/api.lua`.

### **5.1 Machine Registry**
- `machines.register(id, def)`
- `machines.get(id)`
- `machines.all()`

### **5.2 Processing**
- `machines.process(machine, dtime)`
- `machines.can_process(machine)`
- `machines.start_process(machine)`
- `machines.finish_process(machine)`

### **5.3 Power**
- `machines.get_power(machine)`
- `machines.add_power(machine, amount)`
- `machines.consume_power(machine, amount)`
- `machines.is_powered(machine)`

### **5.4 Automation**
- `machines.push_items(src_machine, dst_machine, filter)`
- `machines.pull_items(src_machine, dst_machine, filter)`
- `machines.sort_items(machine, rules)`

### **5.5 Multi‑Block**
- `machines.validate_multiblock(pos, id)`
- `machines.get_multiblock_center(pos)`
- `machines.build_multiblock(id, pos)`

### **5.6 Machine State**
- `machines.set_state(machine, state)`
- `machines.get_state(machine)`
- `machines.update_state(machine)`

---

# **6. Internal Structure**

`core_machines/internal/` contains implementation details:

### **machine_logic.lua**
- Processing loop  
- State transitions  
- Recipe matching  

### **power.lua**
- Power networks  
- Transmission  
- Storage  
- Overload logic  

### **automation.lua**
- Item movement  
- Filters  
- Sorting rules  

### **multiblock.lua**
- Structure validation  
- Multi‑block state management  

### **machine_fx.lua**
- Particle effects  
- Sound effects  
- Overheat visuals  

These files are not exposed directly.

---

# **7. Data Structure**

`core_machines/data/` contains:

### **machines.lua**
Example:
```lua
return {
  furnace = {
    name = "Basic Furnace",
    power = { type = "heat", cost = 1 },
    inputs = { "ore" },
    outputs = { "ingot" },
    processing_time = 5,
    effects = { working = "furnace_glow" },
  }
}
```

### **recipes.lua**
Example:
```lua
return {
  smelt_iron = {
    input = { ore_iron = 1 },
    output = { ingot_iron = 1 },
    time = 5,
    station = "furnace",
  }
}
```

### **power_profiles.lua**
Example:
```lua
return {
  electrical = { max = 1000, loss = 0.05 },
  mechanical = { max = 200, loss = 0.1 },
}
```

---

# **8. Debug Tools**

`core_machines/debug/` may include:

- `machine_inspector.lua`
  - Shows machine state  
  - Shows power levels  
  - Shows recipe progress  

- `spawn_machine.lua`
  - Places any machine for testing  

---

# **9. Integration Notes (Luanti Compatibility)**

- Machines are implemented as nodes with metadata.
- Processing uses ABMs or node timers.
- Power networks may use node metadata or global tables.
- Automation uses inventory APIs.
- Multi‑block machines use adjacency checks and node scanning.

---

# **10. Success Criteria**

`core_machines` is correct when:

- Machines process items predictably and consistently.
- Power systems work across all machine types.
- Automation is stable and performant.
- Multi‑block structures validate correctly.
- Recipes are fully data‑driven.
- No game‑specific content exists in this module.

---

