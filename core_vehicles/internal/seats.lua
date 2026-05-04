-- core_vehicles/internal/seats.lua

local function enter(vehicle, rider, seat_id)
    if type(vehicle) ~= "table" or type(rider) ~= "table" or type(seat_id) ~= "string" then
        return false
    end
    vehicle.seats = vehicle.seats or {}
    vehicle.seats[seat_id] = rider
    return true
end

local function exit(vehicle, seat_id)
    if type(vehicle) ~= "table" or type(seat_id) ~= "string" then
        return false
    end
    if vehicle.seats then
        vehicle.seats[seat_id] = nil
    end
    return true
end

local function switch_seat(vehicle, from_seat, to_seat)
    if type(vehicle) ~= "table" or type(from_seat) ~= "string" or type(to_seat) ~= "string" then
        return false
    end
    if not vehicle.seats or not vehicle.seats[from_seat] then
        return false
    end
    vehicle.seats[to_seat] = vehicle.seats[from_seat]
    vehicle.seats[from_seat] = nil
    return true
end

local function get_seat_role(vehicle, seat_id)
    if type(vehicle) ~= "table" or type(seat_id) ~= "string" then
        return nil
    end
    return vehicle.seat_roles and vehicle.seat_roles[seat_id]
end

local function is_vehicle(subject)
    return type(subject) == "table" and subject.type == "vehicle"
end

local function validate_item(item)
    return type(item) == "table"
end

local function validate_actor_equipment(actor)
    return type(actor) == "table"
end

return {
    enter = enter,
    exit = exit,
    switch_seat = switch_seat,
    get_seat_role = get_seat_role,
    is_vehicle = is_vehicle,
    validate_item = validate_item,
    validate_actor_equipment = validate_actor_equipment,
}
