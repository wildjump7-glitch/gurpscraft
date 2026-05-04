-- core_quests/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}
api.internal = {}
api.internal.quest_nodes = dofile(modpath .. "/internal/quest_nodes.lua")

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

register_module_functions(api.internal.quest_nodes)

core_quests = api

return core_quests
