### core_foundation / DESIGN.md

---

## 1. Purpose

**core_foundation** provides the shared infrastructure and utilities that every other GURPScraft module relies on.  
It does **not** contain any game logic. It focuses on:

- Consistent logging  
- Configuration loading and access  
- Shared constants  
- Common utility functions  
- Module initialization helpers  
- Lightweight validation utilities  

It must remain **small, stable, and dependency‑free** (no other core module may be required here).

---

## 2. Responsibilities

- **Logging:**
  - Provide a unified logging API wrapping `minetest.log`.
  - Support log levels: `trace`, `debug`, `info`, `warn`, `error`.
  - Optional module‑scoped prefixes.

- **Configuration:**
  - Load engine‑wide configuration from:
    - `minetest.settings` (minetest.conf / luanti.conf).
    - Optional per‑module config tables.
  - Provide read‑only accessors for other modules.
  - Support default values and type coercion (string → number/boolean).

- **Constants:**
  - Define shared constants used across modules (e.g., tick rates, default gravity multipliers, common strings).
  - Keep constants generic and engine‑level (no game‑specific values).

- **Utilities:**
  - Provide small, pure helper functions:
    - Table helpers (shallow/deep copy, merge, readonly wrappers).
    - Math helpers (clamp, lerp, rounding).
    - String helpers (split, trim, safe tostring).
    - ID helpers (safe ID normalization, namespacing).

- **Module Initialization:**
  - Provide a simple pattern for:
    - Registering a module’s API table.
    - Ensuring init order is deterministic.
    - Optional “post‑init” hooks for modules that need to run after all core modules are loaded.

- **Validation:**
  - Lightweight schema‑style checks for data tables (optional).
  - Non‑fatal warnings for malformed data (log, don’t crash).

---

## 3. Non‑Responsibilities

- No direct interaction with:
  - Worldgen
  - Actors
  - Combat
  - Items
  - UI
- No game‑specific constants or settings.
- No direct registration of nodes, items, entities, or ABMs.
- No dependency on other `core_*` modules.

---

## 4. Dependencies

- **External:**  
  - Luanti/Minetest Lua API:
    - `minetest.log`
    - `minetest.settings`
    - `minetest.get_modpath`
    - `minetest.get_worldpath` (for optional file‑based config if needed)

- **Internal:**  
  - None. `core_foundation` must be the first core module loaded.

---

## 5. Public API Surface (High‑Level)

All public functions are exposed via `core_foundation/api.lua` and returned from `init.lua` as a single table, e.g.:

```lua
foundation = {
  log = { ... },
  config = { ... },
  const = { ... },
  util = { ... },
  init = { ... },
  validate = { ... },
}
```

### 5.1 Logging API

- `foundation.log.trace(msg, module_id)`
- `foundation.log.debug(msg, module_id)`
- `foundation.log.info(msg, module_id)`
- `foundation.log.warn(msg, module_id)`
- `foundation.log.error(msg, module_id)`

Behavior:
- Wraps `minetest.log`.
- `module_id` is optional; if provided, prefixes messages like `[core_combat] ...`.

### 5.2 Config API

- `foundation.config.get_string(key, default)`
- `foundation.config.get_number(key, default)`
- `foundation.config.get_bool(key, default)`
- `foundation.config.get_table(key, default)` (optional, for JSON‑like strings if used)

Sources:
- Primarily `minetest.settings`.
- May later support engine‑local config files, but that’s optional and must remain backward‑compatible.

### 5.3 Constants API

- `foundation.const.TICK_RATE`
- `foundation.const.DEFAULT_GRAVITY_MULT`
- `foundation.const.MODULE_PREFIX`  
  (Only truly engine‑wide constants; avoid bloat.)

### 5.4 Utility API

- `foundation.util.clamp(x, min, max)`
- `foundation.util.lerp(a, b, t)`
- `foundation.util.round(x, decimals)`
- `foundation.util.deepcopy(tbl)`
- `foundation.util.merge(dst, src, overwrite)`
- `foundation.util.readonly(tbl)` (metatable‑based)
- `foundation.util.split(str, sep)`
- `foundation.util.trim(str)`
- `foundation.util.safe_tostring(value)`

### 5.5 Init / Module Registration API

- `foundation.init.register_module(id, api_table)`
  - Registers a module’s public API under a known ID.
- `foundation.init.get_module(id)`
  - Returns a previously registered module API.
- `foundation.init.register_post_init(fn)`
  - Registers a callback to be run after all core modules have initialized.
- `foundation.init.run_post_init()`
  - Called once from a central place (e.g., game or engine bootstrap mod).

### 5.6 Validation API (Lightweight)

- `foundation.validate.table(name, tbl, schema)`
  - Logs warnings if required keys are missing or types mismatch.
  - Never throws hard errors in production; this is a dev aid.

---

## 6. Internal Structure

`core_foundation/internal/` contains implementation details not to be used directly by other modules.

- `loader.lua`
  - Implements `register_module`, `get_module`, `register_post_init`, `run_post_init`.
- `validation.lua`
  - Implements simple schema checks for data tables.

These files are required by `api.lua` and not exposed directly.

---

## 7. Data

`core_foundation` should have **minimal or no data files**.  
If present, they should be:

- `data/defaults.lua` — default engine‑level constants and config keys.

No game content, no item definitions, no worldgen data.

---

## 8. Debug Tools

`core_foundation/debug/` may include:

- `commands.lua`
  - Optional chat commands for:
    - Printing loaded modules.
    - Dumping config values.
    - Testing logging levels.

These must be clearly marked as debug‑only and safe to disable.

---

## 9. Integration Notes (Luanti Compatibility)

- All logging uses `minetest.log` with valid log levels (`"action"`, `"info"`, `"warning"`, `"error"`, etc.).  
  Mapping from internal levels (trace/debug/info/warn/error) to Luanti levels must be explicit.

- Config access uses `minetest.settings:get_*` functions:
  - `get`, `get_bool`, `get_number` where appropriate.

- No assumptions about game name or world path beyond what Luanti exposes.

- `core_foundation` must not register nodes, items, entities, or ABMs; it is purely infrastructural.

---

## 10. Success Criteria

`core_foundation` is considered correct and stable when:

- Other core modules can:
  - Log consistently.
  - Read config safely.
  - Share constants without duplication.
  - Use utilities without re‑implementing helpers.
- No other module needs to know about `minetest.log` or `minetest.settings` directly (they can, but don’t have to).
- The module can remain largely unchanged even as higher‑level systems evolve.