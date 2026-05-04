### **core_vehicles / DESIGN.md**

You’re expanding the engine into one of the most complex simulation domains — and this module needs to be *as clean, modular, and genre‑agnostic* as the rest of GURPScraft.  
Here is the full, production‑grade **core_vehicles** module, designed to integrate seamlessly with physics, actors, combat, survival, and dimensions.

---

# **1. Purpose**

`core_vehicles` provides the **unified vehicle simulation framework** for the GURPScraft engine.  
It defines the systems required for:

- Ground vehicles (cars, bikes, tanks, walkers)  
- Air vehicles (helicopters, VTOL, gliders, drones)  
- Water vehicles (boats, subs)  
- Hovercraft / mag‑lev / sci‑fi vehicles  
- Mounts (animals, mechs, summoned constructs)  
- Multi‑seat vehicles  
- Cargo & inventory integration  
- Damage, fuel, and maintenance  
- Vehicle physics abstraction  

This module contains **no game‑specific vehicles**, **no item definitions**, and **no worldgen**.  
It defines *how vehicles work*, not *what vehicles exist*.

---

# **2. Responsibilities**

### **2.1 Vehicle Registry**
Defines:
- Vehicle IDs  
- Vehicle class (ground, air, water, hover, mount)  
- Physics profile  
- Seats & seat roles  
- Cargo capacity  
- Fuel type & consumption  
- Health & armor  
- Hardpoints (weapons, tools)  
- Control scheme  

Vehicle definitions are fully data‑driven via:
```
core_vehicles/data/vehicles.lua
```

---

### **2.2 Vehicle Physics**
Implements a **vehicle‑specific physics layer** on top of `core_physics`:

- Acceleration  
- Max speed  
- Turning radius  
- Traction / drift  
- Suspension  
- Hover height  
- Buoyancy  
- Lift & drag (aircraft)  
- Mass & inertia  
- Collision response  

Physics profiles are defined in:
```
core_vehicles/data/physics_profiles.lua
```

---

### **2.3 Seats & Control**
Supports:
- Driver seat  
- Passenger seats  
- Gunner seats  
- Commander seats  
- Cargo seats  
- Mount rider logic  

Seat roles define:
- Allowed actions  
- Control permissions  
- UI overlays (via `core_ui`)  

---

### **2.4 Vehicle Damage System**
Implements:
- Vehicle HP  
- Armor  
- Damage types (ballistic, explosive, fire, EMP, anomalous)  
- Component damage (engine, wheels, rotors, fuel tank)  
- Critical failures  
- Fire & smoke effects (via `core_effects`)  

Integrates with:
- `core_combat` for damage application  
- `core_survival` for fire, heat, radiation  

---

### **2.5 Fuel & Power**
Supports:
- Fuel types (gasoline, diesel, biofuel, electricity, mana, anomaly charge)  
- Fuel consumption  
- Refueling  
- Battery charge  
- Overcharge / overload  
- Regenerative systems (solar, kinetic, magical)  

---

### **2.6 Cargo & Inventory**
Vehicles can have:
- Cargo slots  
- Equipment slots  
- Weapon hardpoints  
- Trunk / storage compartments  

Integrates with:
- `core_inventory`  
- `core_items`  

---

### **2.7 Vehicle Interaction**
Supports:
- Entering / exiting  
- Switching seats  
- Locking / unlocking  
- Hotwiring (skill‑based)  
- Repairs & maintenance  
- Towing & trailers  
- Vehicle‑to‑vehicle docking (sci‑fi)  

---

### **2.8 AI Vehicle Control**
Integrates with `core_actor` to support:
- NPC drivers  
- Patrol routes  
- Combat vehicles  
- Autonomous drones  
- Fleeing / chasing behavior  

---

### **2.9 Integration with Other Modules**
- `core_physics` → movement, gravity, knockback  
- `core_combat` → mounted weapons, vehicle damage  
- `core_effects` → engine FX, smoke, explosions  
- `core_survival` → heat, fire, radiation, oxygen (submarines)  
- `core_dimension` → gravity, sky, environmental rules  
- `core_factions` → faction‑owned vehicles  
- `core_items` → fuel, repair kits, ammo  
- `core_inventory` → cargo & equipment  

---

# **3. Non‑Responsibilities**

- No vehicle models or textures  
- No vehicle crafting recipes  
- No worldgen vehicle spawns  
- No faction logic  
- No UI formspecs  
- No combat damage formulas  

