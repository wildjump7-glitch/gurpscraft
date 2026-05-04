Here is the **fully re‑generated, upgraded, siege‑aware, kaiju‑aware, structurally coherent**  
**`core_destruction / DESIGN.md`** — rewritten from the ground up to reflect the *true purpose* of the module in your engine.

This is now the **canonical** version.

---

# **core_destruction / DESIGN.md**

---

# **1. Purpose**

`core_destruction` provides the **structural integrity, siege warfare, and megafauna‑scale destruction framework** for the GURPScraft engine.

It enables:

- **Siege mechanics**  
  - Breaching walls  
  - Undermining foundations  
  - Artillery impacts  
  - Fire weakening  
  - Gate destruction  
  - Progressive collapse  

- **Kaiju / Titan / Mech destruction**  
  - Footprint‑scale block crushing  
  - Shockwaves  
  - Building‑scale collisions  
  - Mass‑based collapse  
  - Environmental hazards left behind  

- **Persistent war damage**  
  - Ruins  
  - Debris  
  - Scavenging  
  - Rebuilding  

- **Structural simulation**  
  - Load‑bearing  
  - Support graphs  
  - Collapse propagation  
  - Material fatigue  

This module contains **no game‑specific structures, weapons, or materials**.  
It defines *how destruction works*, not *what gets destroyed*.

---

# **2. Responsibilities**

## **2.1 Material Profiles**
Defines physical properties for all destructible materials:

- Hardness  
- Toughness  
- Brittleness  
- Fire resistance  
- Corrosion resistance  
- Shockwave absorption  
- Penetration resistance  
- Structural weight  
- Siege resistance (NEW)  
- Kaiju resistance (NEW)  

Data lives in:
```
core_destruction/data/materials.lua
```

---

## **2.2 Block Damage System**
Implements:

- Per‑block HP  
- Damage accumulation  
- Damage types:
  - blunt  
  - slash  
  - ballistic  
  - explosive  
  - fire  
  - siege  
  - kaiju  
  - anomalous  
- Threshold states:
  - intact  
  - cracked  
  - fractured  
  - failing  
  - collapsed  
- Debris generation  
- Scorching, charring, deformation  

---

## **2.3 Structural Integrity**
A full structural simulation layer:

- Support checks  
- Load‑bearing calculations  
- Weak point detection  
- Progressive collapse  
- Chain‑reaction collapse  
- Multi‑block structure graphs  
- Foundation undermining (sapper mechanics)  
- Siege‑specific collapse rules  
- Kaiju‑scale collapse rules  

---

## **2.4 Explosions & Shockwaves**
Implements:

- Radial blast damage  
- Pressure waves  
- Material‑dependent absorption  
- Shrapnel  
- Fire ignition  
- Dust clouds  
- Kaiju shockwaves (NEW)  
- Artillery overpressure (NEW)  

Integrates with:
- `core_effects`  
- `core_combat`  
- `core_physics`  

---

## **2.5 Projectile Penetration**
Supports:

- Raycast penetration  
- Material thickness checks  
- Ricochet  
- Fragmentation  
- Overpenetration  
- Siege projectiles (boulders, bolts)  
- Kaiju projectiles (spines, acid jets)  

---

## **2.6 Fire, Corrosion & Decay**
Implements:

- Fire spread  
- Burn damage  
- Smoke  
- Material charring  
- Acid corrosion  
- Radiation decay  
- Anomaly‑driven decay  
- Weathering (optional)  

Integrates with:
- `core_survival`  
- `core_anomalies`  

---

## **2.7 Ruin Persistence**
Supports:

- Saving destroyed states  
- Persistent rubble  
- Rebuildable structures  
- Decay over time  
- Scavenging  
- War‑torn biome modifiers  

---

## **2.8 Siege & Kaiju Hooks**
### **Siege Hooks**
- Siege damage multipliers  
- Breach zones  
- Undermining triggers  
- Fire weakening  
- Gate destruction logic  
- Siege engine integration  

### **Kaiju Hooks**
- Footprint destruction radius  
- Mass‑based collapse  
- Building‑scale collision boxes  
- Shockwave propagation  
- Environmental hazard creation  

---

## **2.9 Integration with Other Modules**
- `core_worldgen` → ruins, collapse rules  
- `core_combat` → damage sources  
- `core_physics` → debris, knockback  
- `core_effects` → dust, fire, smoke  
- `core_survival` → heat, smoke, toxic gas  
- `core_anomalies` → anomalous decay  
- `core_machines` → machine breakdown  
- `core_items` → tools affecting destruction  
- `core_vehicles` → vehicle collisions  
- `core_actor` → kaiju & siege engine AI  

