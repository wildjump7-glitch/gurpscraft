-- core_vehicles/internal/registry.lua

local vehicles = {}
local active_instances = {}
local next_instance_index = 0

local function clone(value)
    if type(value) ~= "table" then
        return value
    end
    local copy = {}
    for key, item in pairs(value) do
        copy[key] = clone(item)
    end
    return copy
end

local function register(id, definition)
    if type(id) ~= "string" or id == "" or type(definition) ~= "table" then
        return false
    end
    if vehicles[id] then
        return false
    end
    vehicles[id] = clone(definition)
    vehicles[id].id = id
    return true
end

local function get(id)
    if type(id) ~= "string" then
        return nil
    end
    return vehicles[id]
end

local function all()
    local copy = {}
    for id, def in pairs(vehicles) do
        copy[id] = def
    end
    return copy
end

local function allocate_instance_id(base)
    base = (type(base) == "string" and base ~= "") and base or "vehicle"
    next_instance_index = next_instance_index + 1
    return base .. "_" .. tostring(next_instance_index)
end

local function spawn(vehicle_id, position, overrides)
    if type(vehicle_id) ~= "string" or vehicle_id == "" then
        return nil
    end
    local vehicle_def = get(vehicle_id)
    if type(vehicle_def) ~= "table" then
        return nil
    end

    local vehicle = clone(vehicle_def)
    vehicle.type = "vehicle"
    vehicle.definition_id = vehicle_id
    vehicle.instance_id = allocate_instance_id(vehicle_id)
    vehicle.position = (type(position) == "table" and position) or { x = 0, y = 0, z = 0 }
    vehicle.speed = vehicle.speed or 0
    vehicle.throttle = 0
    vehicle.steering = 0
    vehicle.health = vehicle.max_health or vehicle.health or 100
    vehicle.fuel = vehicle.max_fuel or vehicle.fuel or 0
    vehicle.cargo = vehicle.cargo or {}
    vehicle.components = vehicle.components or {}
    vehicle.seats = vehicle.seats or {}
    vehicle.seat_roles = vehicle.seat_roles or {}

    if type(overrides) == "table" then
        for key, value in pairs(overrides) do
            if key ~= "definition_id" and key ~= "instance_id" then
                vehicle[key] = value
            end
        end
    end

    active_instances[vehicle.instance_id] = vehicle
    return vehicle
end

local function despawn(subject)
    if type(subject) == "table" and type(subject.instance_id) == "string" then
        active_instances[subject.instance_id] = nil
        return true
    elseif type(subject) == "string" then
        if active_instances[subject] then
            active_instances[subject] = nil
            return true
        end
    end
    return false
end

return {
    register = register,
    get = get,
    all = all,
    spawn = spawn,
    despawn = despawn,
}
