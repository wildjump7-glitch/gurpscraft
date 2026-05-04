-- core_survival/internal/temperature.lua

local function ensure(actor)
    if type(actor) ~= "table" then
        return nil
    end
    actor.survival = actor.survival or {}
    actor.survival.temperature = actor.survival.temperature or 20
    return actor
end

local function get_temperature(actor)
    actor = ensure(actor)
    return actor and actor.survival.temperature or 0
end

local function update_temperature(actor, dtime)
    actor = ensure(actor)
    if not actor or type(dtime) ~= "number" then
        return false
    end
    local constants = (core_survival and core_survival.data and core_survival.data.survival_constants) or {}
    local ambient = (actor.environment and actor.environment.ambient_temperature) or 20
    local rate = constants.temperature_rate or 0.1
    local current = actor.survival.temperature
    actor.survival.temperature = current + (ambient - current) * math.min(dtime * rate, 1)
    return true
end

local function apply_hypothermia(actor)
    actor = ensure(actor)
    if not actor then
        return false
    end
    if actor.survival.temperature < 0 then
        actor.hp = (actor.hp or 0) - 1
    end
    return true
end

local function apply_heatstroke(actor)
    actor = ensure(actor)
    if not actor then
        return false
    end
    if actor.survival.temperature > 40 then
        actor.hp = (actor.hp or 0) - 1
    end
    return true
end

return {
    get_temperature = get_temperature,
    update_temperature = update_temperature,
    apply_hypothermia = apply_hypothermia,
    apply_heatstroke = apply_heatstroke,
}
