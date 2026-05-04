-- core_foundation/init.lua
-- Module initialization and public API exposure.

local modpath = minetest.get_modpath(minetest.get_current_modname())

-- Load data
local constants = dofile(modpath .. "/data/constants.lua")

-- Load and expose public API
local api = dofile(modpath .. "/api.lua")

-- Attach constants to API
api.const = constants

-- Register this module
core_foundation = api

-- Load debug commands if enabled
dofile(modpath .. "/debug/commands.lua")

return core_foundation