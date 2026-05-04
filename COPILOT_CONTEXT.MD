# **COPILOT_CONTEXT.md**

## **Purpose**

This file defines the **global rules, architecture, and constraints** that GitHub Copilot must follow when generating code for the GURPScraft engine.  
Copilot must treat this file as authoritative and must not deviate from it.

The goal is to ensure:

- Consistent architecture  
- No hallucinated APIs  
- Strict module boundaries  
- Data‑driven design  
- Maintainable, predictable code  
- Zero game‑specific content in core modules  

---

# **1. Project Overview**

GURPScraft is a **modular, data‑driven engine** built on top of the **Luanti** (Minetest) API.  
The engine is composed of multiple core modules, each with a **DESIGN.md** describing its responsibilities, API surface, and internal structure.

Copilot must:

- Follow each module’s DESIGN.md exactly  
- Never invent features not described in DESIGN.md  
- Never reference undocumented Luanti APIs  
- Never mix responsibilities between modules  

---

# **2. Module List (Authoritative)**

Copilot must recognize the following modules as the complete set of core modules:

### **Core Engine Layer**
- core_foundation  
- core_data  

### **Core Simulation Layer**
- core_stats  
- core_items  
- core_inventory  
- core_combat  
- core_physics  
- core_effects  
- core_ui  

### **Social & Actor Layer**
- core_factions  
- core_actor  

### **World & Environment Layer**
- core_worldgen  
- core_anomalies  
- core_dimension  
- core_survival  

### **Systems & Crafting Layer**
- core_machines  
- core_magic  
- core_crafting  

### **Destruction & Vehicles Layer**
- core_vehicles  
- core_destruction  

### **Game Module**
- game_wasteland  

Copilot must not create new modules unless explicitly instructed.

---

# **3. Module Boundaries (Critical)**

Copilot must enforce strict separation:

### **Allowed**
- Calling another module’s **public API**  
- Reading data from another module’s `/data/` folder  
- Using utilities from `core_foundation`  

### **Forbidden**
- Accessing another module’s `internal/` folder  
- Modifying another module’s state directly  
- Creating circular dependencies  
- Hardcoding game content in core modules  
- Inventing new APIs or behaviors  

---

# **4. File Structure Rules**

Every module must follow this structure:

```
module_name/
    init.lua
    api.lua
    DESIGN.md
    internal/
    data/
    debug/
```

### **init.lua**
- Loads data  
- Loads internal modules  
- Exposes the public API  
- No logic beyond initialization  

### **api.lua**
- Only public functions  
- No internal helpers  
- No side effects  

### **internal/**
- Implementation details  
- Private logic  
- State machines  

### **data/**
- Pure Lua tables  
- No logic  
- No cross‑module references  

### **debug/**
- Developer tools  
- Must not affect gameplay  

---

# **5. Coding Standards (Summary)**

Copilot must follow the rules in `CODING_STANDARDS.md`.  
Key points:

- snake_case for variables and functions  
- No camelCase  
- No clever hacks  
- No hidden state  
- No global variables  
- No side effects during load  
- All gameplay content must be data‑driven  
- All public functions must have docstrings  
- Prefer clarity over cleverness  

---

# **6. Luanti API Rules**

Copilot must:

- Use only documented Luanti APIs  
- Check the Luanti source or docs if unsure  
- Never invent new engine functions  
- Never assume Minecraft‑style APIs  

If an API is not documented, it does not exist.

---

# **7. Data‑Driven Rules**

Copilot must:

- Put all gameplay content in `/data/`  
- Keep data files pure (no logic)  
- Avoid cross‑module references in data  
- Use data tables to drive behavior  

Core modules must never contain game content.

---

# **8. How Copilot Should Interpret DESIGN.md**

For every module:

- DESIGN.md is the **source of truth**  
- Public API must match DESIGN.md exactly  
- Internal structure must match DESIGN.md  
- No additional features may be added  
- No responsibilities may be moved between modules  

If DESIGN.md contradicts anything else, DESIGN.md wins.

---

# **9. How Copilot Should Generate Code**

Copilot must:

- Generate code **one file at a time**  
- Follow the module’s DESIGN.md  
- Follow CODING_STANDARDS.md  
- Use only documented Luanti APIs  
- Keep modules isolated  
- Keep code deterministic and maintainable  
- Prefer small, composable functions  
- Avoid unnecessary abstraction  

---

# **10. What Copilot Must Never Do**

Copilot must never:

- Invent APIs  
- Invent modules  
- Invent gameplay content  
- Use Minecraft APIs  
- Use undocumented Luanti functions  
- Add magic numbers  
- Add hidden state  
- Add global variables  
- Add cross‑module internal references  
- Add side effects during load  

---

# **11. Example Copilot Prompts (Internal Use)**

These are examples of how Copilot will be prompted:

### **API file**
> Implement the public API for this module exactly as defined in DESIGN.md.  
> No internal helpers.  
> No side effects.  
> Follow CODING_STANDARDS.md.

### **Internal logic file**
> Implement the internal logic described in DESIGN.md.  
> Use only documented Luanti APIs.  
> Keep functions small and composable.

### **Data file**
> Generate the data table described in DESIGN.md.  
> No logic.  
> No cross‑module references.

### **init.lua**
> Wire up this module according to DESIGN.md.  
> Load data, internal modules, and expose the API.

---

# **12. Final Rule**

**If Copilot is unsure, it must default to:**

- The DESIGN.md  
- The ARCHITECTURE.md  
- The CODING_STANDARDS.md  
- The Luanti documentation  

Copilot must never guess.

---

# **End of COPILOT_CONTEXT.md**

---
