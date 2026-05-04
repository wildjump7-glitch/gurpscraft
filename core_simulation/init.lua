-- core_simulation/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}

api.internal = {}
api.internal.config = dofile(modpath .. "/internal/config.lua")
api.internal.events = dofile(modpath .. "/internal/events.lua")
api.internal.grid = dofile(modpath .. "/internal/grid.lua")
api.internal.territory = dofile(modpath .. "/internal/territory.lua")
api.internal.poi = dofile(modpath .. "/internal/poi.lua")
api.internal.squads = dofile(modpath .. "/internal/squads.lua")
api.internal.tick = dofile(modpath .. "/internal/tick.lua")
api.internal.actors = dofile(modpath .. "/internal/actors.lua")

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

register_module_functions(api.internal.events)
register_module_functions(api.internal.grid)
register_module_functions(api.internal.territory)
register_module_functions(api.internal.poi)
register_module_functions(api.internal.squads)
register_module_functions(api.internal.tick)
register_module_functions(api.internal.actors)

core_simulation = api

return core_simulation
