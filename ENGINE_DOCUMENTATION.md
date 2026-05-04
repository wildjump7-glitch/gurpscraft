# GURPScraft Engine — Complete Documentation

## Overview

GURPScraft is a **modular, data-driven RPG/simulation engine** built on Luanti. It provides complete systems for any RPG genre: fantasy, sci-fi, post-apocalypse, tactical shooters, horror, and more.

The engine follows the **GURPS design philosophy**: attributes → skills → traits → systems → content.

## Engine Modules

### Foundational Layer

#### core_foundation
Base utilities, logging, configuration, and module infrastructure.
- `core_foundation.log(module, message)` — Log a message
- `core_foundation.warn(module, message)` — Log a warning
- `core_foundation.error(module, message)` — Log an error and optionally halt

#### core_data
Optional data management utilities for schemas, templates, and validation.

#### core_stats
The heart of the engine: attributes, skills, traits, and stat checks.
- `core_stats.get_stat(actor, stat_name)` — Get a stat value
- `core_stats.set_stat(actor, stat_name, value)` — Set a stat value
- `core_stats.stat_check(actor, stat_name, difficulty)` — Roll 3d6, compare to skill

### Item & Inventory Layer

#### core_items
Item registry, metadata, tags, and effects.
- `core_items.register(id, definition)` — Register an item type
- `core_items.get(id)` — Get item definition
- `core_items.apply_effect(actor, item_id)` — Apply item effect

#### core_inventory
Advanced inventory management: equipment slots, weight, encumbrance.
- `core_inventory.add_item(actor, item_id, quantity)` — Add item to inventory
- `core_inventory.remove_item(actor, item_id, quantity)` — Remove item
- `core_inventory.equip(actor, item_id, slot)` — Equip item to slot
- `core_inventory.get_encumbrance(actor)` — Get total weight/limit

### Combat & Physics Layer

#### core_combat
Real-time tactical combat system with raycast ballistics, penetration, and hit zones.
- `core_combat.apply_damage(actor, amount, damage_type)` — Deal damage
- `core_combat.fire_weapon(actor, weapon_id, target)` — Fire a ranged weapon
- `core_combat.melee_attack(actor, target, weapon_id)` — Perform melee attack

#### core_physics
Movement, stamina, fall damage, knockback, climbing, swimming.
- `core_physics.apply_knockback(actor, direction, force)` — Push an actor
- `core_physics.drain_stamina(actor, amount)` — Reduce stamina
- `core_physics.apply_fall_damage(actor, height)` — Apply fall damage

#### core_effects
Particle systems, screen effects, weather, sound effects.
- `core_effects.spawn_particles(pos, preset)` — Spawn particles
- `core_effects.play_sound(pos, sound_id)` — Play a sound
- `core_effects.screen_effect(player, effect_type, duration)` — Apply screen effect

#### core_ui
HUD system, status effects, notifications, icon registry.
- `core_ui.show_notification(player, message, duration)` — Show notification
- `core_ui.update_hud(player, hud_id, value)` — Update HUD element
- `core_ui.show_status_effect(player, effect_id)` — Display status effect icon

### World & Simulation Layer

#### core_worldgen
Procedural world generation: biomes, noise, structure placement, POIs.
- `core_worldgen.get_biome(pos)` — Get biome at position
- `core_worldgen.register_structure(id, definition)` — Register a structure
- `core_worldgen.generate_chunk(chunk_pos)` — Generate a chunk

#### core_dimension
Multi-dimension support with rulesets and teleportation.
- `core_dimension.teleport(actor, destination)` — Teleport to another dimension
- `core_dimension.get_ruleset(dimension_id)` — Get dimension rules
- `core_dimension.load_dimension(dimension_id)` — Load a dimension

#### core_anomalies
Environmental hazards and artifacts.
- `core_anomalies.apply(pos, anomaly_id)` — Apply anomaly at position
- `core_anomalies.create_field(pos, field_type, intensity)` — Create hazard field
- `core_anomalies.get_artifact(id)` — Get artifact definition

#### core_survival
Hunger, thirst, temperature, radiation, diseases, poisons.
- `core_survival.modify_hunger(actor, amount)` — Modify hunger value
- `core_survival.modify_thirst(actor, amount)` — Modify thirst value
- `core_survival.modify_radiation(actor, amount)` — Modify radiation exposure
- `core_survival.apply_disease(actor, disease_id)` — Apply a disease

### Advanced Systems Layer

#### core_machines
Machines, processing stations, power networks, multiblock structures.
- `core_machines.register(id, definition)` — Register a machine type
- `core_machines.process(machine_pos, input)` — Process input through machine
- `core_machines.transfer_power(source, destination, amount)` — Transfer power

#### core_magic
Spells, mana, rituals, enchantments.
- `core_magic.cast(actor, spell_id, target)` — Cast a spell
- `core_magic.modify_mana(actor, amount)` — Modify mana pool
- `core_magic.apply_enchantment(item_id, enchantment_id)` — Add enchantment

