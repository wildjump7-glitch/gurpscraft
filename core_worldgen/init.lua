-- core_worldgen/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}
api.data.biomes = dofile(modpath .. "/data/biomes.lua")
api.data.structures = dofile(modpath .. "/data/structures.lua")
api.data.noise_profiles = dofile(modpath .. "/data/noise_profiles.lua")
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

register_module_functions(api.mapgen)
register_module_functions(api.biome_selector)
register_module_functions(api.structure_placer)
register_module_functions(api.noise)
register_module_functions(api.spawn_rules)

if type(api.data.biomes) == "table" then
    for id, def in pairs(api.data.biomes) do
        api.register_biome(id, def)
    end
end

if type(api.data.noise_profiles) == "table" then
    for id, def in pairs(api.data.noise_profiles) do
        api.register_noise(id, def)
    end
end

if type(api.data.structures) == "table" then
    for id, def in pairs(api.data.structures) do
        api.register_structure(id, def)
    end
end

core_worldgen = api

return core_worldgen
