-- core_destruction/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())
core_destruction = {}

local state = {
    materials = dofile(modpath .. "/data/materials.lua"),
    collapse_profiles = dofile(modpath .. "/data/collapse_profiles.lua"),
    fire_profiles = dofile(modpath .. "/data/fire_profiles.lua"),
    block_hp = {},
    ruins = {},
}

core_destruction._state = state

local api = dofile(modpath .. "/api.lua")
for key, value in pairs(api) do
    core_destruction[key] = value
end

if type(state.materials) == "table" then
    for node_id, material_def in pairs(state.materials) do
        core_destruction.register_material(node_id, material_def)
    end
end

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    dofile(modpath .. "/debug/integrity_overlay.lua")
    dofile(modpath .. "/debug/collapse_test.lua")
    dofile(modpath .. "/debug/penetration_test.lua")
    dofile(modpath .. "/debug/explosion_test.lua")
    dofile(modpath .. "/debug/fire_test.lua")
    dofile(modpath .. "/debug/siege_test.lua")
    dofile(modpath .. "/debug/kaiju_test.lua")
end

return core_destruction