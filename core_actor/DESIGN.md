```markdown
# core_actors/DESIGN.md
Unified Actor System for the ALife Architecture

---

## 1. Purpose

`core_actors` is the unified actor system for the GURPScraft engine.  
It defines how all actors—players, NPCs, creatures, robots, drones, summons, and any entity with autonomous behavior—are represented, updated, and integrated into the ALife simulation loop.

This module handles:

- Actor initialization and metadata  
- Actor state machine  
- Perception system  
- Behavior trees  
- ALife goal processing  
- Navigation and steering  
- Combat decision‑making (not damage)  
- Actor lifecycle (spawn, despawn, death)  
- Integration with `core_simulation`, `core_factions`, and `core_quests`  

`core_actors` does **not** define combat damage, items, UI, worldgen, or game‑specific content.

---

## 2. Responsibilities

### 2.1 Actor Initialization
Handles:
- Creating actor entities  
- Loading archetypes  
- Assigning stats (`core_stats`)  
- Assigning faction (`core_factions`)  
- Assigning inventory (`core_inventory`)  
- Setting default behavior tree  
- Setting movement parameters  
- Registering actor with `core_simulation` for region tracking  

Supported actor types:
- Players  
- Humanoid NPCs  
- Monsters  
- Robots  
- Animals  
- Summons  
- Drones  

---

### 2.2 Actor State Machine
Defines actor states such as:
- Idle  
- EvaluatingObjective  
- MovingToObjective  
- ExecutingObjective  
- Patrol  
- Alert  
- Combat  
- Flee  
- Search  
- Blocked  
- Dead  

Each state includes:
- Entry logic  
- Update logic  
- Exit logic  
- Transition rules  

---

### 2.3 Perception System
Implements:
- Vision cones  
- Hearing radius  
- Line‑of‑sight checks  
- Alertness levels  
- Detection thresholds  
- Stealth modifiers (`core_stats`)  

Perception integrates with:
- Faction hostility  
- Combat suppression  
- Environmental modifiers  
- Magic effects (invisibility, illusions)  

---

### 2.4 Behavior Trees
Provides a modular behavior tree system:

Node types:
- Selector  
- Sequence  
- Condition  
- Action  
- Decorators (repeat, cooldown, invert)  

Behavior trees are defined in:
```
core_actors/data/behaviors.lua
```

---

### 2.5 ALife Goal Processing (Integration with core_quests)
Actors receive **objectives** from `core_quests` and convert them into internal **goals**.

Supported goals:
- Goal.GoTo  
- Goal.Investigate  
- Goal.Interact  
- Goal.Patrol  
- Goal.Flee  

Goal evaluation considers:
- Actor faction  
- Actor state  
- Actor risk tolerance  
- Objective priority  
- Faction tags  

Actors may accept, reject, or defer objectives.

---

### 2.6 Navigation and Steering (Integration with core_simulation)
Actors handle their own movement:

- Pathfinding (A*, flow fields, or Luanti pathfinder)  
- Local avoidance  
- Dynamic rerouting  
- Hazard avoidance  
- Formation movement (if in squads)  
- Territory‑aware caution/aggression  

Actors must:
- Register their position with `core_simulation`  
- Update region membership  
- Join or leave squads  
- React to territory boundaries  

---

### 2.7 Combat Decision‑Making
Implements:
- Target selection  
- Engagement distance  
- Weapon choice  
- Reload logic  
- Retreat thresholds  
- Suppression response  

**No damage is applied here.**  
Damage resolution belongs to `core_combat`.

---

### 2.8 Actor Metadata
Stores:
- Faction  
- Stats  
- Inventory  
- Behavior tree  
- Current state  
- Perception data  
- Suppression level  
- Stamina (`core_physics`)  
- Current objective  
- Current goal  
- Region membership (`core_simulation`)  

---

### 2.9 Actor Lifecycle
Handles:
- Spawn  
- Despawn  
- Respawn (optional)  
- Death state  
- Corpse cleanup (optional)  

---

## 3. Non‑Responsibilities

`core_actors` does **not**:
- Calculate damage (`core_combat`)  
- Define items (`core_items`)  
- Render UI (`core_ui`)  
- Generate terrain (`core_worldgen`)  
- Define factions (`core_factions`)  
- Handle survival needs (`core_survival`)  
- Simulate region‑level world behavior (`core_simulation`)  

---

## 4. Dependencies

### External (Luanti)
- `minetest.register_entity`  
- `object:set_velocity`  
- `object:get_pos`  
- `minetest.find_path`  
- `minetest.after`  
- `minetest.get_objects_inside_radius`  

### Internal
- `core_foundation`  
- `core_stats`  
- `core_inventory`  
- `core_factions`  
- `core_combat`  
- `core_physics`  
- `core_effects`  
- `core_survival` (optional)  
- `core_data`  
- `core_simulation`  
- `core_quests`  

---

## 5. Public API Surface

All public functions are exposed via `core_actors/api.lua`.

### 5.1 Actor Creation
- `actors.spawn(archetype_id, pos, data)`  
- `actors.despawn(actor)`  
- `actors.is_actor(objref)`  

### 5.2 Actor Metadata
- `actors.get_faction(actor)`  
- `actors.set_faction(actor, faction_id)`  
- `actors.get_stats(actor)`  
- `actors.get_inventory(actor)`  
- `actors.get_behavior(actor)`  

### 5.3 Behavior & State
- `actors.set_state(actor, state_id)`  
- `actors.get_state(actor)`  
- `actors.update(actor, dtime)`  
- `actors.run_behavior(actor, dtime)`  

### 5.4 Perception
- `actors.can_see(actor, target)`  
- `actors.can_hear(actor, target)`  
- `actors.get_targets_in_range(actor, radius)`  
- `actors.get_alertness(actor)`  

### 5.5 Movement
- `actors.move_towards(actor, pos)`  
- `actors.move_away(actor, pos)`  
- `actors.stop(actor)`  
- `actors.pathfind(actor, pos)`  

### 5.6 Combat Decisions
- `actors.choose_target(actor)`  
- `actors.should_flee(actor)`  
- `actors.should_reload(actor)`  
- `actors.should_switch_weapon(actor)`  

### 5.7 Lifecycle
- `actors.kill(actor)`  
- `actors.respawn(actor)`  
- `actors.is_dead(actor)`  

### 5.8 ALife Integration
- `actors.receive_objective(actor, objective)`  
- `actors.assign_objective(actor, objective)`  
- `actors.evaluate_objective(actor, objective)`  
- `actors.report_progress(actor, objective_id, status)`  
- `actors.join_squad(actor, squad_id)`  
- `actors.leave_squad(actor)`  
- `actors.broadcast_objective(faction_id, objective)`  

---

## 6. Internal Structure

```
core_actors/
  api.lua
  init.lua
  internal/
    actor_state.lua
    behavior_tree.lua
    perception.lua
    movement.lua
    combat_ai.lua
    alife_goals.lua
    metadata.lua
