-- core_combat/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())
local api = dofile(modpath .. "/api.lua")

api.hitzones = dofile(modpath .. "/data/hitzones.lua")
api.damage_types = dofile(modpath .. "/data/damage_types.lua")

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    api.debug = dofile(modpath .. "/debug/hit_debug.lua")
end

core_combat = api

return core_combat