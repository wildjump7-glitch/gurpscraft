-- core_survival/internal/thirst.lua

local function ensure(actor)
    if type(actor) ~= "table" then
        return nil
    end
    actor.survival = actor.survival or {}
    actor.survival.thirst = actor.survival.thirst or 100
    return actor
end

local function get_thirst(actor)
    actor = ensure(actor)
    return actor and actor.survival.thirst or 0
end

local function set_thirst(actor, amount)
    actor = ensure(actor)
    if not actor or type(amount) ~= "number" then
        return false
    end
    actor.survival.thirst = math.max(0, math.min(100, amount))
    return true
end

local function modify_thirst(actor, delta)
    actor = ensure(actor)
    if not actor or type(delta) ~= "number" then
        return false
    end
    actor.survival.thirst = math.max(0, math.min(100, actor.survival.thirst + delta))
    return true
end

local function apply_dehydration(actor)
    actor = ensure(actor)
    if not actor then
        return false
    end
    if actor.survival.thirst <= 0 then
        actor.hp = (actor.hp or 0) - 1
    end
    return true
end

return {
    get_thirst = get_thirst,
    set_thirst = set_thirst,
    modify_thirst = modify_thirst,
    apply_dehydration = apply_dehydration,
}
