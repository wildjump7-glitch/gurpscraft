-- core_data/api.lua
-- Public API for data loading, validation, schema management, and templates.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local loader = dofile(modpath .. "/internal/loader.lua")
local schema = dofile(modpath .. "/internal/schema.lua")
local templates = dofile(modpath .. "/internal/templates.lua")
local debug_api = dofile(modpath .. "/debug/data_inspector.lua")

--[[
Public API structure:

load_file(path) — Load a single Lua file and return its table
load_dir(path) — Load all .lua files in a directory and merge them
new_registry(name) — Create a registry object with register/get/all/validate methods

validate(def, schema, context) — Validate a table against a schema
apply_template(def, template) — Apply template inheritance to a definition
expand_templates(defs, template_table) — Expand all template references in definitions

debug: {
  dump_registry(name) — Debug helper to dump registry contents
  list_missing_keys(schema, defs) — Find missing required keys in definitions
}
]]

return {
    -- File loading
    load_file = loader.load_file,
    load_dir = loader.load_dir,
    new_registry = loader.new_registry,
    
    -- Schema and validation
    validate = schema.validate,
    
    -- Template support
    apply_template = templates.apply_template,
    expand_templates = templates.expand_templates,
    
    -- Debug tools
    debug = debug_api,
}