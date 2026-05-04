-- core_magic/internal/mana.lua

local function ensure_actor(actor)
    if type(actor) ~= "table" then
        return nil
    end
    actor.magic = actor.magic or {}
    actor.magic.mana = actor.magic.mana or 0
    actor.magic.mana_regen = actor.magic.mana_regen or 0
    return actor
end

local function get_mana(actor)
    actor = ensure_actor(actor)
    return actor and actor.magic.mana or 0
end

local function set_mana(actor, amount)
    actor = ensure_actor(actor)
    if not actor or type(amount) ~= "number" then
        return false
    end
    actor.magic.mana = amount
    return true
end

local function modify_mana(actor, delta)
    actor = ensure_actor(actor)
    if not actor or type(delta) ~= "number" then
        return false
    end
    actor.magic.mana = actor.magic.mana + delta
    return true
end

local function get_mana_regen(actor)
    actor = ensure_actor(actor)
    return actor and actor.magic.mana_regen or 0
end

local function apply_mana_regen(actor, dt)
    actor = ensure_actor(actor)
    if not actor or type(dt) ~= "number" then
        return false
    end
    actor.magic.mana = actor.magic.mana + (actor.magic.mana_regen or 0) * dt
    return true
end

return {
    get_mana = get_mana,
    set_mana = set_mana,
    modify_mana = modify_mana,
    get_mana_regen = get_mana_regen,
    apply_mana_regen = apply_mana_regen,
}
