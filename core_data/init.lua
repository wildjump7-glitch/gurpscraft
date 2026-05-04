-- core_data/init.lua
-- Module initialization for data loading and validation infrastructure.

local modpath = minetest.get_modpath(minetest.get_current_modname())

-- Load and expose public API
local api = dofile(modpath .. "/api.lua")

-- Register this module globally
core_data = api

return core_data