#### core_crafting
Crafting recipes, matching logic, quality modifiers.
- `core_crafting.execute_craft(actor, recipe_id, inputs)` — Perform craft
- `core_crafting.reverse_engineer(item_id)` — Analyze item for materials
- `core_crafting.get_quality(crafted_item)` — Get quality level of item

#### core_vehicles
Vehicle physics, damage, fuel, seats, cargo, AI pathfinding.
- `core_vehicles.spawn(pos, vehicle_id)` — Spawn a vehicle
- `core_vehicles.damage(vehicle_entity, amount)` — Damage vehicle
- `core_vehicles.fill_fuel(vehicle_entity, amount)` — Add fuel

#### core_destruction
Structural integrity, collapse mechanics, siege warfare, kaiju destruction.
- `core_destruction.apply_damage(pos, amount, damage_type)` — Damage block
- `core_destruction.check_support(pos)` — Check if block has support
- `core_destruction.trigger_collapse(pos, radius)` — Trigger structural collapse
- `core_destruction.create_breach(pos, radius)` — Create siege breach

### Social & Actor Layer

#### core_actor
Actors (NPCs), behavior trees, perception, AI, pathfinding.
- `core_actor.spawn(pos, actor_type)` — Spawn an NPC
- `core_actor.set_behavior(actor, behavior_id)` — Set behavior tree
- `core_actor.update_perception(actor)` — Update what actor can see

#### core_factions
Social systems: factions, reputation, relations, hostility, territories.
- `core_factions.register(id, definition)` — Register faction
- `core_factions.get_relation(faction_a, faction_b)` — Get relation between factions
- `core_factions.set_relation(faction_a, faction_b, stance)` — Set faction relation
- `core_factions.modify_reputation(actor, faction_id, amount)` — Modify reputation
- `core_factions.get_territory_owner(territory_id)` — Get territory controller

### Game Content Layer

#### game_wasteland
Wasteland game implementation using core APIs.
- Faction definitions (Scavengers, Enforcers, Wanderers)
- Weapons, ammo, armor, consumables, artifacts
- Biomes (Wasteland, Ruined City)
- NPCs and behaviors
- Anomalies and hazards
- Backroom levels and transitions
- Survival tuning and hazards
- UI customizations

## Data-Driven Content

All gameplay content lives in `/data/` subdirectories:

```
core_module/
  data/
    content_type.lua  -- Returns Lua table of definitions
    another_type.lua  -- More content
```

Example: `core_items/data/weapons.lua`

```lua
return {
    sword = {
        id = 'sword',
        damage = 10,
        weight = 2,
        tags = {'melee', 'sharp'},
    },
    bow = {
        id = 'bow',
        damage = 8,
        range = 20,
        tags = {'ranged', 'projectile'},
    },
}
```

## Module Isolation Rules

### Allowed
- Call another module's public API functions
- Read data from another module's `/data/` directory
- Use utilities from `core_foundation`

### Forbidden
- Access another module's `internal/` directory
- Modify another module's internal state
- Create circular dependencies
- Hardcode references to game content in core modules

## API Patterns

### Public API Functions
Every module exports a table with public functions:

```lua
return {
    get_thing = function(id) ... end,
    create_thing = function(def) ... end,
    destroy_thing = function(id) ... end,
}
```

### Data Access
Access data via module's public getters:

```lua
local weapon = core_items.get_weapon('sword')
local biome = core_worldgen.get_biome(pos)
local faction = core_factions.get_faction('scavengers')
```

### Error Handling
Use `core_foundation` error utilities:

```lua
core_foundation.warn("module_name", "Something went wrong but it's not fatal")
core_foundation.error("module_name", "Critical error, log and stop")
```

## Integration & Load Order

Modules load in this exact order (see `init_engine.lua`):

1. core_foundation
2. core_data
3. core_stats
4. core_items
5. core_inventory
6. core_combat
7. core_physics
8. core_effects
9. core_ui
10. core_worldgen
11. core_dimension
12. core_anomalies
13. core_actor
14. core_factions
15. core_survival
16. core_machines
17. core_magic
18. core_crafting
19. core_vehicles
20. core_destruction
21. game_wasteland

## Testing

Run the test suite:

```lua
dofile('test_suite.lua')
```

Run the code audit:

```lua
dofile('code_audit.lua')
```

## Extending GURPScraft

To create a new game using GURPScraft:

1. Create a new `game_mymod` directory
2. Define content in `game_mymod/data/`
3. Use core module public APIs via `core_*` globals
4. Add custom mechanics via new modules that depend on core

## Design Philosophy

- **Modular**: Each system is independent and composable
- **Data-Driven**: Content is tables, logic is code
- **Extensible**: Games extend, don't modify core
- **Maintainable**: Clear APIs, no magic, explicit dependencies
- **Scalable**: Works for small mods or massive games
- **Compatible**: Uses only documented Luanti APIs
