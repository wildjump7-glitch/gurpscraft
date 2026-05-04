-- core_foundation/internal/loader.lua
-- Module registration and initialization management.

local modules = {}
local post_init_fns = {}

--[[
Register a module's public API table under a given ID.
Other modules can retrieve it via get_module(id).
]]
local function register_module(id, api_table)
    assert(type(id) == "string", "register_module: id must be a string")
    assert(type(api_table) == "table", "register_module: api_table must be a table")
    modules[id] = api_table
end

--[[
Get a previously registered module API by ID.
Returns the API table, or nil if not registered.
]]
local function get_module(id)
    assert(type(id) == "string", "get_module: id must be a string")
    return modules[id]
end

--[[
List all registered module IDs in sorted order.
Useful for debugging and introspection.
]]
local function list_modules()
    local ids = {}
    for module_id, _ in pairs(modules) do
        table.insert(ids, module_id)
    end
    table.sort(ids)
    return ids
end

--[[
Register a callback to be run after all core modules have initialized.
Used for cross-module initialization that requires other modules to be ready.
]]
local function register_post_init(fn)
    assert(type(fn) == "function", "register_post_init: fn must be a function")
    table.insert(post_init_fns, fn)
end

--[[
Run all registered post-initialization callbacks.
Called once from the engine bootstrap after all modules are loaded.
]]
local function run_post_init()
    for _, fn in ipairs(post_init_fns) do
        fn()
    end
end

return {
    register_module = register_module,
    get_module = get_module,
    list_modules = list_modules,
    register_post_init = register_post_init,
    run_post_init = run_post_init,
}