```markdown
# core_simulation/DESIGN.md
Global World-State Engine for ALife Behavior

---

## 1. Purpose

`core_simulation` is the global world‑state engine for ALife‑style behavior in GURPScraft.  
It simulates off‑screen world dynamics across a large, bounded logical world (≈ 65,536 × 65,536 nodes), including:

- Faction territories and influence  
- Squad movement and conflict  
- POI ownership and strategic state  
- Background events and world evolution independent of player presence  

It does not render anything, spawn entities directly, or define game‑specific content.  
It provides a clean, game‑agnostic simulation layer that other modules (e.g., `game_wasteland`) can plug into.

---

## 2. Responsibilities

### High‑level responsibilities
- **Global simulation clock**
  - Maintain world tick counter and schedule
  - Run periodic simulation steps with a configurable time budget

- **Region‑based simulation grid**
  - Maintain a logical grid of simulation regions
  - Map world coordinates to regions and vice versa

- **POI registry**
  - Track registered POIs, positions, owning faction, and strategic metadata
  - Track POI state changes (ownership, alert level, etc.)

- **Faction territory and influence**
  - Maintain region‑level territory map
  - Track influence values per faction per region
  - Resolve territory control and contested states

- **Squad registry and movement**
  - Track squads as abstract world actors
  - Simulate squad movement between regions
  - Resolve conflicts between squads and territory

- **Event hooks and notifications**
  - Emit events when:
    - Territory changes hands
    - POI ownership changes
    - Squads are created/destroyed/merge/split
    - Region conflicts occur
  - Provide hooks for `core_quests`, `core_factions`, `core_actors`, and game modules

- **Persistence**
  - Persist simulation state (regions, POIs, squads, clock)
  - Load and resume state on server start

### Non‑responsibilities
`core_simulation` does **not**:
- Generate terrain  
- Spawn or control individual actors/entities  
- Handle entity‑level combat  
- Define factions or POI types  
- Render UI  
- Assign or manage quests directly  

---

## 3. World Model and Simulation Grid

### 3.1 Logical World Bounds
- Simulation world: 65,536 × 65,536 nodes  
- Centered around (0, 0) in X/Z (configurable)

### 3.2 Region Grid
- Region size: **128 × 128** nodes  
- Grid size: **512 × 512** regions  
- Each region identified by integer `(rx, rz)`

Coordinate mapping:
```lua
local rx = math.floor(x / REGION_SIZE)
local rz = math.floor(z / REGION_SIZE)
```

Region bounds:
```lua
local minx = rx * REGION_SIZE
local maxx = minx + REGION_SIZE - 1
local minz = rz * REGION_SIZE
local maxz = minz + REGION_SIZE - 1
```

Simulation is 2D in X/Z.

---

## 4. Core Data Structures

### 4.1 POI Registry
```lua
{
  id = "string",
  pos = { x=0, y=0, z=0 },
  region = { rx=0, rz=0 },
  faction_id = nil or "string",
  strategic_value = 0.0,
  tags = { "string", ... },
  state = {
    alert_level = 0,
    lastsimtick = 0,
  },
  metadata = {},
}
```

### 4.2 Faction Territory and Influence
```lua
{
  rx = 0,
  rz = 0,
  ownerfactionid = nil or "string",
  contested = false,
  influence = {
    ["faction_a"] = 10.0,
    ["faction_b"] = 5.0,
  },
  lastsimtick = 0,
}
```

### 4.3 Squad Registry
```lua
{
  id = "string",
  faction_id = "string",
  region = { rx=0, rz=0 },
  target_region = { rx=0, rz=0 },
  behavior = "patrol",
  strength = 1.0,
  supplies = 1.0,
  morale = 1.0,
  state = {
    path = { {rx=0,rz=0}, ... },
    path_index = 1,
    lastsimtick = 0,
  },
  metadata = {},
}
```

### 4.4 Global Simulation Clock
```lua
simulation_state = {
  tick = 0,
  lastrealtime = 0.0,
}
```

---

## 5. Inputs and Outputs

### 5.1 Inputs
From:
- **core_worldgen** — POI definitions, region metadata  
- **core_factions** — faction definitions, initial territory, behavior parameters  
- **core_quests** — quest‑relevant region/POI flags  
- **core_actors** — battle outcomes, spawn/despawn requests  
- **game modules** — POI types, faction IDs, squad templates  

### 5.2 Outputs
To:
- **core_factions** — territory changes, influence updates  
- **core_quests** — POI captured, region contested, faction expansion events  
- **core_actors** — squad presence, spawn hints  
- **core_worldgen** — dynamic POI state  
- **game modules** — event callbacks  

---

## 6. Public API

### 6.1 Initialization
- `core_simulation.init()`
- `core_simulation.shutdown()`

### 6.2 POI Management
- `core_simulation.register_poi(def)`
- `core_simulation.get_poi(id)`
- `core_simulation.get_pois_in_region(rx, rz)`
- `core_simulation.set_poi_faction(id, factionid)`

### 6.3 Territory and Regions
- `core_simulation.get_region(rx, rz)`
- `core_simulation.get_region_owner(rx, rz)`
- `core_simulation.get_region_influence(rx, rz)`
- `core_simulation.set_region_influence(rx, rz, factionid, value)`
- `core_simulation.add_region_influence(rx, rz, factionid, delta)`
- `core_simulation.world_to_region(x, z)`
- `core_simulation.region_to_world_bounds(rx, rz)`

### 6.4 Squad Management
- `core_simulation.create_squad(def)`
- `core_simulation.get_squad(id)`
- `core_simulation.get_squads_in_region(rx, rz)`
- `core_simulation.set_squad_target(id, targetregion)`
- `core_simulation.destroy_squad(id)`

### 6.5 Actor Tracking
- `core_simulation.register_actor(actor_id, faction_id, pos)`
- `core_simulation.update_actor_position(actor_id, pos)`
- `core_simulation.unregister_actor(actor_id)`

### 6.5 Simulation Control
- `core_simulation.get_tick()`
- `core_simulation.step(dt)`
- `core_simulation.force_step()`

### 6.6 Event Registration
- `core_simulation.register_callback(event_name, fn)`
- `core_simulation.unregister_callback(event_name, fn)`

---

## 7. Internal Architecture

### 7.1 File Structure
```
core_simulation/
  init.lua
  api.lua
  state.lua
  grid.lua
  poi.lua
  territory.lua
  squads.lua
  tick.lua
  events.lua
  config.lua
