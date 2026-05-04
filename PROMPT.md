### *Master Instruction File for GitHub Copilot*  
### *GURPScraft Engine Code Generation Pipeline*

---

## **0. Global Rules (Copilot MUST follow these)**

1. Follow **COPILOT_CONTEXT.md**, **CODING_STANDARDS.md**, and each module’s **DESIGN.md** exactly.  
2. Never invent APIs, modules, or features not described in DESIGN.md.  
3. Use only documented Luanti APIs.  
4. Keep modules isolated; only use public APIs.  
5. Generate code **one file at a time**.  
6. Keep functions small, composable, and deterministic.  
7. All gameplay content belongs in `game_wasteland`, not core modules.  
8. All core modules must be **data‑driven**.  
9. No side effects during load.  
10. If unsure, default to DESIGN.md → ARCHITECTURE.md → CODING_STANDARDS.md → Luanti docs.

---

## **1. Build Order (Copilot MUST follow this sequence)**

Copilot must generate modules in this exact order:

1. core_foundation  
2. core_data  
3. core_stats  
4. core_items  
5. core_inventory  
6. core_combat  
7. core_physics  
8. core_effects  
9. core_ui  
10. core_factions  
11. core_actor  
12. core_worldgen  
13. core_anomalies  
14. core_dimension  
15. core_survival  
16. core_machines  
17. core_magic  
18. core_crafting  
19. core_vehicles  
20. core_destruction  
21. game_wasteland  
22. Final integration  
23. Test suite  
24. Code audit  

Copilot must not skip or reorder modules.

---

## **2. File Generation Pattern (Copilot MUST follow this for every module)**

For each module, Copilot must generate files in this order:

1. `init.lua`  
2. `api.lua`  
3. All internal files (as listed in DESIGN.md)  
4. All data files  
5. All debug tools  

Copilot must not generate files not listed in DESIGN.md.

---

## **3. Prompts Copilot Must Execute for Each File**

For each file, Copilot must internally apply the following instruction:

### **A. init.lua**
> Implement init.lua for this module according to DESIGN.md.  
> Load data, load internal modules, and expose the public API.  
> No logic beyond initialization.

### **B. api.lua**
> Implement the public API exactly as defined in DESIGN.md.  
> No internal helpers.  
> No side effects.  
> Follow CODING_STANDARDS.md.

### **C. internal files**
> Implement this internal module exactly as described in DESIGN.md.  
> Use only documented Luanti APIs.  
> Keep functions small and composable.  
> No cross‑module internal access.

### **D. data files**
> Generate the data table described in DESIGN.md.  
> No logic.  
> No cross‑module references.  
> No game content.

### **E. debug tools**
> Implement the debug tool described in DESIGN.md.  
> Must not affect gameplay unless explicitly invoked.

---

## **4. Module‑Specific Execution Instructions**

Copilot must follow these instructions for each module:

### **core_foundation**
> Begin by generating core_foundation.  
> Implement utilities, logging, and error helpers.

### **core_data**
> Implement registries and constants.

### **core_stats**
> Implement stat storage, modifiers, and traits.

### **core_items**
> Implement item metadata and tags.

### **core_inventory**
> Implement inventory logic and equipment rules.

### **core_combat**
> Implement damage resolution and hit logic.

### **core_physics**
> Implement movement, stamina, and fall damage.

### **core_effects**
> Implement particles, sounds, and screen effects.

### **core_ui**
> Implement HUD and overlays.

### **core_factions**
> Implement faction registry and reputation.

### **core_actor**
> Implement actor state machine and behavior trees.

### **core_worldgen**
> Implement biome lookup and noise layers.

### **core_anomalies**
> Implement anomaly fields and effects.

### **core_dimension**
> Implement dimension rules and transitions.

### **core_survival**
> Implement hunger, thirst, temperature, radiation.

### **core_machines**
> Implement machine processing and power networks.

### **core_magic**
> Implement spells, mana, rituals, enchantments.

### **core_crafting**
> Implement recipes, matching, and crafting execution.

### **core_vehicles**
> Implement vehicle physics, seats, cargo, AI.

### **core_destruction**
> Implement block damage, collapse, fire, penetration, siege, kaiju.

### **game_wasteland**
> Implement all game‑specific content using core APIs.

---

## **5. Final Integration**

After all modules are generated:

### **Integration**
> Wire all modules together according to ARCHITECTURE.md.  
> Ensure correct load order and no circular dependencies.

### **Test Suite**
> Generate a minimal test suite for each module’s public API.

### **Audit**
> Audit the entire codebase for consistency with CODING_STANDARDS.md and COPILOT_CONTEXT.md.

---

## **6. Execution Command**

When I say:

> **“Copilot, begin engine generation using PROMPT.md.”**

Copilot must:

1. Start at **core_foundation**  
2. Open each file in order  
3. Apply the correct prompt for that file  
4. Continue until the entire engine is generated  
5. Perform integration, testing, and audit steps  

Copilot must not skip steps or reorder tasks.

---

# **End of PROMPT.md**

---
