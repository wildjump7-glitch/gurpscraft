# game_wasteland — DESIGN

## 1. Purpose

`game_wasteland` is the **actual game built on top of the meta‑engine**.

It defines:

- World setting and lore  
- Biomes and worldgen content  
- Structures and POIs  
- Factions and relationships  
- NPC types and behaviors  
- Weapons, ammo, armor, items  
- Anomalies and artifacts  
- Backrooms levels  
- Survival tuning  
- Loot tables  
- Spawn tables  
- Progression and economy  
- Audio/visual identity  
- UI layout and styling  

It contains **all game‑specific content** and **no reusable engine logic**.

All systems implemented in `core_*` modules are instantiated, configured, and populated here.

---

# 2. Responsibilities

## 2.1 World & Biomes

Define the Wasteland world:

- Overworld biome set:
  - Dead forest  
  - Toxic swamp  
  - Industrial ruins  
  - Abandoned suburbs  
  - Wasteland plains  
  - Military exclusion zones  
  - Forest pockets  
  - Anomaly fields  

Responsibilities:

- Register biomes via `core_worldgen`  
- Define biome noise parameters  
- Define biome tags  
- Define biome‑specific hazards  
- Define biome‑specific spawns  

---

## 2.2 Structures & POIs

Define all world structures:

- Ruined houses  
- Factories  
- Warehouses  
- Military checkpoints  
- Research labs  
- Abandoned vehicles  
- Underground bunkers  
- Anomaly research stations  
- Backrooms entrances  

Responsibilities:

- Register structures via `core_worldgen`  
- Provide placement rules  
- Provide loot tables  
- Provide NPC spawn rules  
- Provide anomaly hooks  

---

## 2.3 Factions

Define all factions:

- Stalkers  
- Scavengers  
- Military  
- Cultists  
- Scientists  
- Mutants (non‑human faction)  
- Backrooms entities (optional)  

Responsibilities:

- Register factions via `core_factions`  
- Define default relationships  
- Define reputation thresholds  
- Define faction territories  
- Define faction‑specific NPC types  

---

## 2.4 NPC Types

Define all NPC archetypes:

- Stalker rookies  
- Stalker veterans  
- Scav raiders  
- Scav snipers  
- Military patrols  
- Military heavies  
- Cultist zealots  
- Mutant dogs  
- Mutant humanoids  
- Backrooms entities (optional)  

Responsibilities:

- Register NPC types via `core_npc`  
- Provide behavior trees  
- Provide loadouts  
- Provide stats  
- Provide models/animations  
- Provide faction alignment  

---

## 2.5 Weapons, Ammo, Armor, Items

Define all game items:

### Weapons
- Pistols  
- SMGs  
- Rifles  
- Shotguns  
- DMRs  
- LMGs  
- Melee weapons  

### Ammo
- Calibers  
- Penetration values  
- Tracer/subsonic variants  

### Armor
- Light armor  
- Medium armor  
- Heavy armor  
- Helmets  
- Masks  

### Consumables
- Food  
- Water  
- Medkits  
- Bandages  
- Anti‑radiation drugs  
- Stamina boosters  

### Artifacts
- Thermal artifacts  
- Electrical artifacts  
- Gravitational artifacts  
- Spatial artifacts  

Responsibilities:

- Register items via `core_items`  
- Define crafting recipes  
- Define loot tables  
- Define rarity tiers  

---

## 2.6 Anomalies & Artifact Fields

Define all anomaly types:

- Burner  
- Electra  
- Vortex  
- Gravity well  
- Spatial tear  
- Toxic bloom  

Define artifact types:

- Fire‑based  
- Electric  
- Gravitational  
- Spatial  
- Hybrid/rare  

Responsibilities:

- Register anomalies via `core_anomalies`  
- Register artifacts via `core_anomalies`  
- Define anomaly visuals  
- Define anomaly hazards  
- Define artifact drop tables  
- Define anomaly field placement rules  

---

## 2.7 Backrooms Levels