```

### 7.1 File Structure
```
core_simulation/
  init.lua
  api.lua
  state.lua
  grid.lua
  poi.lua
  territory.lua
  squads.lua
  actors.lua
  tick.lua
  events.lua
  config.lua
```

### 7.2 Tick Pipeline
1. Update clock  
2. Process a budgeted subset of regions  
3. Move squads  
4. Resolve conflicts  
5. Update influence and ownership  
6. Update POIs  
7. Dispatch events  

---

## 8. Performance and Constraints

- Tick interval: default 10 seconds  
- Regions per tick: budgeted (e.g., 64)  
- Lazy region creation  
- Persistence via snapshots or dirty flags  
- Single‑threaded; keep per‑tick work small  

---

## 9. Integration Patterns

### 9.1 With core_worldgen
- Register POIs  
- Query POI state for decoration  

### 9.2 With core_factions
- Seed initial influence  
- React to territory changes  

### 9.3 With core_actors
- Spawn/despawn actor groups based on squad presence  
- Report battle outcomes  

### 9.4 With core_quests
- Generate or advance quests based on events  

### 9.5 With game modules
- Provide faction/POI/squad templates  
- Custom callbacks  

---

## 10. Configuration

`core_simulation/config.lua`:
- REGION_SIZE  
- GRID_SIZE  
- TICK_INTERVAL  
- REGIONS_PER_TICK  
- Influence thresholds  
- Default squad behavior parameters  

---

## 11. Future Extensions

- Weather‑aware simulation  
- Economy and trade routes  
- Anomaly‑aware movement  
- Player impact feedback loops  
- Multi‑layer simulation (surface/underground/backrooms)  

---

## 12. Completion Criteria

`core_simulation` MVP is complete when:

1. Region grid and coordinate mapping work  
2. POIs can be registered and updated  
3. Regions track influence and ownership  
4. Squads move and are simulated  
5. Ticks update world‑state  
6. Events are emitted and consumed  
7. State persists across restarts  
```