```

### actor_state.lua
- State machine  
- Transitions  
- Update logic  

### behavior_tree.lua
- Node types  
- Execution logic  

### perception.lua
- Vision  
- Hearing  
- Alertness  

### movement.lua
- Pathfinding  
- Steering  
- Formation logic  

### combat_ai.lua
- Target selection  
- Engagement logic  

### goals.lua
- Objective → Goal conversion  
- Goal evaluation  
- Goal lifecycle  

### metadata.lua
- Actor metadata  
- Actor flags  
- Actor lifecycle  

---

## 7. Data Structure

### archetypes.lua
Defines actor templates.

```lua
return {
  raider = {
    faction = "raiders",
    stats = { ST=11, DX=10, IQ=9, HT=10 },
    inventory = { "pistol", "ammo_9mm" },
    behavior = "raider_behavior",
  }
}
```

### behaviors.lua
Defines behavior trees.

```lua
return {
  raider_behavior = {
    type = "selector",
    children = {
      "check_flee",
      "combat_engage",
      "patrol",
    }
  }
}
```

---

## 8. Debug Tools

`core_actors/debug/` may include:

- `spawn_actor.lua` — spawn any archetype  
- `ai_visualizer.lua` — show perception cones, behavior tree state, pathfinding  

---

## 9. ALife Integration Notes

### Region Awareness
Actors must:
- Register with `core_simulation`  
- Update region membership  
- React to region boundaries  
- Join or leave squads  

### Objective Processing
Actors must:
- Receive objectives from `core_quests`  
- Convert them into goals  
- Reevaluate goals on simulation ticks  

### Faction Influence
Actors must:
- Respect faction hostility  
- Modify behavior based on territory ownership  
- Adjust aggression/caution based on influence  

---

## 10. Success Criteria

`core_actors` is correct when:

1. Actors accept and execute ALife objectives  
2. Behavior trees are fully data‑driven  
3. Perception works reliably  
4. Movement integrates with physics and navigation  
5. Combat decisions integrate with `core_combat`  
6. Faction hostility drives behavior  
7. Region membership updates in `core_simulation`  
8. No game‑specific content exists in this module  

---
```