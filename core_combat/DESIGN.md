### **core_combat / DESIGN.md**

---

# **1. Purpose**

`core_combat` is the **unified real‑time combat simulation system** for the GURPScraft engine.  
It provides a **data‑driven, modular, extensible** framework for:

- Ranged combat (raycast ballistics)  
- Melee combat (hitboxes, swing arcs, parry/block)  
- Damage calculation  
- Hit zones  
- Armor interaction  
- Suppression  
- Weapon state (ADS, reload, fire modes)  
- Combat effects (stagger, bleed, shock penalties)  

This module contains **no item definitions**, **no actor AI**, and **no game‑specific values**.  
It defines *how combat works*, not *what weapons exist*.

---

# **2. Responsibilities**

### **2.1 Ranged Combat (Raycast Ballistics)**
Implements:
- Raycast projectile simulation  
- Penetration through materials  
- Damage falloff  
- Accuracy & spread  
- Recoil patterns  
- Fire modes (semi, burst, auto)  
- Muzzle velocity & ballistic drop (optional)  

### **2.2 Melee Combat**
Implements:
- Swing arcs  
- Hitboxes  
- Parry/block mechanics  
- Weapon reach  
- Combo chains (optional)  
- Stagger & knockback (via `core_physics`)  

### **2.3 Hit Zones**
Defines:
- Body regions (head, torso, arms, legs)  
- Multipliers  
- Armor coverage  
- Special effects (e.g., leg hits reduce speed)  

### **2.4 Damage System**
Handles:
- Damage types (ballistic, blunt, slash, fire, magic, etc.)  
- Armor class & penetration  
- DR (damage reduction)  
- Bleeding  
- Shock penalties (via `core_stats`)  
- Critical hits (optional)  

### **2.5 Suppression**
Implements:
- Suppression radius  
- Suppression intensity  
- Actor suppression state  
- Effects on accuracy, movement, and AI  

### **2.6 Weapon State Machine**
Tracks:
- ADS (aim down sights)  
- Reloading  
- Chambered round  
- Heat buildup (optional)  
- Jam/misfire (optional)  

### **2.7 Combat Effects**
Integrates with `core_effects` to trigger:
- Muzzle flashes  
- Impact particles  
- Screen shake  
- Sound effects  
- Hit markers (optional)  

### **2.8 Integration with Other Modules**
- `core_items` → weapon stats  
- `core_stats` → skill modifiers  
- `core_inventory` → equipped weapons  
- `core_physics` → knockback, movement penalties  
- `core_actor` → AI combat behavior  

---

# **3. Non‑Responsibilities**

- No weapon definitions  
- No ammo definitions  
- No actor AI  
- No UI rendering  
- No faction logic  
- No worldgen logic  
- No survival logic  

Those belong to other modules.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.raycast`
  - `minetest.add_particle`
  - `minetest.sound_play`
  - `minetest.get_objects_inside_radius`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (hit zone definitions, damage types)
- `core_items` (weapon metadata)
- `core_stats` (skill checks, shock penalties)
- `core_inventory` (equipped weapon lookup)
- `core_physics` (knockback, movement penalties)
- `core_effects` (visual/audio effects)

---

# **5. Public API Surface**

All public functions are exposed via `core_combat/api.lua`.

### **5.1 Ranged Combat**
- `combat.fire_weapon(actor, weapon_id, context)`
- `combat.raycast(origin, direction, range)`
- `combat.apply_recoil(actor, weapon_id)`
- `combat.get_spread(actor, weapon_id)`

### **5.2 Melee Combat**
- `combat.perform_melee_attack(actor, weapon_id)`
- `combat.get_melee_hitbox(actor, weapon_id)`
- `combat.parry(actor, weapon_id)`
- `combat.block(actor, weapon_id)`

### **5.3 Damage**
- `combat.apply_damage(target, amount, damage_type, hitzone)`
- `combat.calculate_damage(actor, weapon_id, hitzone)`
- `combat.apply_armor(target, damage, damage_type, hitzone)`

### **5.4 Hit Zones**
- `combat.get_hitzone(target, hit_position)`
- `combat.get_hitzone_multiplier(hitzone)`

### **5.5 Suppression**
- `combat.apply_suppression(target, intensity)`
- `combat.get_suppression(target)`

### **5.6 Weapon State**
- `combat.start_reload(actor)`
- `combat.finish_reload(actor)`
- `combat.toggle_fire_mode(actor)`
- `combat.set_ads(actor, enabled)`

---

# **6. Internal Structure**

`core_combat/internal/` contains implementation details:

### **ballistics.lua**
- Raycast logic  
- Penetration  
- Spread  
- Recoil  

### **recoil.lua**
- Recoil patterns  
- Skill modifiers  

### **hitzones.lua**
- Hit zone lookup  
- Multipliers  
- Armor coverage  

### **damage.lua**
- Damage calculation  
- Damage types  
- Bleeding  
- Shock penalties  

### **armor_calc.lua**
- Armor penetration  
- DR  
- Coverage  

### **suppression.lua**
- Suppression radius  
- Intensity decay  
- Actor suppression state  

### **weapon_state.lua**
- Reloading  
- ADS  
- Fire modes  
- Heat  

### **melee.lua**
- Swing arcs  
- Hitbox generation  
- Reach  
- Combo logic  

### **parry.lua**
- Parry chance  
- Skill checks  
- Weapon matchups  

### **hitbox.lua**
- Hitbox generation  
- Collision detection  

---

# **7. Data Structure**

`core_combat/data/` contains:

### **hitzones.lua**
Example:
```lua
return {
  head = { multiplier = 2.0, armor_slot = "helmet" },
  torso = { multiplier = 1.0, armor_slot = "torso" },
  arms = { multiplier = 0.75 },
  legs = { multiplier = 0.75 },
}
```

### **damage_types.lua**
Example:
```lua
return {
  ballistic = { armor = "pierce" },
  slash = { armor = "cut" },
  blunt = { armor = "impact" },
  fire = { armor = "none" },
}
```

---

# **8. Debug Tools**

`core_combat/debug/` may include:

- `hit_debug.lua`
  - Visualizes hit zones  
  - Shows damage calculations  

- `spawn_dummy.lua`
  - Spawns test targets  

- `ballistic_test.lua`
  - Visualizes raycasts  

---

# **9. Integration Notes (Luanti Compatibility)**

- Uses `minetest.raycast` for projectile simulation.
- Uses `object:set_hp()` for damage.
- Uses `object:get_pos()` for hit zone detection.
- Uses `minetest.add_particle` for impact effects.
- Uses `minetest.sound_play` for weapon sounds.

---

# **10. Success Criteria**

`core_combat` is correct when:

- Ranged and melee combat behave consistently.
- Damage calculation is predictable and data‑driven.
- Hit zones work reliably.
- Armor interacts correctly with damage types.
- Suppression affects actors meaningfully.
- Weapon state transitions are stable.
- No game‑specific content exists in this module.

---

