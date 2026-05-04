-- core_physics/internal/knockback.lua

local get_knockback_resistance

local function apply_knockback(actor, direction, magnitude)
    if not actor or not actor.add_velocity then
        return false
    end
    local resistance = get_knockback_resistance(actor)
    local vel = vector.multiply(direction, magnitude)
    actor:add_velocity(vector.multiply(vel, 1 - resistance))
    return true
end

get_knockback_resistance = function(actor)
    local _ = actor
    local penalty = core_inventory.get_encumbrance_penalty(actor) or 0
    return core_foundation.util.clamp(0.1 + penalty, 0.1, 0.8)
end

return {
    apply_knockback = apply_knockback,
    get_knockback_resistance = get_knockback_resistance,
}