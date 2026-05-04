-- core_survival/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}
api.data.survival_constants = dofile(modpath .. "/data/survival_constants.lua")
api.data.diseases = dofile(modpath .. "/data/diseases.lua")
api.data.toxins = dofile(modpath .. "/data/toxins.lua")
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

register_module_functions(api.hunger)
register_module_functions(api.thirst)
register_module_functions(api.temperature)
register_module_functions(api.radiation)
register_module_functions(api.disease)
register_module_functions(api.poison)
register_module_functions(api.fatigue)
register_module_functions(api.environment)
core_survival = api

return core_survival
