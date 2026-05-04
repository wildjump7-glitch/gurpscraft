```markdown
# ALIFE_UPDATE.md
Directive Prompt for Updating core_simulation, core_factions, core_quests, and core_actors

---

## 1. Purpose

This document instructs GitHub Copilot to update the following modules:

- `core_simulation`
- `core_factions`
- `core_quests`
- `core_actors`

The goal is to implement the unified ALife architecture described in **ALIFE_DESIGN.md**, ensuring all modules integrate cleanly into a closed feedback loop:

```
core_simulation → core_factions → core_quests → core_actors → back to core_simulation
```

All updates must maintain strict module boundaries, use explicit public APIs, and avoid cross‑module leakage.

---

## 2. Global Requirements

Copilot must ensure:

- All four modules implement the responsibilities defined in **ALIFE_DESIGN.md**  
- All DESIGN.md files are updated to reflect the new ALife architecture  
- All modules integrate with the region grid, territory system, POI registry, squad registry, and world clock  
- All modules communicate only through public APIs and event hooks  
- No game‑specific content is introduced  

---

## 3. Module Update Requirements

---

# 3.1 core_simulation Updates

`core_simulation` is already structurally complete.  
Copilot must ensure it exposes the APIs required by the ALife system:

### Region Grid
- `world_to_region(x, z)`
- `region_to_world_bounds(rx, rz)`

### Territory & Influence
- `get_region_owner(rx, rz)`
- `get_region_influence(rx, rz)`
- `add_region_influence(rx, rz, faction_id, delta)`
- `register_callback("onterritorychanged", fn)`

### POI Registry
- `register_poi(def)`
- `set_poi_faction(id, faction_id)`
- `update_poi_state(id, state)`
- `register_callback("onpoicaptured", fn)`

### Squad Registry
- `create_squad(def)`
- `set_squad_target(id, target_region)`
- `get_squads_in_region(rx, rz)`
- `register_callback("onsquadcreated", fn)`
- `register_callback("onsquaddestroyed", fn)`

### World Clock
- `on_tick(callback)`
- `get_tick()`

Copilot must update `core_simulation/DESIGN.md` to include ALife integration details.

---

# 3.2 core_factions Updates

Copilot must update `core_factions` to:

### Integrate with core_simulation
- Read region ownership and influence  
- Detect contested regions  
- Adjust influence values  
- Create or redirect squads  

### Provide strategic signals
- Objective priority modifiers for `core_quests`  
- Faction tags for filtering  
- Territory‑aware behavior modifiers for `core_actors`  

### Update DESIGN.md
Add sections for:
- Territory & influence integration  
- ALife strategic hooks  
- Region‑aware faction behavior  

---

# 3.3 core_quests Updates

Copilot must update `core_quests` to implement:

### Quest Nodes
- Register quest nodes with `core_simulation`  
- Subscribe to simulation events  
- Update on world ticks  
- Broadcast objectives region‑wide  
- Filter objectives by faction tags  

### Objective Schema
Ensure objectives follow:

```lua
{
  id = "string",
  type = "goto" | "investigate" | "interact" | "patrol" | "flee",
  target = {
    pos = {x,y,z} OR
    entity_id = string OR
    area_id = string
  },
  radius = number,
  priority = number,
  faction_tags = { ... },
}
```

### Event Integration
Quest nodes must react to:
- `onterritorychanged`
- `onpoicaptured`
- `onregionconflict`
- `onsquadcreated`
- `onsquaddestroyed`

### Tick Integration
Quest nodes must:
- Regenerate objectives  
- Expire stale objectives  
- Update POI alert levels  

### Update DESIGN.md
Add:
- Region‑aware broadcasting  
- Simulation event integration  
- Tick‑driven objective lifecycle  

---

# 3.4 core_actors Updates

Copilot must update `core_actors` to implement the ALife actor pipeline:

### Layer 1 — Intent → Goal
- Convert objectives into internal goals  
- Evaluate goals using faction logic  
- Accept/reject objectives  

### Layer 2 — Goal → Path
- Request paths  
- Integrate with region grid  
- Update region membership in `core_simulation`  
- Join/leave squads  

### Layer 3 — Path → Steering
- Local avoidance  
- Behavior blending  
- Formation movement  
- Territory‑aware caution/aggression  

### Actor State Machine
Ensure states include:
- Idle  
- EvaluatingObjective  
- MovingToObjective  
- ExecutingObjective  
- Patrol  
- Alert  
- Combat  
- Flee  
- Blocked  
- Dead  

### Update DESIGN.md
Add:
- ALife goal processing  
- Region‑aware movement  
- Squad integration  
- Territory‑aware behavior  

---

## 4. Cross‑Module API Contracts

Copilot must ensure the following APIs exist and are used consistently:

### core_quests → core_actors
- `actors.receive_objective(actor, objective)`
- `actors.evaluate_objective(actor, objective)`
- `actors.report_progress(actor, objective_id, status)`

### core_actors → core_simulation
- `core_simulation.register_actor(actor_id, faction_id, pos)`
- `core_simulation.update_actor_position(actor_id, pos)`
- Region membership updates

### core_factions → core_simulation
- Influence adjustments  
- Squad creation  
- Squad movement orders  

### core_simulation → all modules
Event callbacks:
- `onterritorychanged`
- `onpoicaptured`
- `onregionconflict`
- `onsquadcreated`
- `onsquaddestroyed`
- Tick updates  

---

## 5. Implementation Order

Copilot must follow this sequence:

1. Update `core_simulation` public API  
2. Update `core_factions`  
3. Update `core_factions/DESIGN.md`  
4. Update `core_quests`  
5. Update `core_quests/DESIGN.md`  
6. Update `core_actors`  
7. Update `core_actors/DESIGN.md`  
8. Update `core_simulation/DESIGN.md`  
9. Validate cross‑module API consistency  

---

## 6. Completion Criteria

The update is complete when:

- All modules integrate with the region grid  
- Quest nodes register as POIs and react to simulation events  
- Actors accept and execute ALife objectives  
- Factions influence territory, squads, and objective priority  
- Squads move and conflict across regions  
- POI state changes trigger quest updates  
- DESIGN.md files reflect the unified ALife architecture  
- The ALife feedback loop runs continuously and consistently  

---
```