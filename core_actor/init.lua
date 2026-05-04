-- core_actor/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}
api.data.archetypes = dofile(modpath .. "/data/archetypes.lua")
api.data.behaviors = dofile(modpath .. "/data/behaviors.lua")

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

register_module_functions(api.actor_state)
register_module_functions(api.behavior_tree)
register_module_functions(api.perception)
register_module_functions(api.movement)
register_module_functions(api.combat_ai)
api.goals = dofile(modpath .. "/internal/goals.lua")
register_module_functions(api.goals)

core_actor = api

return core_actor
