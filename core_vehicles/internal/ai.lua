-- core_vehicles/internal/ai.lua

local function ai_drive(vehicle, target)
    if type(vehicle) ~= "table" then
        return false
    end
    return true
end

local function ai_flee(vehicle, threat)
    if type(vehicle) ~= "table" then
        return false
    end
    return true
end

local function ai_patrol(vehicle, route)
    if type(vehicle) ~= "table" then
        return false
    end
    return true
end

return {
    ai_drive = ai_drive,
    ai_flee = ai_flee,
    ai_patrol = ai_patrol,
}
