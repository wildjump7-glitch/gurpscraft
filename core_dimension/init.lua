-- core_dimension/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}
api.data.dimension_defs = dofile(modpath .. "/data/dimension_defs.lua")

local function register_module_functions(module)
    if type(module) ~= "table" then
        return
    end
    for key, value in pairs(module) do
        if type(value) == "function" then
            api._state.registry[key] = value
        end
    end
end

register_module_functions(api.dimension_loader)
register_module_functions(api.teleport)
register_module_functions(api.rulesets)

if type(api.data.dimension_defs) == "table" then
    for id, def in pairs(api.data.dimension_defs) do
        api.register(id, def)
        api.update_rules(id, def)
    end
end

core_dimension = api

return core_dimension
