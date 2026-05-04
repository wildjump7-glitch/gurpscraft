-- core_physics/internal/stamina_drain.lua

local function get_stamina(actor)
    actor.stamina = actor.stamina or core_physics.stamina.max
    return actor.stamina
end

local function modify_stamina(actor, delta)
    actor.stamina = (actor.stamina or core_physics.stamina.max) + (delta or 0)
    if actor.stamina > core_physics.stamina.max then
        actor.stamina = core_physics.stamina.max
    end
    if actor.stamina < 0 then
        actor.stamina = 0
    end
    return actor.stamina
end

local function set_stamina(actor, value)
    local numeric = tonumber(value) or core_physics.stamina.max
    actor.stamina = core_foundation.util.clamp(numeric, 0, core_physics.stamina.max)
    return actor.stamina
end

local function apply_stamina_drain(actor, amount)
    return modify_stamina(actor, -(amount or 0))
end

local function apply_stamina_regen(actor)
    return modify_stamina(actor, core_physics.stamina.regen_rate)
end

return {
    get_stamina = get_stamina,
    modify_stamina = modify_stamina,
    set_stamina = set_stamina,
    apply_stamina_drain = apply_stamina_drain,
    apply_stamina_regen = apply_stamina_regen,
}