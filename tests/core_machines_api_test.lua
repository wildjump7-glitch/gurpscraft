-- tests/core_machines_api_test.lua

local api = dofile("../core_machines/init.lua")

-- Validate machine definitions loaded
assert(type(api.data.machines) == "table", "machines data not loaded")
assert(api.data.machines.furnace ~= nil, "furnace machine not found in data")
assert(api.data.machines.grinder ~= nil, "grinder machine not found in data")

-- Test machine registration
assert(api.register("test_oven", { id = "test_oven", name = "Test Oven", power_usage = 8 }), "should register new machine")
assert(not api.register("furnace", {}), "should not re-register existing machine")

-- Test machine retrieval
local furnace = api.get("furnace")
assert(furnace ~= nil, "furnace machine should be retrievable")
assert(furnace.id == "furnace", "furnace id should match")
assert(furnace.power_usage == 10, "furnace power_usage should be 10")

-- Test all machines
local all_machines = api.all()
assert(type(all_machines) == "table", "all() should return table")
assert(all_machines.furnace ~= nil, "all machines should include furnace")

-- Test machine spawning
local furnace_instance = api.machine_logic.spawn_instance("furnace")
assert(furnace_instance ~= nil, "spawn_instance should return instance")
assert(furnace_instance.instance_id ~= nil, "instance should have instance_id")
assert(furnace_instance.state == "idle", "new instance should be idle")
assert(furnace_instance.power_stored == 0, "new instance should have 0 power")

-- Test power management
local instance_id = furnace_instance.instance_id
assert(api.get_power(furnace_instance) == 0 or api.power.get_power(instance_id) == 0, "initial power should be 0")
assert(api.power.add_power(instance_id, 50), "should add power")
assert(api.power.get_power(instance_id) == 50, "power should be 50 after add")
assert(api.power.is_powered(instance_id), "should be powered")
assert(api.power.consume_power(instance_id, 10), "should consume power")
assert(api.power.get_power(instance_id) == 40, "power should be 40 after consume")

-- Test machine state
assert(api.get_state(furnace_instance) == "idle" or api.machine_logic.get_state(instance_id) == "idle", "state should be idle")
assert(api.set_state(furnace_instance, "working") or api.machine_logic.set_state(instance_id, "working"), "should set state to working")
assert(api.machine_logic.get_state(instance_id) == "working", "state should now be working")

-- Test processing
assert(api.machine_logic.set_state(instance_id, "idle"), "reset to idle")
assert(api.machine_logic.can_process(instance_id), "should be able to process when idle and powered")
assert(api.machine_logic.start_process(instance_id), "should start process")
assert(api.machine_logic.get_state(instance_id) == "working", "state should be working after start_process")
assert(api.machine_logic.finish_process(instance_id), "should finish process")
assert(api.machine_logic.get_state(instance_id) == "idle", "state should return to idle after finish_process")

-- Test instance despawn
assert(api.machine_logic.despawn_instance(instance_id), "should despawn instance")
assert(api.machine_logic.get_instance(instance_id) == nil, "instance should no longer exist")

-- Test automation
assert(api.automation.push_items(instance_id, {}) == true or false, "push_items should execute without error")
assert(api.automation.pull_items(instance_id) == true or false, "pull_items should execute without error")
assert(api.automation.sort_items(instance_id) == true or false, "sort_items should execute without error")

-- Test multiblock
assert(api.multiblock.validate_multiblock({}) == false, "empty multiblock should be invalid")
local valid_multiblock = { pattern = {}, center = {} }
assert(api.multiblock.validate_multiblock(valid_multiblock), "multiblock with pattern and center should be valid")
assert(api.multiblock.get_multiblock_center(valid_multiblock) ~= nil, "should get multiblock center")

-- Test machine effects
assert(api.machine_fx.play_effect(instance_id, "spark") == true or false, "play_effect should execute without error")

return {
    module = "core_machines",
    has_api = type(api) == "table",
    machines_loaded = api.data.machines ~= nil,
    furnace_registered = api.get("furnace") ~= nil,
    grinder_registered = api.get("grinder") ~= nil,
}
