-- core_inventory/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())
local api = dofile(modpath .. "/api.lua")

api.slots = dofile(modpath .. "/data/slots.lua")
api.encumbrance_thresholds = dofile(modpath .. "/data/encumbrance.lua")

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    api.debug = dofile(modpath .. "/debug/inventory_viewer.lua")
end

core_inventory = api

return core_inventory