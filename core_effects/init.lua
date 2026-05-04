-- core_effects/init.lua

-- Load the API
local api = dofile("api.lua")

-- Load data
api.particle_presets = core_data.load_file("core_effects/data/particle_presets.lua") or {}
api.weather_profiles = core_data.load_file("core_effects/data/weather_profiles.lua") or {}
api._state = {
    loops = {},
    weather = {},
}

-- Expose the public API
core_effects = api
return core_effects
