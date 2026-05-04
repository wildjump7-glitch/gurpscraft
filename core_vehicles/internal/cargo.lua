-- core_vehicles/internal/cargo.lua

local function get_cargo(vehicle)
    if type(vehicle) ~= "table" then
        return {}
    end
    return vehicle.cargo or {}
end

local function add_cargo(vehicle, item)
    if type(vehicle) ~= "table" or type(item) ~= "table" then
        return false
    end
    vehicle.cargo = vehicle.cargo or {}
    table.insert(vehicle.cargo, item)
    return true
end

local function remove_cargo(vehicle, item_index)
    if type(vehicle) ~= "table" or type(item_index) ~= "number" then
        return false
    end
    if not vehicle.cargo or not vehicle.cargo[item_index] then
        return false
    end
    table.remove(vehicle.cargo, item_index)
    return true
end

return {
    get_cargo = get_cargo,
    add_cargo = add_cargo,
    remove_cargo = remove_cargo,
}
