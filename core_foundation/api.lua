-- core_foundation/api.lua
-- Public API for the core foundation module.
-- Provides logging, configuration, constants, utilities, and module initialization.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local log = dofile(modpath .. "/internal/logging.lua")
local config = dofile(modpath .. "/internal/config.lua")
local util = dofile(modpath .. "/internal/utils.lua")
local init = dofile(modpath .. "/internal/loader.lua")
local validate = dofile(modpath .. "/internal/validation.lua")

--[[
Public API table structure:

log:
  - trace(msg, module_id) — Trace-level logging
  - debug(msg, module_id) — Debug-level logging
  - info(msg, module_id) — Info-level logging
  - warn(msg, module_id) — Warning-level logging
  - error(msg, module_id) — Error-level logging

config:
  - get_string(key, default) — Get string config value
  - get_number(key, default) — Get numeric config value
  - get_bool(key, default) — Get boolean config value

util:
  - clamp(x, min, max) — Clamp value to range
  - lerp(a, b, t) — Linear interpolation
  - round(x, decimals) — Round to decimal places
  - deepcopy(tbl) — Deep copy a table
  - merge(dst, src, overwrite) — Merge table src into dst
  - readonly(tbl) — Create read-only table wrapper
  - split(str, sep) — Split string by separator
  - trim(str) — Trim whitespace from string
  - safe_tostring(value) — Convert value to string safely

init:
  - register_module(id, api_table) — Register a module's public API
  - get_module(id) — Get a registered module's API
  - list_modules() — List all registered module IDs
  - register_post_init(fn) — Register post-initialization callback
  - run_post_init() — Run all post-initialization callbacks

validate:
  - table(name, tbl, schema) — Validate table against schema
]]

return {
    log = log,
    config = config,
    util = util,
    init = init,
    validate = validate,
}