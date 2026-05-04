-- core_combat/api.lua
-- Public API for weapons, ballistics, melee combat, armor, and suppression.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local ballistics = dofile(modpath .. "/internal/ballistics.lua")
local recoil = dofile(modpath .. "/internal/recoil.lua")
local hitzones = dofile(modpath .. "/internal/hitzones.lua")
local damage = dofile(modpath .. "/internal/damage.lua")
local armor_calc = dofile(modpath .. "/internal/armor_calc.lua")
local suppression = dofile(modpath .. "/internal/suppression.lua")
local weapon_state = dofile(modpath .. "/internal/weapon_state.lua")
local melee = dofile(modpath .. "/internal/melee.lua")
local parry = dofile(modpath .. "/internal/parry.lua")
local hitbox = dofile(modpath .. "/internal/hitbox.lua")

return {
    -- Ballistics & Ranged Combat
    fire_weapon = ballistics.fire_weapon,
    raycast = ballistics.raycast,

    -- Recoil & Firing
    apply_recoil = recoil.apply_recoil,
    get_spread = recoil.get_spread,

    -- Melee Combat
    perform_melee_attack = melee.perform_melee_attack,
    get_melee_hitbox = hitbox.get_melee_hitbox,

    -- Parry & Defense
    parry = parry.parry,
    block = parry.block,

    -- Damage & Armor
    apply_damage = damage.apply_damage,
    calculate_damage = damage.calculate_damage,
    apply_armor = armor_calc.apply_armor,

    -- Hit Zones
    get_hitzone = hitzones.get_hitzone,
    get_hitzone_multiplier = hitzones.get_hitzone_multiplier,

    -- Suppression
    apply_suppression = suppression.apply_suppression,
    get_suppression = suppression.get_suppression,

    -- Weapon State
    start_reload = weapon_state.start_reload,
    finish_reload = weapon_state.finish_reload,
    toggle_fire_mode = weapon_state.toggle_fire_mode,
    set_ads = weapon_state.set_ads,
}

return {
    -- Ballistics and ranged combat
    fire_weapon = ballistics.fire_weapon,
    raycast = ballistics.raycast,
    
    -- Recoil and firing mechanics
    apply_recoil = recoil.apply_recoil,
    get_spread = recoil.get_spread,
    
    -- Melee combat
    perform_melee_attack = melee.perform_melee_attack,
    get_melee_hitbox = hitbox.get_melee_hitbox,
    
    -- Parry and defense
    parry = parry.parry,
    block = parry.block,
    
    -- Damage and armor
    apply_damage = damage.apply_damage,
    calculate_damage = damage.calculate_damage,
    apply_armor = armor_calc.apply_armor,
    
    -- Hit zones
    get_hitzone = hitzones.get_hitzone,
    get_hitzone_multiplier = hitzones.get_hitzone_multiplier,
    
    -- Suppression
    apply_suppression = suppression.apply_suppression,
    get_suppression = suppression.get_suppression,
    
    -- Weapon state
    start_reload = weapon_state.start_reload,
    finish_reload = weapon_state.finish_reload,
    toggle_fire_mode = weapon_state.toggle_fire_mode,
    set_ads = weapon_state.set_ads,
}