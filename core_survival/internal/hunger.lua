-- core_survival/internal/hunger.lua

local function ensure(actor)
    if type(actor) ~= "table" then
        return nil
    end
    actor.survival = actor.survival or {}
    actor.survival.hunger = actor.survival.hunger or 100
    return actor
end

local function get_hunger(actor)
    actor = ensure(actor)
    return actor and actor.survival.hunger or 0
end

local function set_hunger(actor, amount)
    actor = ensure(actor)
    if not actor or type(amount) ~= "number" then
        return false
    end
    actor.survival.hunger = math.max(0, math.min(100, amount))
    return true
end

local function modify_hunger(actor, delta)
    actor = ensure(actor)
    if not actor or type(delta) ~= "number" then
        return false
    end
    actor.survival.hunger = math.max(0, math.min(100, actor.survival.hunger + delta))
    return true
end

local function apply_starvation(actor)
    actor = ensure(actor)
    if not actor then
        return false
    end
    if actor.survival.hunger <= 0 then
        actor.hp = (actor.hp or 0) - 1
    end
    return true
end

return {
    get_hunger = get_hunger,
    set_hunger = set_hunger,
    modify_hunger = modify_hunger,
    apply_starvation = apply_starvation,
}