---

# **3. Non‑Responsibilities**

- No weapon logic  
- No item definitions  
- No worldgen  
- No UI  
- No actor AI  
- No faction logic  

This module only simulates destruction.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.set_node`
  - `minetest.swap_node`
  - `minetest.get_node`
  - `minetest.add_particlespawner`
  - `minetest.sound_play`
  - `minetest.get_objects_inside_radius`
  - `VoxelManip`

### **Internal**
- `core_foundation`  
- `core_data`  
- `core_physics`  
- `core_combat`  
- `core_effects`  
- `core_survival`  
- `core_anomalies`  
- `core_worldgen`  
- `core_vehicles`  
- `core_actor`  

---

# **5. Public API Surface**

All public functions are exposed via `core_destruction/api.lua`.

## **5.1 Material Profiles**
- `destruction.get_material(node_name)`
- `destruction.register_material(id, def)`

## **5.2 Block Damage**
- `destruction.apply_damage(pos, amount, damage_type)`
- `destruction.get_block_hp(pos)`
- `destruction.set_block_hp(pos, value)`
- `destruction.break_block(pos, context)`

## **5.3 Structural Integrity**
- `destruction.check_support(pos)`
- `destruction.get_integrity(pos)`
- `destruction.trigger_collapse(pos, radius)`
- `destruction.update_integrity(pos)`

## **5.4 Explosions**
- `destruction.explode(pos, power, params)`
- `destruction.apply_shockwave(pos, power)`

## **5.5 Penetration**
- `destruction.penetrate(origin, direction, power)`
- `destruction.get_penetration_cost(node_name)`

## **5.6 Fire & Corrosion**
- `destruction.ignite(pos)`
- `destruction.extinguish(pos)`
- `destruction.apply_corrosion(pos, intensity)`

## **5.7 Ruin Persistence**
- `destruction.save_ruin(pos, data)`
- `destruction.load_ruin(pos)`
- `destruction.clear_ruin(pos)`

## **5.8 Siege & Kaiju**
- `destruction.apply_siege_damage(pos, amount)`
- `destruction.apply_kaiju_impact(pos, mass, velocity)`
- `destruction.create_breach(pos, radius)`
- `destruction.undermine(pos, depth)`

---

# **6. Internal Structure**

`core_destruction/internal/` contains:

- **materials.lua**  
- **block_damage.lua**  
- **integrity.lua**  
- **explosions.lua**  
- **penetration.lua**  
- **fire.lua**  
- **corrosion.lua**  
- **ruins.lua**  
- **siege.lua** (NEW)  
- **kaiju.lua** (NEW)  

These files are not exposed directly.

---

# **7. Data Structure**

`core_destruction/data/` contains:

### **materials.lua**
```lua
return {
  reinforced_concrete = {
    hardness = 10,
    toughness = 9,
    brittleness = 3,
    fire_resistance = 8,
    penetration = 15,
    weight = 4.0,
    siege_resistance = 12,
    kaiju_resistance = 6,
  },
}
```

### **collapse_profiles.lua**
```lua
return {
  fortress = {
    support_radius = 6,
    collapse_chance = 0.15,
    chain_reaction = false,
  }
}
```

### **fire_profiles.lua**
```lua
return {
  wood = {
    spread_chance = 0.4,
    burn_time = 20,
  }
}
```

---

# **8. Debug Tools**

- `integrity_overlay.lua`  
- `collapse_test.lua`  
- `penetration_test.lua`  
- `explosion_test.lua`  
- `fire_test.lua`  
- `siege_test.lua` (NEW)  
- `kaiju_test.lua` (NEW)  

---

# **9. Integration Notes (Luanti Compatibility)**

- Uses VoxelManip for mass destruction  
- Uses metadata for block HP  
- Collapse uses BFS/DFS graph traversal  
- Fire uses ABMs or node timers  
- Penetration uses raycasts  
- Kaiju impacts use physics impulses  

---

# **10. Success Criteria**

`core_destruction` is correct when:

- Structures collapse realistically  
- Siege engines can breach fortifications  
- Kaiju can destroy buildings at scale  
- Fire, corrosion, and decay behave predictably  
- Ruins persist across sessions  
- Material profiles drive destruction outcomes  
- No game‑specific content exists in this module  

---
