### core_stats / DESIGN.md

---

## **1. Purpose**

`core_stats` is the **character attribute, skill, trait, and progression system** for the entire GURPScraft engine.  
It provides a **GURPS‑style simulation backbone** that all actors (players, NPCs, monsters, robots, etc.) use.

This module defines:

- Primary attributes  
- Derived statistics  
- Skills  
- Traits / advantages / disadvantages  
- Stat checks (3d6 roll‑under)  
- Opposed rolls & contests  
- Progression (optional)  
- Serialization of actor stat sheets  

It contains **no combat logic**, **no AI logic**, and **no game‑specific values**.

---

## **2. Responsibilities**

### **2.1 Attribute System**
Defines and manages primary attributes such as:
- Strength (ST)
- Dexterity (DX)
- Intelligence (IQ)
- Health (HT)

Attributes are:
- Defined in `data/attributes.lua`
- Numeric
- Modifiable by traits, equipment, effects

### **2.2 Derived Statistics**
Automatically computed from attributes:
- HP  
- Will  
- Perception  
- Fatigue  
- Basic Speed  
- Basic Move  
- Carry Weight  
- Encumbrance thresholds (in cooperation with `core_inventory`)

Derived stats are recalculated whenever:
- Attributes change  
- Traits change  
- Equipment changes  

### **2.3 Skills**
Defines:
- Skill list  
- Attribute associations  
- Difficulty levels  
- Skill modifiers  
- Defaults (optional)

Skills are stored in:
```
data/skills.lua
```

### **2.4 Traits / Advantages / Disadvantages**
Defines:
- Passive modifiers  
- Conditional modifiers  
- Flags (e.g., Darkvision, Fire Immunity)  
- Social traits (e.g., Reputation, Status)  
- Perks and quirks  

Traits are stored in:
```
data/traits.lua
```

### **2.5 Stat Checks (3d6 Roll‑Under)**
Implements GURPS‑style checks:
- `check_attribute(actor, attr_id, modifier)`
- `check_skill(actor, skill_id, modifier)`
- `check_trait(actor, trait_id, modifier)` (optional)
- `check_raw(value)` (roll under a number)

### **2.6 Opposed Rolls & Contests**
Implements:
- Standard contests  
- Quick contests  
- Opposed skill checks  

### **2.7 Progression (Optional)**
Supports:
- Awarding points  
- Spending points  
- Increasing skills  
- Increasing attributes  
- Unlocking traits  

Progression rules are **data‑driven** and optional.

### **2.8 Serialization**
Provides:
- Save/load of actor stat sheets  
- Export to Lua tables  
- Import from saved tables  
- Safe defaults for missing fields  

### **2.9 Actor Integration**
`core_stats` does **not** manage actors directly.  
Instead, it provides functions that `core_actor` calls to:

- Initialize stats  
- Modify stats  
- Query stats  
- Perform checks  

---

## **3. Non‑Responsibilities**

- No combat logic (damage, hit zones, recoil, etc.)
- No AI logic
- No inventory or equipment logic
- No worldgen or survival logic
- No UI rendering
- No faction or social logic beyond trait modifiers

---

## **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.log` (via core_foundation)
  - `minetest.serialize` / `minetest.deserialize` (optional)

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (data loading, schema validation)

---

## **5. Public API Surface**

All public functions are exposed via `core_stats/api.lua`.

### **5.1 Actor Stat Sheet Management**
- `stats.init_actor(actor)`
- `stats.get(actor, key)`
- `stats.set(actor, key, value)`
- `stats.modify(actor, key, delta)`
- `stats.recalculate(actor)`

### **5.2 Attribute Access**
- `stats.get_attribute(actor, attr_id)`
- `stats.set_attribute(actor, attr_id, value)`
- `stats.modify_attribute(actor, attr_id, delta)`

### **5.3 Derived Stats**
- `stats.get_derived(actor, id)`
- `stats.recalculate_derived(actor)`

### **5.4 Skills**
- `stats.get_skill(actor, skill_id)`
- `stats.set_skill(actor, skill_id, level)`
- `stats.modify_skill(actor, skill_id, delta)`

### **5.5 Traits**
- `stats.has_trait(actor, trait_id)`
- `stats.add_trait(actor, trait_id)`
- `stats.remove_trait(actor, trait_id)`

### **5.6 Checks**
- `stats.check_attribute(actor, attr_id, modifier)`
- `stats.check_skill(actor, skill_id, modifier)`
- `stats.check_value(value, modifier)`
- `stats.contest(actorA, actorB, skill_id)`
- `stats.quick_contest(actorA, actorB, skill_id)`

### **5.7 Serialization**
- `stats.serialize(actor)`
- `stats.deserialize(actor, data_table)`

---

## **6. Internal Structure**

`core_stats/internal/` contains implementation details:

- `calc_attributes.lua`
  - Attribute modifiers
  - Trait modifiers
  - Equipment modifiers

- `calc_skills.lua`
  - Skill defaults
  - Difficulty scaling
  - Attribute linkage

- `derived.lua`
  - HP, Will, Perception, Move, Speed, Fatigue

- `checks.lua`
  - 3d6 roll‑under
  - Opposed rolls
  - Quick contests

- `progression.lua`
  - Point spending
  - Leveling rules (optional)

- `serialization.lua`
  - Save/load logic

These files are not exposed directly.

---

## **7. Data Structure**

`core_stats/data/` contains:

### **attributes.lua**
Example:
```lua
return {
  ST = { default = 10, min = 1, max = 20 },
  DX = { default = 10 },
  IQ = { default = 10 },
  HT = { default = 10 },
}
```

### **skills.lua**
Example:
```lua
return {
  sword = { attribute = "DX", difficulty = "average" },
  fire_magic = { attribute = "IQ", difficulty = "hard" },
}
```

### **traits.lua**
Example:
```lua
return {
  darkvision = { type = "advantage", effect = { vision_bonus = 2 } },
  clumsy = { type = "disadvantage", effect = { DX = -1 } },
}
```

### **derived.lua**
Defines formulas for derived stats.

---

## **8. Debug Tools**

`core_stats/debug/` may include:

- `stat_inspector.lua`
  - Chat command to print actor stats
  - Validate stat sheets
  - Test skill checks

Debug tools must be safe to disable.

---

## **9. Integration Notes (Luanti Compatibility)**

- Actor stat sheets are stored in Lua tables attached to the entity or player object.
- Serialization uses:
  - `minetest.serialize`
  - `minetest.deserialize`
- No global state is stored outside actor tables.
- All random rolls use `math.random`.

---

## **10. Success Criteria**

`core_stats` is correct when:

- Actors can be initialized with a complete stat sheet.
- Attributes, skills, and traits interact predictably.
- Derived stats update automatically.
- Checks and contests behave like GURPS.
- Serialization is stable and safe.
- No game‑specific values appear in this module.

---
