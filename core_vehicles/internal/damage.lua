-- core_vehicles/internal/damage.lua

local function apply_damage(vehicle, amount)
    if type(vehicle) ~= "table" or type(amount) ~= "number" then
        return false
    end
    vehicle.health = (vehicle.health or 0) - amount
    return true
end

local function get_health(vehicle)
    if type(vehicle) ~= "table" then
        return 0
    end
    return vehicle.health or 0
end

local function damage_component(vehicle, component, amount)
    if type(vehicle) ~= "table" or type(component) ~= "string" or type(amount) ~= "number" then
        return false
    end
    vehicle.components = vehicle.components or {}
    vehicle.components[component] = (vehicle.components[component] or 0) - amount
    return true
end

return {
    apply_damage = apply_damage,
    get_health = get_health,
    damage_component = damage_component,
}
