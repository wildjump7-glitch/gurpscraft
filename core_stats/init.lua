-- core_stats/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.attributes = dofile(modpath .. "/data/attributes.lua")
api.skills = dofile(modpath .. "/data/skills.lua")
api.traits = dofile(modpath .. "/data/traits.lua")
api.derived_definitions = dofile(modpath .. "/data/derived.lua")

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    api.debug = dofile(modpath .. "/debug/stat_inspector.lua")
end

core_stats = api

return core_stats