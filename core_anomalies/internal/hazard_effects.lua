-- core_anomalies/internal/hazard_effects.lua
-- Hazard effect application and management

local active_hazards = {}

local function apply_hazard(actor, anomaly_type, intensity)
    if type(actor) ~= "table" or type(anomaly_type) ~= "string" then
        return false
    end
    actor.status = actor.status or {}
    actor.status.last_anomaly = anomaly_type
    actor.status.hazard_intensity = intensity or 1.0
    -- Apply specific effects based on anomaly type
    if anomaly_type == "radiation_zone" then
        actor.status.radiation = (actor.status.radiation or 0) + intensity
    elseif anomaly_type == "void_rift" then
        actor.status.void_exposure = (actor.status.void_exposure or 0) + intensity
    elseif anomaly_type == "gravity_well" then
        actor.status.gravity_distortion = true
    elseif anomaly_type == "psychic_storm" then
        actor.status.psychic_pressure = (actor.status.psychic_pressure or 0) + intensity
    elseif anomaly_type == "dimensional_tear" then
        actor.status.dimensional_instability = true
    end
    return true
end

local function get_hazard_intensity(actor, anomaly_type)
    if type(actor) ~= "table" or type(anomaly_type) ~= "string" then
        return 0
    end
    if anomaly_type == "radiation_zone" then
        return actor.status and actor.status.radiation or 0
    elseif anomaly_type == "void_rift" then
        return actor.status and actor.status.void_exposure or 0
    elseif anomaly_type == "psychic_storm" then
        return actor.status and actor.status.psychic_pressure or 0
    end
    return 0
end

local function get_hazard_type(actor)
    if type(actor) ~= "table" then
        return nil
    end
    return actor.status and actor.status.last_anomaly
end

local function clear_hazard(actor, anomaly_type)
    if type(actor) ~= "table" or type(anomaly_type) ~= "string" then
        return false
    end
    if not actor.status then
        return false
    end
    if anomaly_type == "radiation_zone" then
        actor.status.radiation = 0
    elseif anomaly_type == "void_rift" then
        actor.status.void_exposure = 0
    elseif anomaly_type == "gravity_well" then
        actor.status.gravity_distortion = nil
    elseif anomaly_type == "psychic_storm" then
        actor.status.psychic_pressure = 0
    elseif anomaly_type == "dimensional_tear" then
        actor.status.dimensional_instability = nil
    end
    return true
end

local function update_hazard_effects(actor, dt)
    if type(actor) ~= "table" then
        return false
    end
    if not actor.status then
        return false
    end
    -- Apply ongoing effects
    if actor.status.radiation and actor.status.radiation > 0 then
        -- Radiation damage over time
        actor.health = (actor.health or 100) - (dt * actor.status.radiation)
    end
    if actor.status.psychic_pressure and actor.status.psychic_pressure > 0 then
        -- Psychic pressure effects
        actor.sanity = (actor.sanity or 100) - (dt * actor.status.psychic_pressure * 0.1)
    end
    return true
end

local function is_in_hazard_zone(actor, position, anomaly_type, radius)
    if type(actor) ~= "table" or type(position) ~= "table" then
        return false
    end
    -- Simple distance check
    local dx = actor.position.x - position.x
    local dy = actor.position.y - position.y
    local dz = actor.position.z - position.z
    local distance = math.sqrt(dx*dx + dy*dy + dz*dz)
    return distance <= (radius or 10)
end

return {
    apply_hazard = apply_hazard,
    get_hazard_intensity = get_hazard_intensity,
    get_hazard_type = get_hazard_type,
    clear_hazard = clear_hazard,
    update_hazard_effects = update_hazard_effects,
    is_in_hazard_zone = is_in_hazard_zone,
}
