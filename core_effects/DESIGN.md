### **core_effects / DESIGN.md**

---

# **1. Purpose**

`core_effects` is the **unified visual, audio, and environmental effects system** for the GURPScraft engine.  
It provides a clean, data‑driven way for any module (combat, magic, anomalies, machines, survival, etc.) to trigger:

- Particle effects  
- Screen effects  
- Sound effects  
- Weather effects  
- Timed/looping effects  
- Effect presets  

This module contains **no gameplay logic**.  
It defines *how effects are played*, not *why* they occur.

---

# **2. Responsibilities**

### **2.1 Particle Effects**
Provides a wrapper around Luanti’s particle API:
- Single particles  
- Particle spawners  
- Burst effects  
- Trails  
- Impact effects  
- Muzzle flashes  
- Magic effects  

Supports:
- Data‑driven presets  
- Color gradients  
- Animated textures  
- Physics (gravity, velocity, drag)  

### **2.2 Screen Effects**
Implements:
- Screen shake  
- Screen flash  
- Vignette  
- Blur (simulated via overlays)  
- Color grading overlays  
- Hit indicators  
- Suppression effects  

Screen effects are:
- Local to the player  
- Time‑based  
- Stackable  
- Configurable  

### **2.3 Sound Effects**
Provides:
- Positional sound playback  
- Non‑positional UI sounds  
- Looping sounds  
- Sound categories (combat, magic, UI, ambient)  
- Volume modifiers  
- Distance falloff  

### **2.4 Weather Effects**
Supports:
- Rain  
- Snow  
- Fog  
- Ash  
- Sandstorms  
- Lightning flashes  
- Wind gusts  

Weather integrates with:
- `core_dimension` (dimension‑specific weather)  
- `core_survival` (temperature, visibility)  

### **2.5 Effect Presets**
Allows modules to define reusable effect bundles:
```
effects.play("fireball_explosion", pos)
```

Presets may include:
- Particles  
- Sounds  
- Screen shake  
- Light flashes  

### **2.6 Timed & Looping Effects**
Supports:
- Duration‑based effects  
- Looping particle spawners  
- Looping sounds  
- Cleanup callbacks  

### **2.7 Integration with Other Modules**
- `core_combat` → muzzle flashes, impacts, blood, suppression  
- `core_magic` → spell effects  
- `core_anomalies` → anomaly fields, distortions  
- `core_survival` → weather, temperature cues  
- `core_machines` → sparks, smoke, steam  

---

# **3. Non‑Responsibilities**

- No combat logic  
- No magic logic  
- No survival logic  
- No worldgen  
- No UI widgets  
- No actor logic  
- No item logic  

Effects are purely cosmetic.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.add_particle`
  - `minetest.add_particlespawner`
  - `minetest.sound_play`
  - `minetest.add_entity` (for light flashes)
  - `minetest.after`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (effect presets)
- `core_dimension` (weather rules)
- `core_stats` (optional: trait‑based visual effects)

---

# **5. Public API Surface**

All public functions are exposed via `core_effects/api.lua`.

### **5.1 Particle Effects**
- `effects.particle(def)`
- `effects.particles(def)`
- `effects.preset_particles(id, pos, context)`

### **5.2 Screen Effects**
- `effects.screen_shake(player, intensity, duration)`
- `effects.screen_flash(player, color, duration)`
- `effects.screen_overlay(player, texture, duration)`
- `effects.hit_indicator(player, direction)`

### **5.3 Sound Effects**
- `effects.sound(id, pos, params)`
- `effects.sound_local(player, id, params)`
- `effects.sound_loop_start(player, id, params)`
- `effects.sound_loop_stop(player, loop_id)`

### **5.4 Weather**
- `effects.set_weather(dimension_id, weather_id)`
- `effects.get_weather(dimension_id)`
- `effects.apply_weather(player, weather_id)`

### **5.5 Presets**
- `effects.play(id, pos, context)`
- `effects.register_preset(id, def)`
- `effects.get_preset(id)`

### **5.6 Timed Effects**
- `effects.start_loop(id, pos, context)`
- `effects.stop_loop(loop_handle)`

---

# **6. Internal Structure**

`core_effects/internal/` contains implementation details:

### **particles.lua**
- Particle spawning  
- Spawner management  
- Preset expansion  

### **screen_fx.lua**
- Screen overlays  
- Flash effects  
- Shake logic  
- Hit indicators  

### **sound_fx.lua**
- Sound playback  
- Looping sound management  
- Positional audio  

### **weather.lua**
- Weather state machine  
- Weather presets  
- Player‑local weather application  

These files are not exposed directly.

---

# **7. Data Structure**

`core_effects/data/` contains:

### **particle_presets.lua**
Example:
```lua
return {
  fireball_explosion = {
    particles = {
      amount = 40,
      texture = "fire_particle.png",
      velocity = { min = -2, max = 2 },
      gravity = -4,
      glow = 10,
    },
    sound = "explosion_large",
    screen_shake = { intensity = 1.2, duration = 0.3 },
  }
}
```

### **weather_profiles.lua**
Example:
```lua
return {
  rain = {
    particles = "rain_drop",
    sound = "rain_loop",
    fog = { density = 0.2, color = "#7aa0ff" },
  }
}
```

---

# **8. Debug Tools**

`core_effects/debug/` may include:

- `fx_test.lua`
  - Chat command to play any effect preset  
  - Visualize particles  
  - Test screen shake  
  - Test weather  

---

# **9. Integration Notes (Luanti Compatibility)**

- Uses `minetest.add_particle` and `add_particlespawner` for visuals.
- Uses `minetest.sound_play` for audio.
- Uses HUD overlays for screen effects.
- Weather is applied per‑player to avoid global performance issues.
- All effects must be lightweight and optimized.

---

# **10. Success Criteria**

`core_effects` is correct when:

- Effects are fully data‑driven.
- Modules can trigger effects with a single call.
- Weather integrates cleanly with dimensions.
- Screen effects are smooth and non‑intrusive.
- No gameplay logic exists in this module.
- Effects never crash the engine even with malformed data.

---
