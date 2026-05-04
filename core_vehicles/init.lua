-- core_vehicles/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}
api.data.vehicles = dofile(modpath .. "/data/vehicles.lua")
api.data.physics_profiles = dofile(modpath .. "/data/physics_profiles.lua")
api.data.components = dofile(modpath .. "/data/components.lua")

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
register_module_functions(api.physics)
register_module_functions(api.damage)
register_module_functions(api.fuel)
register_module_functions(api.seats)
register_module_functions(api.cargo)
register_module_functions(api.ai)

if type(api.data.vehicles) == "table" then
    for id, vehicle in pairs(api.data.vehicles) do
        api.register(id, vehicle)
    end
end

core_vehicles = api

return core_vehicles
