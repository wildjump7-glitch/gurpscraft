-- core_survival/internal/environment.lua

local function apply_environmental_damage(actor, amount)
    if type(actor) ~= "table" or type(amount) ~= "number" then
        return false
    end
    actor.hp = (actor.hp or 0) - amount
    return true
end

local function check_environment(actor)
    if type(actor) ~= "table" then
        return {}
    end
    return actor.environment or {}
end

return {
    apply_environmental_damage = apply_environmental_damage,
    check_environment = check_environment,
}