Define Backrooms content:

- Level 0 (Liminal Offices)  
- Level 1 (Storage Maze)  
- Level 2 (Industrial Hell)  
- Level 3 (Machine Rooms)  
- Sub‑levels (optional)  

Responsibilities:

- Register levels via `core_backrooms`  
- Define room templates  
- Define lighting/ambience  
- Define entity spawns  
- Define anomaly spawns  
- Define instability profile  
- Define transitions  

---

## 2.8 Survival Tuning

Define survival parameters:

- Hunger decay rate  
- Thirst decay rate  
- Stamina drain/regeneration  
- Radiation accumulation  
- Temperature zones  
- Status effect severity  

Responsibilities:

- Configure survival stats via `core_survival`  
- Define consumable effects  
- Define environmental hazard zones  

---

## 2.9 Loot Tables & Economy

Define:

- Loot rarity tiers  
- Container loot tables  
- NPC loot tables  
- Anomaly artifact tables  
- Backrooms loot tables  
- Vendor inventories (optional)  
- Currency or barter system  

Responsibilities:

- Register loot tables  
- Integrate with NPCs, POIs, anomalies  

---

## 2.10 Spawn Tables

Define:

- NPC spawn tables  
- Animal/mutant spawn tables  
- Anomaly spawn tables  
- Artifact spawn tables  
- Backrooms entity spawn tables  

Responsibilities:

- Register spawn rules via `core_worldgen` and `core_npc`  

---

## 2.11 UI Layout & Styling

Define:

- HUD layout  
- Crosshair style  
- Inventory UI (if implemented)  
- Crafting UI (if implemented)  
- Backrooms distortion overlays  
- Anomaly detection UI  

Responsibilities:

- Use `core_ui` to register UI elements  
- Provide textures, icons, and styling  

---

## 2.12 Audio & Visual Identity

Define:

- Sound effects  
- Ambient loops  
- Music (if used)  
- Anomaly audio  
- Backrooms ambience  
- Footstep sounds  
- Weapon sounds  
- UI sounds  

Responsibilities:

- Register sounds via Luanti  
- Provide audio hooks for anomalies, NPCs, and worldgen  

---

# 3. Non‑Responsibilities

`game_wasteland` must **not**:

- Implement engine logic  
- Modify core module behavior  
- Provide reusable systems  
- Implement generic APIs  
- Provide meta‑engine utilities  

All reusable logic belongs in `core_*` modules.

---

# 4. Inputs and Outputs

## Inputs

- All `core_*` module APIs  
- Luanti engine  
- Textures, models, sounds  
- Worldgen hooks  
- NPC behavior hooks  
- Survival hooks  
- Backrooms hooks  

## Outputs

- Fully defined game world  
- All content  
- All gameplay rules  
- All visuals and audio  
- All tuning parameters  

---

# 5. Internal File Structure

game_wasteland/
init.lua
api.lua (optional)
world/
biomes.lua
structures.lua
pois.lua
loot_tables.lua
spawn_tables.lua
factions/
factions.lua
territories.lua
items/
weapons.lua
ammo.lua
armor.lua
consumables.lua
artifacts.lua
recipes.lua
anomalies/
anomalies.lua
fields.lua
backrooms/
levels.lua
rooms.lua
transitions.lua
npc/
types.lua
behaviors.lua
loadouts.lua
survival/
tuning.lua
hazards.lua
ui/
hud.lua
crosshair.lua
effects.lua
audio/
sounds.lua
ambience.lua

---

# 6. Constraints

- Must depend on **all** core modules  
- Must not introduce new engine‑level systems  
- Must not break module boundaries  
- Must keep content modular and data‑driven  
- Must avoid heavy logic in global scope  
- Must load after all core modules  

---

# 7. Future Extensions (Not in v0.1)

- Quest/mission system  
- Dynamic faction wars  
- Player bases  
- Vehicles  
- Weather system  
- Multiplayer co‑op progression  
- Procedural story events  
