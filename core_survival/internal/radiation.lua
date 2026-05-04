-- core_survival/internal/radiation.lua

local function ensure(actor)
    if type(actor) ~= "table" then
        return nil
    end
    actor.survival = actor.survival or {}
    actor.survival.radiation = actor.survival.radiation or 0
    return actor
end

local function get_radiation(actor)
    actor = ensure(actor)
    return actor and actor.survival.radiation or 0
end

local function modify_radiation(actor, delta)
    actor = ensure(actor)
    if not actor or type(delta) ~= "number" then
        return false
    end
    actor.survival.radiation = actor.survival.radiation + delta
    return true
end

local function apply_radiation_sickness(actor)
    actor = ensure(actor)
    if not actor then
        return false
    end
    if actor.survival.radiation > 100 then
        actor.hp = (actor.hp or 0) - 1
    end
    return true
end

return {
    get_radiation = get_radiation,
    modify_radiation = modify_radiation,
    apply_radiation_sickness = apply_radiation_sickness,
}
