-- core_items/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())
local api = dofile(modpath .. "/api.lua")

local weapons = dofile(modpath .. "/data/weapons.lua")
local ammo = dofile(modpath .. "/data/ammo.lua")
local armor = dofile(modpath .. "/data/armor.lua")
local consumables = dofile(modpath .. "/data/consumables.lua")
local attachments = dofile(modpath .. "/data/attachments.lua")
local crafting = dofile(modpath .. "/data/crafting.lua")

for id, def in pairs(weapons) do
    api.register(id, def)
end
for id, def in pairs(ammo) do
    api.register(id, def)
end
for id, def in pairs(armor) do
    api.register(id, def)
end
for id, def in pairs(consumables) do
    api.register(id, def)
end
for id, def in pairs(attachments) do
    api.register(id, def)
end

api.crafting = crafting

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    api.debug = dofile(modpath .. "/debug/item_inspector.lua")
end

core_items = api

return core_items