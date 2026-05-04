-- core_destruction/api.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local materials = dofile(modpath .. "/internal/materials.lua")
local block_damage = dofile(modpath .. "/internal/block_damage.lua")
local integrity = dofile(modpath .. "/internal/integrity.lua")
local explosions = dofile(modpath .. "/internal/explosions.lua")
local penetration = dofile(modpath .. "/internal/penetration.lua")
local fire = dofile(modpath .. "/internal/fire.lua")
local corrosion = dofile(modpath .. "/internal/corrosion.lua")
local ruins = dofile(modpath .. "/internal/ruins.lua")
local siege = dofile(modpath .. "/internal/siege.lua")
local kaiju = dofile(modpath .. "/internal/kaiju.lua")

return {
    get_material = materials.get_material,
    register_material = materials.register_material,
    apply_damage = block_damage.apply_damage,
    get_block_hp = block_damage.get_block_hp,
    set_block_hp = block_damage.set_block_hp,
    break_block = block_damage.break_block,
    check_support = integrity.check_support,
    get_integrity = integrity.get_integrity,
    trigger_collapse = integrity.trigger_collapse,
    update_integrity = integrity.update_integrity,
    explode = explosions.explode,
    apply_shockwave = explosions.apply_shockwave,
    penetrate = penetration.penetrate,
    get_penetration_cost = penetration.get_penetration_cost,
    ignite = fire.ignite,
    extinguish = fire.extinguish,
    apply_corrosion = corrosion.apply_corrosion,
    save_ruin = ruins.save_ruin,
    load_ruin = ruins.load_ruin,
    clear_ruin = ruins.clear_ruin,
    apply_siege_damage = siege.apply_siege_damage,
    apply_kaiju_impact = kaiju.apply_kaiju_impact,
    create_breach = siege.create_breach,
    undermine = siege.undermine,
}