-- core_machines/internal/power.lua
-- Power management system for machines (mechanical, electrical, thermal, magical)

local power_pools = {}

local function get_power(instance_id)
    return power_pools[instance_id] or 0
end

local function add_power(instance_id, amount)
    if type(instance_id) ~= "string" or type(amount) ~= "number" then
        return false
    end
    power_pools[instance_id] = (power_pools[instance_id] or 0) + amount
    return true
end

local function consume_power(instance_id, amount)
    if type(instance_id) ~= "string" or type(amount) ~= "number" then
        return false
    end
    local current = get_power(instance_id)
    if current < amount then
        return false
    end
    power_pools[instance_id] = current - amount
    return true
end

local function is_powered(instance_id)
    return get_power(instance_id) > 0
end

local function set_power(instance_id, amount)
    if type(instance_id) ~= "string" or type(amount) ~= "number" then
        return false
    end
    power_pools[instance_id] = math.max(0, amount)
    return true
end

local function clear_power(instance_id)
    power_pools[instance_id] = nil
    return true
end

return {
    get_power = get_power,
    add_power = add_power,
    consume_power = consume_power,
    is_powered = is_powered,
    set_power = set_power,
    clear_power = clear_power,
}
