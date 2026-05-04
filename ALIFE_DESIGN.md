```markdown
# ALIFE_DESIGN.md
Unified Architecture Specification for the GURPScraft ALife System

---

## 1. Purpose

The ALife system is a cross‑module, closed‑loop simulation architecture that governs emergent world behavior in GURPScraft.  
It integrates four core modules:

- **core_simulation** — world‑state authority  
- **core_factions** — strategic decision‑making  
- **core_quests** — intent broadcasting  
- **core_actors** — autonomous agent behavior  

Together, these modules create a living world where:

- Regions change hands  
- Factions expand and retreat  
- Squads move and clash  
- POIs shift strategic state  
- Actors respond to world events  
- Quests emerge organically  

This document defines the complete ALife mental model and serves as the single source of truth for all ALife‑related updates.

---

## 2. High‑Level Architecture

The ALife system forms a closed feedback loop:

```
core_simulation → core_factions → core_quests → core_actors → back to core_simulation
```

Each module has a strict responsibility:

- **core_simulation** = world‑state  
- **core_factions** = strategy  
- **core_quests** = intent  
- **core_actors** = action  

This separation ensures modularity, predictability, and emergent behavior.

---

## 3. Module Responsibilities

---

### 3.1 core_simulation — The World‑State Authority

Simulates the world at a region level, not an entity level.

#### What it simulates
- 65,536 × 65,536 logical world  
- 512 × 512 region grid  
- Per‑region:
  - Faction influence  
  - Territory ownership  
  - Contested states  
  - Squads present  
  - POIs inside it  

#### Tick pipeline
1. Advance world clock  
2. Process a subset of regions  
3. Move squads  
4. Resolve conflicts  
5. Update influence  
6. Change territory ownership  
7. Update POI alert levels  
8. Emit events  

#### Provides
- Region ownership  
- Influence values  
- POI state  
- Squad presence  
- Territory change events  
- POI capture events  
- Region conflict events  
- World clock ticks  

---

### 3.2 core_factions — The Strategic Brain

Interprets world‑state and makes strategic decisions.

#### Inputs
From core_simulation:
- Territory ownership  
- Influence maps  
- POI states  
- Squad conflicts  
- Region alerts  

#### Outputs
To core_simulation:
- Influence adjustments  
- Squad creation  
- Squad movement orders  

To core_quests:
- Objective priority modifiers  
- Faction tags  

To core_actors:
- Hostility rules  
- Territory‑aware behavior modifiers  

#### Role
Shapes the political landscape of the world.

---

### 3.3 core_quests — The Intent Layer

Translates world‑state changes into objectives.

#### Quest Nodes
Invisible logic units that:
- Register with core_simulation  
- Listen to simulation events  
- Update on ticks  
- Generate objectives  
- Broadcast objectives to actors in the region  
- Filter by faction tags  

#### Objective Format
Declarative, not procedural:
- GoTo  
- Investigate  
- Patrol  
- Flee  
- Interact  

#### Role
Tells actors what is happening and what might matter.

---

### 3.4 core_actors — The Autonomous Agents

Actors turn intent into action.

#### Actor Pipeline

##### Layer 1 — Intent → Goal
Actors convert objectives into internal goals:
- GoTo  
- Investigate  
- Interact  
- Patrol  
- Flee  

Goal evaluation considers:
- Faction  
- Risk tolerance  
- Priority  

##### Layer 2 — Goal → Path
Actors request paths and integrate with core_simulation:
- Register position  
- Update region membership  
- Join/leave squads  
- React to territory boundaries  

##### Layer 3 — Path → Steering
Actors move using:
- Local avoidance  
- Behavior blending  
- Formation movement  
- Territory‑aware aggression/caution  

#### Actor State Machine
States include:
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

---

## 4. The ALife Feedback Loop

The ALife system is a continuous cycle:

---

### Step 1 — Simulation Tick
core_simulation updates:
- Squads  
- Regions  
- POIs  
- Conflicts  

Events are emitted.

---

### Step 2 — Factions React
core_factions:
- Adjusts influence  
- Creates squads  
- Redirects squads  
- Changes aggression  

---

### Step 3 — Quests React
core_quests:
- Generates objectives  
- Updates quest nodes  
- Broadcasts intent  

---

### Step 4 — Actors React
core_actors:
- Convert objectives to goals  
- Request paths  
- Move  
- Fight  
- Flee  
- Investigate  

Actors update region membership in core_simulation.

---

### Step 5 — Simulation Updates Again
core_simulation sees:
- New squad positions  
- New conflicts  
- New POI states  
- New influence values  

The loop continues.

---

## 5. Why the System Works

Each module has a single responsibility:

- core_simulation = world‑state  
- core_factions = strategy  
- core_quests = intent  
- core_actors = action  

This produces:
- Emergent behavior  
- Dynamic faction wars  
- Shifting POI control  
- Actor migrations  
- Player‑driven and world‑driven quests  
- A world that evolves without players  

---

## 6. Key Insight

The ALife system is **region‑driven**, not actor‑driven.

Actors are the visible surface of a much larger simulation:

- Region influence  
- Territory control  
- Squad movement  
- POI strategic state  
- Simulation ticks  

Actors are the manifestation of the simulation.

---

## 7. Completion Criteria

The ALife system is functioning when:

1. Regions change hands dynamically  
2. Squads move and clash without player presence  
3. POIs shift alert levels and ownership  
4. Factions react strategically  
5. Quest nodes generate objectives from world events  
6. Actors respond autonomously  
7. The loop runs continuously and consistently  

---
```