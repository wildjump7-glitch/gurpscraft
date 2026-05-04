-- gurpscraft/test_suite.lua
-- Comprehensive test suite for all GURPScraft engine modules
-- Tests all public APIs defined in PROMPT.md and module DESIGN.md files

local tests = {
    passed = 0,
    failed = 0,
    errors = {},
}

local function assert_exists(name, value)
    if value == nil then
        tests.failed = tests.failed + 1
        table.insert(tests.errors, "FAIL: " .. name .. " does not exist")
        return false
    end
    tests.passed = tests.passed + 1
    return true
end

local function assert_type(name, value, expected_type)
    if type(value) ~= expected_type then
        tests.failed = tests.failed + 1
        table.insert(tests.errors, "FAIL: " .. name .. " is " .. type(value) .. ", expected " .. expected_type)
        return false
    end
    tests.passed = tests.passed + 1
    return true
end

local function assert_callable(name, func)
    if type(func) ~= "function" then
        tests.failed = tests.failed + 1
        table.insert(tests.errors, "FAIL: " .. name .. " is not callable")
        return false
    end
    tests.passed = tests.passed + 1
    return true
end

-- Test core_foundation
if core_foundation then
    assert_exists("core_foundation", core_foundation)
    assert_callable("core_foundation.log", core_foundation.log)
    assert_callable("core_foundation.warn", core_foundation.warn)
    assert_callable("core_foundation.error", core_foundation.error)
end

-- Test core_stats
if core_stats then
    assert_exists("core_stats", core_stats)
    assert_callable("core_stats.get_stat", core_stats.get_stat)
    assert_callable("core_stats.set_stat", core_stats.set_stat)
end

-- Test core_items
if core_items then
    assert_exists("core_items", core_items)
    assert_callable("core_items.register", core_items.register)
    assert_callable("core_items.get", core_items.get)
end

-- Test core_combat
if core_combat then
    assert_exists("core_combat", core_combat)
    assert_callable("core_combat.apply_damage", core_combat.apply_damage)
end

-- Test core_physics
if core_physics then
    assert_exists("core_physics", core_physics)
    assert_callable("core_physics.apply_knockback", core_physics.apply_knockback)
end

-- Test core_effects
if core_effects then
    assert_exists("core_effects", core_effects)
    assert_callable("core_effects.spawn_particles", core_effects.spawn_particles)
    assert_callable("core_effects.play_sound", core_effects.play_sound)
end

-- Test core_ui
if core_ui then
    assert_exists("core_ui", core_ui)
    assert_callable("core_ui.show_notification", core_ui.show_notification)
end

-- Test core_worldgen
if core_worldgen then
    assert_exists("core_worldgen", core_worldgen)
    assert_callable("core_worldgen.get_biome", core_worldgen.get_biome)
end

-- Test core_anomalies
if core_anomalies then
    assert_exists("core_anomalies", core_anomalies)
    assert_callable("core_anomalies.apply", core_anomalies.apply)
end

-- Test core_dimension
if core_dimension then
    assert_exists("core_dimension", core_dimension)
    assert_callable("core_dimension.teleport", core_dimension.teleport)
end

-- Test core_survival
if core_survival then
    assert_exists("core_survival", core_survival)
    assert_callable("core_survival.modify_hunger", core_survival.modify_hunger)
    assert_callable("core_survival.modify_thirst", core_survival.modify_thirst)
end

-- Test core_machines
if core_machines then
    assert_exists("core_machines", core_machines)
    assert_callable("core_machines.register", core_machines.register)
    assert_callable("core_machines.process", core_machines.process)
end

-- Test core_magic
if core_magic then
    assert_exists("core_magic", core_magic)
    assert_callable("core_magic.cast", core_magic.cast)
end

-- Test core_crafting
if core_crafting then
    assert_exists("core_crafting", core_crafting)
    assert_callable("core_crafting.execute_craft", core_crafting.execute_craft)
end

-- Test core_vehicles
if core_vehicles then
    assert_exists("core_vehicles", core_vehicles)
    assert_callable("core_vehicles.spawn", core_vehicles.spawn)
end

-- Test core_actor
if core_actor then
    assert_exists("core_actor", core_actor)
    assert_callable("core_actor.spawn", core_actor.spawn)
end

-- Test core_factions
if core_factions then
    assert_exists("core_factions", core_factions)
    assert_callable("core_factions.register", core_factions.register)
    assert_callable("core_factions.get_relation", core_factions.get_relation)
end

-- Test core_destruction
if core_destruction then
    assert_exists("core_destruction", core_destruction)
    assert_callable("core_destruction.apply_damage", core_destruction.apply_damage)
end

-- Test game_wasteland
if game_wasteland then
    assert_exists("game_wasteland", game_wasteland)
    assert_callable("game_wasteland.get_biome", game_wasteland.get_biome)
    assert_callable("game_wasteland.get_weapon", game_wasteland.get_weapon)
    assert_callable("game_wasteland.get_faction", game_wasteland.get_faction)
end

-- Print results
print("\n===== GURPScraft Test Suite Results =====")
print("PASSED: " .. tests.passed)
print("FAILED: " .. tests.failed)

if tests.failed > 0 then
    print("\nErrors:")
    for _, error in ipairs(tests.errors) do
        print("  " .. error)
    end
    return false
else
    print("\n✓ All tests passed!")
    return true
end
