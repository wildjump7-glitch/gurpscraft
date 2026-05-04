-- core_machines/internal/machine_logic.lua
-- Machine registry and instance tracking for spawned machines

local machines = {}
local active_instances = {}
local instance_counter = 0

local function allocate_instance_id(machine_id)
    instance_counter = instance_counter + 1
    return machine_id .. "_" .. instance_counter
end

local function register(id, definition)
    if machines[id] then
        return false
    end
    if type(id) ~= "string" or id == "" or type(definition) ~= "table" then
        return false
    end
    machines[id] = definition
    return true
end

local function get(id)
    return machines[id]
end

local function all()
    local copy = {}
    for id, def in pairs(machines) do
        copy[id] = def
    end
    return copy
end

local function spawn_instance(machine_id, overrides)
    local definition = get(machine_id)
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
    instance.instance_id = allocate_instance_id(machine_id)
    instance.state = "idle"
    instance.power_stored = 0
    instance.heat_stored = 0
    instance.processing = false
    instance.progress = 0
    active_instances[instance.instance_id] = instance
    return instance
end

local function despawn_instance(instance_id)
    if active_instances[instance_id] then
        active_instances[instance_id] = nil
        return true
    end
    return false
end

local function get_instance(instance_id)
    return active_instances[instance_id]
end

local function all_instances()
    local copy = {}
    for id, inst in pairs(active_instances) do
        copy[id] = inst
    end
    return copy
end

local function can_process(instance_id)
    local instance = get_instance(instance_id)
    if not instance then
        return false
    end
    return instance.state == "idle" and instance.power_stored >= (instance.power_usage or 0)
end

local function process(instance_id, input, dt)
    local instance = get_instance(instance_id)
    if not instance then
        return false
    end
    if instance.power_stored < (instance.power_usage or 0) then
        return false
    end
    -- Consume power during processing
    instance.power_stored = instance.power_stored - (instance.power_usage or 0)
    instance.progress = (instance.progress or 0) + dt * (instance.crafting_speed or 1.0)
    return true
end

local function start_process(instance_id)
    local instance = get_instance(instance_id)
    if not instance then
        return false
    end
    if instance.processing then
        return false
    end
    instance.processing = true
    instance.state = "working"
    return true
end

local function finish_process(instance_id)
    local instance = get_instance(instance_id)
    if not instance then
        return false
    end
    instance.processing = false
    instance.state = "idle"
    instance.progress = 0
    return true
end

local function set_state(instance_id, state)
    local instance = get_instance(instance_id)
    if not instance or type(state) ~= "string" then
        return false
    end
    instance.state = state
    return true
end

local function get_state(instance_id)
    local instance = get_instance(instance_id)
    if not instance then
        return nil
    end
    return instance.state
end

local function update_state(instance_id, dt)
    local instance = get_instance(instance_id)
    if not instance then
        return false
    end
    -- Heat dissipation
    if instance.heat_stored and instance.heat_stored > 0 then
        instance.heat_stored = instance.heat_stored - (dt * 5)
        if instance.heat_stored < 0 then
            instance.heat_stored = 0
        end
    end
    -- Overheat check
    if instance.heat_stored and instance.max_heat and instance.heat_stored > instance.max_heat then
        instance.state = "overheated"
        return false
    end
    return true
end

return {
    register = register,
    get = get,
    all = all,
    spawn_instance = spawn_instance,
    despawn_instance = despawn_instance,
    get_instance = get_instance,
    all_instances = all_instances,
    can_process = can_process,
    process = process,
    start_process = start_process,
    finish_process = finish_process,
    set_state = set_state,
    get_state = get_state,
    update_state = update_state,
}
