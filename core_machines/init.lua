-- core_machines/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}
api.data.machines = dofile(modpath .. "/data/machines.lua")
api.data.recipes = dofile(modpath .. "/data/recipes.lua")
api.data.power_profiles = dofile(modpath .. "/data/power_profiles.lua")

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

-- Register machine definitions at init time
if type(api.data.machines) == "table" then
    for machine_id, machine_def in pairs(api.data.machines) do
        api.register(machine_id, machine_def)
    end
end

-- Register internal function modules
register_module_functions(api.machine_logic)
register_module_functions(api.power)
register_module_functions(api.automation)
register_module_functions(api.multiblock)
register_module_functions(api.machine_fx)

core_machines = api

return core_machines
