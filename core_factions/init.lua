-- core_factions/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}
api.data.factions = dofile(modpath .. "/data/factions.lua")
api.data.relations = dofile(modpath .. "/data/relations.lua")
api.data.territory = dofile(modpath .. "/data/territory.lua")

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

register_module_functions(api.registry)
register_module_functions(api.reputation)
register_module_functions(api.relations)
register_module_functions(api.hostility)
register_module_functions(api.territory)
api.strategy = dofile(modpath .. "/internal/strategy.lua")
register_module_functions(api.strategy)

if type(api.data.factions) == "table" then
    for id, def in pairs(api.data.factions) do
        api.register(id, def)
    end
end

if type(api.data.relations) == "table" then
    for faction_a, targets in pairs(api.data.relations) do
        for faction_b, relation in pairs(targets) do
            api.set_relation(faction_a, faction_b, relation)
        end
    end
end

core_factions = api

return core_factions
