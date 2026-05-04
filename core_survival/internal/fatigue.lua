-- core_survival/internal/fatigue.lua

local function get_fatigue(actor)
    if type(actor) ~= "table" then
        return 0
    end
    actor.survival = actor.survival or {}
    actor.survival.fatigue = actor.survival.fatigue or 0
    return actor.survival.fatigue
end

local function modify_fatigue(actor, amount)
    if type(actor) ~= "table" or type(amount) ~= "number" then
        return false
    end
    actor.survival = actor.survival or {}
    actor.survival.fatigue = (actor.survival.fatigue or 0) + amount
    return true
end

local function apply_exhaustion(actor)
    if type(actor) ~= "table" then
        return false
    end
    if get_fatigue(actor) > 100 then
        actor.hp = (actor.hp or 0) - 1
    end
    return true
end

return {
    get_fatigue = get_fatigue,
    modify_fatigue = modify_fatigue,
    apply_exhaustion = apply_exhaustion,
}
