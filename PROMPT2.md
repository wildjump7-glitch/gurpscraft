# PROMPT2.md — Second‑Pass Implementation of GURPScraft Engine Modules

You are Copilot operating **inside the `gurpscraft` repository** after `PROMPT.md` has already been executed.

- The **scaffolding exists**: all modules, `init.lua`, `api.lua`, `internal/`, `data/`, `debug/`, and top‑level engine files are present.
- Your job in this second pass is to **turn scaffolding into working systems**, module by module, in a **logical dependency order**, while preserving architecture and coding standards.

Read and obey:

- `COPILOT_CONTEXT.md`
- `CODING_STANDARDS.md`
- `ENGINE_DOCUMENTATION.md`
- `PROJECT_COMPLETION.md`

These files define **global rules**. If anything in this file appears to conflict with them, **their rules win**.

---

## 1. Overall mission of PROMPT2

Your mission in this second pass:

1. **Implement real functionality** inside each module in a dependency‑aware order.
2. **Replace placeholders and stubs** with working, testable logic.
3. **Preserve module boundaries** and the public API contracts.
4. **Keep the engine data‑driven** wherever possible.
5. **Continuously tighten quality** using tests and audits.

You are not allowed to:

- Introduce new global variables outside the approved namespaces.
- Bypass a module’s `api.lua` to reach into its `internal/` code from other modules.
- Change public API signatures without clear, local documentation and minimal impact.

---

## 2. Module implementation order

Implement modules in this **strict order**, completing each one before moving on:

1. `core_foundation`
2. `core_data`
3. `core_stats`
4. `core_actor`
5. `core_items`
6. `core_inventory`
7. `core_combat`
8. `core_effects`
9. `core_survival`
10. `core_factions`
11. `core_dimension`
12. `core_worldgen`
13. `core_magic`
14. `core_machines`
15. `core_vehicles`
16. `core_ui`
17. `core_anomalies`
18. `core_destruction`
19. Any remaining core modules
20. Integrate with `game_wasteland`

Do **not** skip ahead. Each module may depend on the previous ones.

---

## 3. Per‑module workflow

For **each module**, follow this exact workflow:

### 3.1. Read the design and context

1. Open the module’s `DESIGN.md` (if missing or thin, improve it first).
2. Identify:
   - **What this module owns**
   - **What it does not own**
   - **Its public API surface**
   - **Its dependencies on other modules**

If the design is vague, refine `DESIGN.md` before writing code.

### 3.2. Stabilize and finalize `api.lua`

1. Open `api.lua` for the module.
2. Ensure:
   - All public functions are clearly named and documented.
   - Each function delegates to `internal/` logic instead of implementing everything inline.
   - No cross‑module calls bypass other modules’ APIs.
3. If necessary, add or adjust functions to match the responsibilities described in `DESIGN.md`.

**Rule:** `api.lua` is the **only public surface** of the module.

### 3.3. Implement `internal/` logic

1. Open all files in `internal/` for the module:
   - `compute.lua`
   - `util.lua`
   - `registry.lua`
   - `handlers.lua`
   - `logic.lua`
   - Any others present
2. Replace placeholders and TODOs with real logic that:
   - Uses **data from `data/`** where appropriate.
   - Respects invariants and constraints from `DESIGN.md`.
   - Avoids side effects unless explicitly required.
3. Keep functions **small, composable, and testable**.

If you need new internal files, you may create them, but keep names **clear and responsibility‑driven**.

### 3.4. Flesh out `data/` tables

1. Open all files in `data/` for the module.
2. Replace placeholder tables with:
   - Realistic, minimal but meaningful data.
   - Structures that match how `internal/` logic expects to consume them.
3. Keep data **declarative**:
   - No heavy logic in `data/` files.
   - Only constants, configuration, and registries.

### 3.5. Wire everything in `init.lua`

1. Ensure `init.lua`:
   - Loads all required `internal/` files.
   - Loads `api.lua`.
   - Injects internal references into the API (e.g. `api._internal = { ... }`) if the pattern is used.
   - Registers the module’s API into the global engine namespace (e.g. `gurpscraft.core.stats = api`).
2. Confirm that:
   - No circular requires are introduced.
   - Dependencies on other modules use their **APIs**, not internals.

### 3.6. Add or refine debug and tests

1. Open `debug/` for the module.
2. Implement:
   - Simple test helpers.
   - Debug commands or functions that exercise the module’s core behavior.
3. Integrate with:
   - `test_suite.lua` at the root where appropriate.
   - `code_audit.lua` if the module has structural rules worth checking.

Tests do not need to be exhaustive but must **cover the core behavior** and catch obvious regressions.

---

## 4. Engine‑level integration and tightening

After each module is implemented:

1. **Run through engine‑level files** and update where needed:
   - `init_engine.lua`:
     - Ensure the module is loaded and registered.
     - Add any necessary initialization calls.
   - `ENGINE_DOCUMENTATION.md`:
     - Update the module’s status and description.
   - `PROJECT_COMPLETION.md`:
     - Mark progress and note any remaining TODOs for that module.

2. **Avoid breaking existing modules**:
   - If you must change a public API, update:
     - The module’s `DESIGN.md`
     - Any callers in other modules
     - Relevant documentation

---

## 5. Quality rules for this second pass

When implementing or modifying code, always:

- **Follow `CODING_STANDARDS.md`** for style, naming, and patterns.
- Prefer **pure functions** and **data‑driven design**.
- Keep **side effects localized** (e.g. registration, logging, Minetest callbacks).
- Avoid:
  - Hidden globals
  - Deeply nested logic
  - Copy‑pasted patterns that should be utilities

If you see obvious improvements to scaffolding created in the first pass, you may refactor, but:

- Do not destroy the overall architecture.
- Do not remove important comments or design intent.

---

## 6. How to respond to user prompts in this phase

When the user asks you to work on a specific module:

1. Confirm the module’s position in the **implementation order**.
2. If earlier modules are incomplete, suggest finishing them first.
3. If the module is next in line:
   - Follow the **per‑module workflow** in section 3.
   - Show concise, well‑structured diffs or file contents.
   - Keep changes **coherent and self‑contained**.

When in doubt, **prioritize clarity, modularity, and testability** over cleverness.

---

## 7. Completion criteria for this second pass

The second pass is considered **complete** when:

- All core modules listed in section 2:
  - Have non‑placeholder logic in `internal/`.
  - Have stable, documented `api.lua` surfaces.
  - Are wired correctly in `init.lua`.
  - Use `data/` for configuration and registries.
  - Have at least basic tests or debug helpers.
- `init_engine.lua` can:
  - Load all modules without error.
  - Expose a coherent `gurpscraft` namespace.
- `game_wasteland` can:
  - Call into engine APIs without relying on internals.
  - Demonstrate at least minimal, working gameplay loops.

At that point, a **third pass** can focus on:

- Balancing
- Performance
- Content expansion
- Advanced systems

Until then, your job in PROMPT2 is to **turn the skeleton into a functioning engine, one module at a time, without breaking the architecture**.
