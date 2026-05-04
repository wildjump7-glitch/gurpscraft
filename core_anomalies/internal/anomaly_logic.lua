-- core_anomalies/internal/anomaly_logic.lua
-- Anomaly registry and behavior management

local anomalies = {}
local active_anomalies = {}
local anomaly_counter = 0

local function allocate_anomaly_id(anomaly_type)
    anomaly_counter = anomaly_counter + 1
    return anomaly_type .. "_" .. anomaly_counter
end

local function register_anomaly(id, def)
    if anomalies[id] then
        return false
    end
    if type(id) ~= "string" or id == "" or type(def) ~= "table" then
        return false
    end
    anomalies[id] = def
    return true
end

local function get_anomaly(id)
    return anomalies[id]
end

local function get_all_anomalies()
    local copy = {}
    for id, def in pairs(anomalies) do
        copy[id] = def
    end
    return copy
end

local function spawn_anomaly(anomaly_type, position, overrides)
    local definition = get_anomaly(anomaly_type)
    if not definition then
        return nil
    end
    -- Clone the definition
    local instance = {}
    for k, v in pairs(definition) do
        instance[k] = v
    end
    -- Apply overrides
    if type(overrides) == "table" then
        for k, v in pairs(overrides) do
            instance[k] = v
        end
    end
    -- Add instance state
    instance.instance_id = allocate_anomaly_id(anomaly_type)
    instance.position = position
    instance.active = true
    instance.spawned_at = os.time()
    active_anomalies[instance.instance_id] = instance
    return instance
end

local function despawn_anomaly(instance_id)
    if active_anomalies[instance_id] then
        active_anomalies[instance_id] = nil
        return true
    end
    return false
end

local function get_active_anomaly(instance_id)
    return active_anomalies[instance_id]
end

local function get_all_active_anomalies()
    local copy = {}
    for id, inst in pairs(active_anomalies) do
        copy[id] = inst
    end
    return copy
end

local function activate_field(instance_id)
    local anomaly = get_active_anomaly(instance_id)
    if not anomaly then
        return false
    end
    -- In real implementation, would activate hazard field at position
    return true
end

local function update_anomaly(instance_id, dt)
    local anomaly = get_active_anomaly(instance_id)
    if not anomaly then
        return false
    end
    -- Handle behavior updates (pulsing, mobile, etc.)
    if anomaly.behavior == "pulsing" then
        -- Pulse logic
    elseif anomaly.behavior == "mobile" then
        -- Movement logic
    end
    return true
end

local function check_trigger(instance_id, actor)
    local anomaly = get_active_anomaly(instance_id)
    if not anomaly then
        return false
    end
    -- Check trigger conditions based on anomaly.trigger_type
    if anomaly.trigger_type == "proximity" then
        -- Check distance
        return true
    elseif anomaly.trigger_type == "line_of_sight" then
        -- Check LOS
        return true
    end
    return false
end

return {
    register_anomaly = register_anomaly,
    get_anomaly = get_anomaly,
    get_all_anomalies = get_all_anomalies,
    spawn_anomaly = spawn_anomaly,
    despawn_anomaly = despawn_anomaly,
    get_active_anomaly = get_active_anomaly,
    get_all_active_anomalies = get_all_active_anomalies,
    activate_field = activate_field,
    update_anomaly = update_anomaly,
    check_trigger = check_trigger,
}
