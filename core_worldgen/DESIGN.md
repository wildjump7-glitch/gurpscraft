### **core_worldgen / DESIGN.md**

---

# **1. Purpose**

`core_worldgen` is the **procedural world generation system** for the GURPScraft engine.  
It provides a **data‑driven, modular, biome‑aware, structure‑aware** worldgen pipeline that any genre can use:

- Post‑apocalypse wastelands  
- Fantasy forests and dungeons  
- Sci‑fi alien planets  
- Horror backrooms  
- Urban ruins  
- Underground networks  
- Pocket dimensions  

This module contains **no game‑specific biomes or structures**.  
It defines *how worlds are generated*, not *what worlds look like*.

---

# **2. Responsibilities**

### **2.1 Biome System**
Defines:
- Biome IDs  
- Heat/humidity parameters  
- Node palettes  
- Decorations  
- Spawn rules  
- Environmental modifiers (fog, light, weather hooks)  

Biomes are fully data‑driven via:
```
core_worldgen/data/biomes.lua
```

### **2.2 Noise Profiles**
Provides:
- 2D/3D noise maps  
- Terrain heightmaps  
- Cave noise  
- Cliff noise  
- River noise  
- Multi‑octave blending  

Noise profiles are defined in:
```
core_worldgen/data/noise_profiles.lua
```

### **2.3 Terrain Generation**
Implements:
- Heightmap generation  
- Terrain carving  
- Cliff/overhang generation  
- Cave systems  
- Ravines  
- Lakes and rivers  
- Biome blending  

### **2.4 Structure Placement**
Handles:
- Procedural structure spawning  
- Prefab placement  
- Ruins  
- Dungeons  
- Outposts  
- Anomalies (via `core_anomalies`)  
- Multi‑chunk structures  

Structure definitions live in:
```
core_worldgen/data/structures.lua
```

### **2.5 Chunk‑Based Generation**
Uses Luanti’s mapgen hooks to:
- Generate terrain  
- Place biomes  
- Place structures  
- Spawn anomalies  
- Apply dimension rules  

### **2.6 Dimension‑Aware Worldgen**
Integrates with `core_dimension` to support:
- Different worldgen rules per dimension  
- Different biomes per dimension  
- Different gravity, skyboxes, fog, weather  
- Procedural pocket realms  

### **2.7 Spawn Rules**
Defines:
- Player spawn logic  
- NPC spawn logic  
- Biome‑based spawn tables  
- Structure‑based spawn tables  

### **2.8 Integration with Other Modules**
- `core_dimension` → dimension rules  
- `core_anomalies` → anomaly placement  
- `core_factions` → faction‑controlled structures  
- `core_survival` → temperature, radiation zones  
- `core_effects` → weather and fog  

---

# **3. Non‑Responsibilities**

- No combat logic  
- No item spawning logic (beyond structure loot tables)  
- No actor AI  
- No UI  
- No survival logic  
- No faction logic  

Those belong to other modules.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.register_biome`
  - `minetest.register_decoration`
  - `minetest.register_ore`
  - `minetest.register_on_generated`
  - `minetest.get_mapgen_object`
  - `VoxelManip`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (biome/structure definitions)
- `core_dimension` (dimension rules)
- `core_anomalies` (anomaly placement)
- `core_effects` (weather hooks)

---

# **5. Public API Surface**

All public functions are exposed via `core_worldgen/api.lua`.

### **5.1 Biomes**
- `worldgen.register_biome(id, def)`
- `worldgen.get_biome(id)`
- `worldgen.get_biome_at(pos)`
- `worldgen.get_biomes()`

### **5.2 Noise**
- `worldgen.get_noise(id, pos)`
- `worldgen.register_noise(id, def)`
- `worldgen.get_noise_profile(id)`

### **5.3 Structures**
- `worldgen.register_structure(id, def)`
- `worldgen.place_structure(id, pos, rotation)`
- `worldgen.get_structure(id)`

### **5.4 Chunk Generation**
- `worldgen.generate_chunk(minp, maxp, seed, dimension_id)`
- `worldgen.apply_dimension_rules(minp, maxp, dimension_id)`

### **5.5 Spawning**
- `worldgen.get_spawn_point(dimension_id)`
- `worldgen.spawn_npcs_in_chunk(minp, maxp, biome_id)`

---

# **6. Internal Structure**

`core_worldgen/internal/` contains implementation details:

### **mapgen.lua**
- Main worldgen pipeline  
- Terrain generation  
- Biome assignment  
- Structure placement  

### **biome_selector.lua**
- Heat/humidity lookup  
- Biome blending  
- Dimension overrides  

### **structure_placer.lua**
- Prefab placement  
- Rotation  
- Multi‑chunk support  
- Spawn tables  

### **noise.lua**
- Noise profile caching  
- 2D/3D noise helpers  

### **spawn_rules.lua**
- NPC spawn logic  
- Player spawn logic  

These files are not exposed directly.

---

# **7. Data Structure**

`core_worldgen/data/` contains:

### **biomes.lua**
Example:
```lua
return {
  wasteland = {
    heat = 70,
    humidity = 10,
    nodes = {
      top = "wasteland_dust",
      filler = "wasteland_dirt",
      stone = "wasteland_stone",
    },
    decorations = { "dead_tree", "scrap_pile" },
    spawn = { "raider", "mutant" },
  }
}
```

### **structures.lua**
Example:
```lua
return {
  bunker = {
    prefab = "structures/bunker.mts",
    frequency = 0.002,
    biomes = { "wasteland" },
    spawn = { "soldier" },
  }
}
```

### **noise_profiles.lua**
Example:
```lua
return {
  terrain = {
    offset = 0,
    scale = 40,
    spread = { x = 250, y = 250, z = 250 },
    octaves = 4,
    persist = 0.6,
  }
}
```

---

# **8. Debug Tools**

`core_worldgen/debug/` may include:

- `worldgen_overlay.lua`
  - Shows biome boundaries  
  - Shows noise values  
  - Shows structure spawn points  

- `regen_chunk.lua`
  - Regenerates a chunk for testing  

---

# **9. Integration Notes (Luanti Compatibility)**

- Uses `minetest.register_on_generated` for chunk generation.
- Uses VoxelManip for efficient terrain editing.
- Biomes must be registered before mapgen runs.
- Structures may use `.mts` schematics or Lua prefabs.
- Dimension rules override global worldgen settings.

---

# **10. Success Criteria**

`core_worldgen` is correct when:

- Worlds generate consistently and deterministically.
- Biomes blend smoothly.
- Structures spawn correctly and without overlap.
- Dimensions can define their own worldgen rules.
- NPCs spawn according to biome/structure rules.
- No game‑specific content exists in this module.

---

