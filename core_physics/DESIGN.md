### **core_physics / DESIGN.md**

---

# **1. Purpose**

`core_physics` provides the **unified physical simulation layer** for the GURPScraft engine.  
It centralizes all movement‑related, force‑related, and stamina‑related mechanics into a single, predictable system.

This module exists because:
- Combat, survival, and actor movement all depend on physics.  
- Encumbrance, knockback, fall damage, and stamina should not be scattered across modules.  
- Future systems (vehicles, flight, zero‑gravity, underwater physics) need a stable foundation.

`core_physics` contains **no combat logic**, **no item logic**, and **no worldgen logic**.  
It defines *how actors move and interact with forces*, not *why*.

---

# **2. Responsibilities**

### **2.1 Movement Modifiers**
Handles all movement‑related calculations:
- Base movement speed  
- Encumbrance penalties (from `core_inventory`)  
- Terrain modifiers (optional)  
- Stamina penalties  
- Suppression penalties (from `core_combat`)  
- Trait‑based modifiers (from `core_stats`)  

Movement modifiers are applied to:
- Player physics overrides  
- NPC movement logic  

### **2.2 Fall Damage**
Implements:
- Fall height detection  
- Damage calculation  
- Trait modifiers (e.g., Catfall)  
- Armor mitigation (optional)  
- Landing effects (stagger, screen shake)  

### **2.3 Knockback**
Handles:
- Directional knockback  
- Magnitude scaling  
- Mass‑based resistance  
- Integration with melee and explosions  

### **2.4 Climbing**
Supports:
- Ladder climbing  
- Climbable surfaces  
- Trait‑based climbing (e.g., Spider Climb)  
- Stamina drain while climbing  

### **2.5 Swimming**
Implements:
- Buoyancy  
- Swim speed  
- Stamina drain  
- Drowning thresholds  
- Trait modifiers (e.g., Amphibious)  

### **2.6 Encumbrance Integration**
Uses weight data from `core_inventory` to apply:
- Movement penalties  
- Jump height reduction  
- Stamina drain increase  
- Dodge/evade penalties  

### **2.7 Stamina System**
Provides:
- Stamina pool  
- Stamina regeneration  
- Stamina drain from:
  - Sprinting  
  - Jumping  
  - Climbing  
  - Swimming  
  - Heavy attacks (via `core_combat`)  
- Exhaustion effects  

### **2.8 Environmental Forces**
Supports:
- Wind (optional)  
- Water currents (optional)  
- Gravity modifiers (dimension‑specific via `core_dimension`)  

---

# **3. Non‑Responsibilities**

- No combat damage  
- No weapon recoil  
- No item weight definitions  
- No AI behavior  
- No worldgen  
- No UI rendering  
- No survival needs (hunger, thirst, temperature)  

Those belong to other modules.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `player:set_physics_override`
  - `object:add_velocity`
  - `object:get_velocity`
  - `minetest.get_node`
  - `minetest.register_globalstep`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_stats` (traits, derived stats)
- `core_inventory` (weight, encumbrance)
- `core_combat` (knockback triggers)
- `core_dimension` (gravity modifiers)

---

# **5. Public API Surface**

All public functions are exposed via `core_physics/api.lua`.

### **5.1 Movement**
- `physics.get_move_speed(actor)`
- `physics.apply_movement(actor)`
- `physics.get_jump_height(actor)`
- `physics.apply_jump(actor)`

### **5.2 Fall Damage**
- `physics.apply_fall_damage(actor, fall_height)`
- `physics.get_fall_damage(fall_height, actor)`

### **5.3 Knockback**
- `physics.apply_knockback(actor, direction, magnitude)`
- `physics.get_knockback_resistance(actor)`

### **5.4 Climbing**
- `physics.is_climbing(actor)`
- `physics.apply_climb_movement(actor)`

### **5.5 Swimming**
- `physics.is_swimming(actor)`
- `physics.apply_swim_movement(actor)`
- `physics.apply_drowning(actor)`

### **5.6 Stamina**
- `physics.get_stamina(actor)`
- `physics.modify_stamina(actor, delta)`
- `physics.set_stamina(actor, value)`
- `physics.apply_stamina_drain(actor, amount)`
- `physics.apply_stamina_regen(actor)`

### **5.7 Environmental Forces**
- `physics.apply_wind(actor, vector)`
- `physics.apply_current(actor, vector)`
- `physics.get_gravity(actor)` (dimension‑aware)

---

# **6. Internal Structure**

`core_physics/internal/` contains implementation details:

### **movement.lua**
- Movement speed calculation  
- Encumbrance integration  
- Terrain modifiers  
- Sprinting logic  

### **fall_damage.lua**
- Fall height tracking  
- Damage calculation  
- Trait modifiers  

### **knockback.lua**
- Directional force application  
- Mass scaling  
- Integration with combat  

### **climbing.lua**
- Climb detection  
- Climb speed  
- Stamina drain  

### **swimming.lua**
- Buoyancy  
- Swim speed  
- Drowning logic  

### **encumbrance_modifiers.lua**
- Weight thresholds  
- Penalty curves  

### **stamina_drain.lua**
- Drain sources  
- Regen rules  
- Exhaustion effects  

These files are not exposed directly.

---

# **7. Data Structure**

`core_physics/data/` contains:

### **movement_modifiers.lua**
Example:
```lua
return {
  base_speed = 4.0,
  sprint_multiplier = 1.5,
  crouch_multiplier = 0.6,
}
```

### **stamina.lua**
Example:
```lua
return {
  max = 100,
  regen_rate = 5,
  sprint_drain = 10,
  swim_drain = 8,
}
```

### **gravity.lua**
Example:
```lua
return {
  default = 1.0,
  low_gravity = 0.5,
  high_gravity = 1.5,
}
```

---

# **8. Debug Tools**

`core_physics/debug/` may include:

- `physics_overlay.lua`
  - Shows movement speed  
  - Shows stamina  
  - Shows encumbrance penalties  
  - Shows gravity  

- `fall_test.lua`
  - Teleports actor to test heights  

---

# **9. Integration Notes (Luanti Compatibility)**

- Uses `player:set_physics_override` for movement changes.
- Uses `object:add_velocity` for knockback.
- Uses globalstep for stamina and movement updates.
- Uses node checks for climbing/swimming detection.
- Uses dimension gravity multipliers from `core_dimension`.

---

# **10. Success Criteria**

`core_physics` is correct when:

- Movement feels consistent and predictable.
- Encumbrance affects movement and stamina correctly.
- Fall damage is reliable and data‑driven.
- Knockback behaves naturally.
- Climbing and swimming work across all actors.
- Stamina integrates with combat, survival, and movement.
- No game‑specific values exist in this module.

---
