-- core_anomalies/internal/artifact_spawner.lua
-- Artifact registry and spawning system

local artifacts = {}
local spawned_artifacts = {}
local artifact_counter = 0

local function allocate_artifact_id(artifact_type)
    artifact_counter = artifact_counter + 1
    return artifact_type .. "_" .. artifact_counter
end

local function register_artifact(id, def)
    if artifacts[id] then
        return false
    end
    if type(id) ~= "string" or id == "" or type(def) ~= "table" then
        return false
    end
    artifacts[id] = def
    return true
end

local function get_artifact(id)
    return artifacts[id]
end

local function get_all_artifacts()
    local copy = {}
    for id, def in pairs(artifacts) do
        copy[id] = def
    end
    return copy
end

local function spawn_artifact(artifact_type, position)
    local definition = get_artifact(artifact_type)
    if not definition then
        return nil
    end
    -- Clone the definition
    local instance = {}
    for k, v in pairs(definition) do
        instance[k] = v
    end
    -- Add instance state
    instance.instance_id = allocate_artifact_id(artifact_type)
    instance.position = position
    instance.spawned_at = os.time()
    instance.stability = definition.stability or 100
    spawned_artifacts[instance.instance_id] = instance
    return instance
end

local function despawn_artifact(instance_id)
    if spawned_artifacts[instance_id] then
        spawned_artifacts[instance_id] = nil
        return true
    end
    return false
end

local function get_spawned_artifact(instance_id)
    return spawned_artifacts[instance_id]
end

local function get_all_spawned_artifacts()
    local copy = {}
    for id, inst in pairs(spawned_artifacts) do
        copy[id] = inst
    end
    return copy
end

local function generate_random_artifact(anomaly_type, position)
    -- In real implementation, would use anomaly artifact_drops table
    local artifact_types = {"crystal", "core", "void_crystal"}
    local random_type = artifact_types[math.random(#artifact_types)]
    return spawn_artifact(random_type, position)
end

local function update_artifact_stability(instance_id, dt)
    local artifact = get_spawned_artifact(instance_id)
    if not artifact then
        return false
    end
    if artifact.stability and artifact.stability > 0 then
        artifact.stability = artifact.stability - (dt * 0.1) -- Decay over time
        if artifact.stability <= 0 then
            despawn_artifact(instance_id)
            return false
        end
    end
    return true
end

return {
    register_artifact = register_artifact,
    get_artifact = get_artifact,
    get_all_artifacts = get_all_artifacts,
    spawn_artifact = spawn_artifact,
    despawn_artifact = despawn_artifact,
    get_spawned_artifact = get_spawned_artifact,
    get_all_spawned_artifacts = get_all_spawned_artifacts,
    generate_random_artifact = generate_random_artifact,
    update_artifact_stability = update_artifact_stability,
}
