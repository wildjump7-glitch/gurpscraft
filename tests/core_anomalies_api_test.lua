-- tests/core_anomalies_api_test.lua

local api = dofile("../core_anomalies/init.lua")

-- Validate data loaded
assert(type(api.data.anomaly_types) == "table", "anomaly_types data not loaded")
assert(type(api.data.artifact_types) == "table", "artifact_types data not loaded")
assert(api.data.anomaly_types.radiation_zone ~= nil, "radiation_zone not in data")
assert(api.data.artifact_types.crystal ~= nil, "crystal artifact not in data")

-- Test anomaly registration
assert(api.anomaly_logic.register_anomaly("test_anomaly", {id = "test_anomaly", name = "Test"}), "should register anomaly")
assert(not api.anomaly_logic.register_anomaly("radiation_zone", {}), "should not re-register existing anomaly")

-- Test anomaly retrieval
local anomaly = api.anomaly_logic.get_anomaly("radiation_zone")
assert(anomaly ~= nil, "radiation_zone should be retrievable")
assert(anomaly.id == "radiation_zone", "anomaly id should match")
assert(anomaly.intensity == 0.6, "anomaly intensity should be 0.6")

-- Test anomaly spawning
local spawned = api.anomaly_logic.spawn_anomaly("radiation_zone", {x=0, y=0, z=0})
assert(spawned ~= nil, "spawn_anomaly should return instance")
assert(spawned.instance_id ~= nil, "instance should have instance_id")
assert(spawned.active == true, "spawned anomaly should be active")

-- Test artifact registration
assert(api.artifact_spawner.register_artifact("test_artifact", {id = "test_artifact", name = "Test"}), "should register artifact")
assert(not api.artifact_spawner.register_artifact("crystal", {}), "should not re-register existing artifact")

-- Test artifact spawning
local artifact = api.artifact_spawner.spawn_artifact("crystal", {x=1, y=1, z=1})
assert(artifact ~= nil, "spawn_artifact should return instance")
assert(artifact.instance_id ~= nil, "artifact should have instance_id")
assert(artifact.stability == 100, "artifact should have default stability")

-- Test hazard effects
local mock_actor = {position = {x=0, y=0, z=0}, status = {}}
assert(api.hazard_effects.apply_hazard(mock_actor, "radiation_zone", 0.5), "should apply hazard")
assert(api.hazard_effects.get_hazard_type(mock_actor) == "radiation_zone", "should get hazard type")
assert(api.hazard_effects.get_hazard_intensity(mock_actor, "radiation_zone") == 0.5, "should get hazard intensity")

-- Test hazard zone detection
assert(api.hazard_effects.is_in_hazard_zone(mock_actor, {x=0, y=0, z=0}, "radiation_zone", 10), "should be in hazard zone")
assert(not api.hazard_effects.is_in_hazard_zone(mock_actor, {x=20, y=0, z=0}, "radiation_zone", 10), "should not be in hazard zone")

-- Test anomaly despawn
assert(api.anomaly_logic.despawn_anomaly(spawned.instance_id), "should despawn anomaly")
assert(api.anomaly_logic.get_active_anomaly(spawned.instance_id) == nil, "anomaly should no longer exist")

-- Test artifact despawn
assert(api.artifact_spawner.despawn_artifact(artifact.instance_id), "should despawn artifact")
assert(api.artifact_spawner.get_spawned_artifact(artifact.instance_id) == nil, "artifact should no longer exist")

return {
    module = "core_anomalies",
    has_api = type(api) == "table",
    data_loaded = api.data.anomaly_types ~= nil and api.data.artifact_types ~= nil,
    anomalies_registered = api.anomaly_logic.get_anomaly("radiation_zone") ~= nil,
    artifacts_registered = api.artifact_spawner.get_artifact("crystal") ~= nil,
}
