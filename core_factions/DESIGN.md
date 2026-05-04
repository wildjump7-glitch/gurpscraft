```markdown
# core_factions/DESIGN.md
Strategic & Social Layer for the ALife System

---

## 1. Purpose

`core_factions` provides the **strategic, social, and diplomatic layer** of the GURPScraft ALife system.  
It defines how groups, species, clans, guilds, corporations, nations, and supernatural entities relate to each other and how they influence world behavior.

This module handles:

- Faction definitions  
- Relationship matrices  
- Reputation systems  
- Hostility logic  
- Reaction rolls  
- Integration with ALife territory and influence  
- Strategic hooks for `core_simulation`, `core_quests`, and `core_actors`  

`core_factions` contains **no combat logic**, **no AI behavior**, and **no game‑specific content**.  
It defines *how factions behave*, not *which factions exist*.

---

## 2. Responsibilities

### 2.1 Faction Registry
Defines and manages all factions:
- Unique faction IDs  
- Names and descriptions  
- Tags (e.g., “bandit”, “military”, “undead”, “merchant”)  
- Default relationships  
- Default hostility rules  
- Optional icons (for UI)  

### 2.2 Relationship Matrix
Stores and manages:
- Faction‑to‑faction relationships  
- Player reputation  
- Dynamic changes over time  
- Event‑driven modifiers  

Relationship values:
- +100 → allied  
- 0 → neutral  
- -100 → hostile  

### 2.3 Reputation System
Tracks:
- Player reputation per faction  
- NPC reputation (optional)  
- Reputation decay  
- Reputation caps  
- Trait‑based modifiers (`core_stats`)  

### 2.4 Hostility Logic
Determines:
- Whether a faction is hostile to an actor  
- Conditional hostility (e.g., only if armed)  
- Inherited hostility (e.g., undead vs living)  
- Reputation‑based overrides  

### 2.5 Reaction Rolls
Implements GURPS‑style reaction mechanics:
- Friendly / Neutral / Unfriendly / Hostile  
- Modifiers from:
  - Traits  
  - Skills  
  - Reputation  
  - Faction relationships  
  - Context (combat, negotiation, intimidation)  

### 2.6 Territory & Influence (ALife Integration)
Integrates with `core_simulation` to support:
- Faction‑owned regions  
- Influence spread  
- Contested regions  
- Territory‑based hostility  
- Strategic expansion and retreat  
- Region‑aware faction behavior  

### 2.7 Strategic Hooks for ALife
`core_factions` provides strategic signals to:
- `core_simulation` (squad creation, influence adjustments)  
- `core_quests` (objective priority modifiers, faction tags)  
- `core_actors` (territory‑aware behavior, hostility rules)  

---

## 3. Non‑Responsibilities

`core_factions` does **not**:
- Implement AI behavior (`core_actors`)  
- Apply combat damage (`core_combat`)  
- Render UI (`core_ui`)  
- Generate terrain (`core_worldgen`)  
- Create quests (`core_quests`)  
- Define items (`core_items`)  

---

## 4. Dependencies

### External
- Luanti API:
  - `minetest.log`
  - `minetest.get_modpath`

### Internal
- `core_foundation` (logging, utilities)  
- `core_data` (faction definitions)  
- `core_stats` (trait modifiers)  
- `core_actors` (actor faction assignment)  
- `core_simulation` (territory, influence, squads)  

---

## 5. Public API Surface

All public functions are exposed via `core_factions/api.lua`.

### 5.1 Faction Registry
- `factions.register(id, def)`  
- `factions.get(id)`  
- `factions.all()`  
- `factions.exists(id)`  

### 5.2 Relationships
- `factions.get_relation(factionA, factionB)`  
- `factions.set_relation(factionA, factionB, value)`  
- `factions.modify_relation(factionA, factionB, delta)`  
- `factions.get_stance(factionA, factionB)`  
  Returns: `"ally"`, `"neutral"`, `"hostile"`  

### 5.3 Reputation
- `factions.get_reputation(actor, faction_id)`  
- `factions.set_reputation(actor, faction_id, value)`  
- `factions.modify_reputation(actor, faction_id, delta)`  
- `factions.get_reputation_stance(actor, faction_id)`  

### 5.4 Hostility
- `factions.is_hostile(actorA, actorB)`  
- `factions.is_faction_hostile(factionA, factionB)`  
- `factions.get_hostility_reason(actorA, actorB)`  

### 5.5 Reaction Rolls
- `factions.reaction_roll(actor, target, context)`  
- `factions.get_reaction_modifier(actor, target, context)`  

### 5.6 Territory & Influence (ALife)
- `factions.get_territory_owner(pos)`  
- `factions.set_territory_owner(pos, faction_id)`  
- `factions.get_territory_influence(pos, faction_id)`  
- `factions.adjust_influence(rx, rz, faction_id, delta)`  
- `factions.create_squad(def)`  
- `factions.redirect_squad(id, target_region)`  
- `factions.get_objective_priority_modifier(faction_id, objective)`  
- `factions.get_faction_tags(faction_id)`  
- `factions.get_territory_behavior_modifiers(actor, rx, rz)`  

---

## 6. Internal Structure

`core_factions/internal/` contains implementation details:

### reputation.lua
- Reputation storage  
- Decay rules  
- Trait modifiers  

### relations.lua
- Relationship matrix  
- Default stance logic  
- Dynamic updates  

### hostility.lua
- Hostility rules  
- Conditional hostility  
- Actor‑to‑actor hostility checks  

### territory.lua
- Region ownership  
- Influence spread  
- Contested region logic  
- Integration with `core_simulation`  

These files are not exposed directly.

---

## 7. Data Structure

`core_factions/data/` contains:

### factions.lua
Example:
```lua
return {
  survivors = {
    name = "Survivors",
    tags = { "human", "neutral" },
    default_relations = {
      raiders = -50,
      traders = +20,
    },
    icon = "faction_survivors.png",
  },

  raiders = {
    name = "Raiders",
    tags = { "bandit", "hostile" },
    default_relations = {
      survivors = -50,
      traders = -30,
    },
    icon = "faction_raiders.png",
  },
}
```

### relations.lua
Optional overrides.

### territory.lua
Optional region definitions.

---

## 8. Debug Tools

`core_factions/debug/` may include:

### faction_overlay.lua
- Shows faction territories  
- Shows actor faction IDs  
- Shows hostility lines  

### faction_inspector.lua
- Prints relationships  
- Prints reputation  
- Prints reaction roll breakdown  

---

## 9. ALife Integration Notes

### Region‑Aware Behavior
Factions must integrate with `core_simulation` to:
- Read region ownership  
- Read influence values  
- Detect contested regions  
- Adjust influence  
- Create or redirect squads  

### Objective Influence
Factions provide:
- Objective priority modifiers  
- Faction tags for filtering  
- Strategic signals to quest nodes  

### Actor Behavior Influence
Factions influence:
- Hostility rules  
- Territory‑aware aggression  
- Actor risk tolerance  
- Squad formation rules  

---

## 10. Success Criteria

`core_factions` is correct when:

1. Factions are fully data‑driven  
2. Relationships and reputation behave predictably  
3. Hostility logic integrates with `core_actors`  
4. Reaction rolls produce meaningful outcomes  
5. Territory and influence integrate with `core_simulation`  
6. Faction strategy influences `core_quests`  
7. No game‑specific content exists in this module  

---
```