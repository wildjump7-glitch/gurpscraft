-- core_vehicles/internal/fuel.lua

local function get_fuel(vehicle)
    if type(vehicle) ~= "table" then
        return 0
    end
    return vehicle.fuel or 0
end

local function add_fuel(vehicle, amount)
    if type(vehicle) ~= "table" or type(amount) ~= "number" then
        return false
    end
    vehicle.fuel = (vehicle.fuel or 0) + amount
    return true
end

local function consume_fuel(vehicle, amount)
    if type(vehicle) ~= "table" or type(amount) ~= "number" then
        return false
    end
    if (vehicle.fuel or 0) < amount then
        return false
    end
    vehicle.fuel = vehicle.fuel - amount
    return true
end

local function is_out_of_fuel(vehicle)
    return get_fuel(vehicle) <= 0
end

return {
    get_fuel = get_fuel,
    add_fuel = add_fuel,
    consume_fuel = consume_fuel,
    is_out_of_fuel = is_out_of_fuel,
}
