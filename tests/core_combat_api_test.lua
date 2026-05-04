-- tests/core_combat_api_test.lua

local function run()
    assert(type(core_combat) == "table", "core_combat should be loaded")
    assert(type(core_combat.fire_weapon) == "function", "fire_weapon should exist")
    assert(type(core_combat.apply_damage) == "function", "apply_damage should exist")
    assert(type(core_combat.get_hitzone_multiplier) == "function", "get_hitzone_multiplier should exist")
    assert(type(core_combat.apply_armor) == "function", "apply_armor should exist")
    assert(type(core_combat.apply_suppression) == "function", "apply_suppression should exist")
    assert(type(core_combat.get_suppression) == "function", "get_suppression should exist")
    assert(type(core_combat.start_reload) == "function", "start_reload should exist")
    assert(type(core_combat.toggle_fire_mode) == "function", "toggle_fire_mode should exist")
    assert(type(core_combat.set_ads) == "function", "set_ads should exist")
    assert(type(core_combat.perform_melee_attack) == "function", "perform_melee_attack should exist")
    assert(type(core_combat.parry) == "function", "parry should exist")
    assert(type(core_combat.block) == "function", "block should exist")

    -- Test hitzone multipliers
    assert(core_combat.get_hitzone_multiplier("head") == 2.0, "head multiplier should be 2.0")
    assert(core_combat.get_hitzone_multiplier("torso") == 1.0, "torso multiplier should be 1.0")
    assert(core_combat.get_hitzone_multiplier("arms") == 0.75, "arms multiplier should be 0.75")

    -- Test armor calculation
    local mock_target = { armor = { torso = 5 } }
    local damage_after_armor = core_combat.apply_armor(mock_target, 10, "ballistic", "torso")
    assert(damage_after_armor == 5, "armor should reduce damage by 5")

    -- Test suppression
    local mock_actor = {}
    core_combat.apply_suppression(mock_actor, 0.5)
    assert(core_combat.get_suppression(mock_actor) == 0.5, "suppression should be applied")

    -- Test weapon state
    local fire_mode = core_combat.toggle_fire_mode(mock_actor)
    assert(fire_mode == "burst", "fire mode should toggle to burst")
    fire_mode = core_combat.toggle_fire_mode(mock_actor)
    assert(fire_mode == "auto", "fire mode should toggle to auto")

    assert(core_combat.set_ads(mock_actor, true), "set_ads should return true")

    return true
end

return {
    run = run,
}
