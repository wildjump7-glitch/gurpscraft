-- core_physics/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())
local api = dofile(modpath .. "/api.lua")

api.movement_modifiers = dofile(modpath .. "/data/movement_modifiers.lua")
api.stamina = dofile(modpath .. "/data/stamina.lua")
api.gravity = dofile(modpath .. "/data/gravity.lua")

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    api.debug = dofile(modpath .. "/debug/physics_overlay.lua")
end

core_physics = api

return core_physics