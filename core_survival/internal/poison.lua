-- core_survival/internal/poison.lua

local function apply_poison(actor, toxin_id, amount)
    if type(actor) ~= "table" or type(toxin_id) ~= "string" or type(amount) ~= "number" then
        return false
    end
    local toxin = core_survival and core_survival.data and core_survival.data.toxins and core_survival.data.toxins[toxin_id]
    if not toxin then
        return false
    end
    actor.survival = actor.survival or {}
    actor.survival.poison = actor.survival.poison or 0
    actor.survival.poison = actor.survival.poison + (toxin.damage * amount)
    return true
end

local function update_poison(actor, dt)
    if type(actor) ~= "table" or type(dt) ~= "number" then
        return false
    end
    if actor.survival and actor.survival.poison and actor.survival.poison > 0 then
        local damage = actor.survival.poison * dt * 0.01
        actor.hp = (actor.hp or 0) - damage
        actor.survival.poison = math.max(0, actor.survival.poison - dt * 0.5)
    end
    return true
end

return {
    apply_poison = apply_poison,
    update_poison = update_poison,
}
