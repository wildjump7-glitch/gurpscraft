-- core_vehicles/internal/physics.lua

local function set_throttle(vehicle, value)
    if type(vehicle) ~= "table" or type(value) ~= "number" then
        return false
    end
    vehicle.throttle = math.max(-1, math.min(1, value))
    return true
end

local function set_steering(vehicle, value)
    if type(vehicle) ~= "table" or type(value) ~= "number" then
        return false
    end
    vehicle.steering = math.max(-1, math.min(1, value))
    return true
end

local function apply_physics(vehicle, dt)
    if type(vehicle) ~= "table" or type(dt) ~= "number" then
        return false
    end
    vehicle.position = vehicle.position or { x = 0, y = 0, z = 0 }
    vehicle.speed = vehicle.speed or 0
    vehicle.throttle = vehicle.throttle or 0
    vehicle.steering = vehicle.steering or 0
    local acceleration = (vehicle.acceleration or 1.0) * vehicle.throttle
    vehicle.speed = vehicle.speed + acceleration * dt
    local friction = (vehicle.friction or 0.1) * vehicle.speed * dt
    if vehicle.speed > 0 then
        vehicle.speed = math.max(vehicle.speed - friction, 0)
    else
        vehicle.speed = math.min(vehicle.speed + friction, 0)
    end
    vehicle.position.x = vehicle.position.x + vehicle.speed * dt
    return true
end

local function get_speed(vehicle)
    if type(vehicle) ~= "table" then
        return 0
    end
    return vehicle.speed or 0
end

return {
    set_throttle = set_throttle,
    set_steering = set_steering,
    apply_physics = apply_physics,
    get_speed = get_speed,
}