Those belong to other modules or the game layer.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.register_entity`
  - `object:set_velocity`
  - `object:get_velocity`
  - `object:set_acceleration`
  - `minetest.add_particlespawner`
  - `minetest.sound_play`
  - `minetest.get_objects_inside_radius`

### **Internal**
- `core_foundation`  
- `core_data`  
- `core_physics`  
- `core_combat`  
- `core_effects`  
- `core_inventory`  
- `core_items`  
- `core_survival`  
- `core_dimension`  
- `core_actor`  

---

# **5. Public API Surface**

All public functions are exposed via `core_vehicles/api.lua`.

### **5.1 Vehicle Registry**
- `vehicles.register(id, def)`
- `vehicles.get(id)`
- `vehicles.all()`

### **5.2 Spawning**
- `vehicles.spawn(id, pos, data)`
- `vehicles.despawn(vehicle)`
- `vehicles.is_vehicle(objref)`

### **5.3 Control & Seats**
- `vehicles.enter(vehicle, actor, seat_id)`
- `vehicles.exit(vehicle, actor)`
- `vehicles.switch_seat(vehicle, actor, seat_id)`
- `vehicles.get_seat_role(vehicle, seat_id)`

### **5.4 Movement & Physics**
- `vehicles.set_throttle(vehicle, value)`
- `vehicles.set_steering(vehicle, value)`
- `vehicles.apply_physics(vehicle, dtime)`
- `vehicles.get_speed(vehicle)`

### **5.5 Damage**
- `vehicles.apply_damage(vehicle, amount, damage_type)`
- `vehicles.get_health(vehicle)`
- `vehicles.set_health(vehicle, value)`
- `vehicles.damage_component(vehicle, component_id)`

### **5.6 Fuel & Power**
- `vehicles.get_fuel(vehicle)`
- `vehicles.add_fuel(vehicle, amount)`
- `vehicles.consume_fuel(vehicle, amount)`
- `vehicles.is_out_of_fuel(vehicle)`

### **5.7 Cargo**
- `vehicles.get_cargo(vehicle)`
- `vehicles.add_cargo(vehicle, itemstack)`
- `vehicles.remove_cargo(vehicle, itemstack)`

### **5.8 AI**
- `vehicles.ai_drive(vehicle, target_pos)`
- `vehicles.ai_flee(vehicle, threat_pos)`
- `vehicles.ai_patrol(vehicle, route)`

---

# **6. Internal Structure**

`core_vehicles/internal/` contains implementation details:

### **physics.lua**
- Acceleration  
- Turning  
- Traction  
- Hover physics  
- Flight physics  

### **damage.lua**
- Component damage  
- Critical failures  
- Fire & smoke  

### **fuel.lua**
- Fuel consumption  
- Refueling  
- Power systems  

### **seats.lua**
- Seat roles  
- Enter/exit logic  
- Seat switching  

### **cargo.lua**
- Inventory integration  

### **ai.lua**
- NPC driving  
- Pathfinding  
- Combat vehicle logic  

These files are not exposed directly.

---

# **7. Data Structure**

`core_vehicles/data/` contains:

### **vehicles.lua**
Example:
```lua
return {
  dune_buggy = {
    class = "ground",
    physics = "light_vehicle",
    seats = {
      driver = { role = "driver" },
      passenger = { role = "passenger" },
    },
    cargo = 20,
    fuel = { type = "gasoline", capacity = 40 },
    health = 150,
  }
}
```

### **physics_profiles.lua**
Example:
```lua
return {
  light_vehicle = {
    acceleration = 6,
    max_speed = 20,
    turn_rate = 2.5,
    traction = 0.8,
    mass = 800,
  }
}
```

### **components.lua**
Example:
```lua
return {
  engine = { hp = 50 },
  wheels = { hp = 20 },
  fuel_tank = { hp = 30 },
}
```

---

# **8. Debug Tools**

`core_vehicles/debug/` may include:

- `spawn_vehicle.lua`  
- `vehicle_inspector.lua`  
- `vehicle_physics_test.lua`  
- `vehicle_ai_test.lua`  

---

# **9. Integration Notes (Luanti Compatibility)**

- Vehicles are entities, not nodes.  
- Physics uses `set_velocity` and `set_acceleration`.  
- Collision detection uses bounding boxes.  
- Seats use player attachment.  
- Fuel and cargo use metadata tables.  

---

# **10. Success Criteria**

`core_vehicles` is correct when:

- Vehicles move predictably and consistently.  
- Physics profiles are fully data‑driven.  
- Seats and controls work for players and AI.  
- Damage and fuel systems behave reliably.  
- Cargo integrates with inventory.  
- No game‑specific content exists in this module.  

---

