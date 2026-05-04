-- core_physics/internal/movement.lua

local function get_move_speed(actor)
    local base = (core_physics.movement_modifiers and core_physics.movement_modifiers.base_speed) or 4.0
    local enc_penalty = core_inventory.get_encumbrance_penalty(actor) or 0
    local stamina = core_physics.get_stamina(actor)
    local stamina_max = (core_physics.stamina and core_physics.stamina.max) or 100
    local stamina_factor = 1.0
    if stamina_max > 0 and stamina < (0.2 * stamina_max) then
        stamina_factor = 0.8
    end
    return base * (1 - enc_penalty) * stamina_factor
end

local function apply_movement(actor)
    if actor and actor.set_physics_override then
        actor:set_physics_override({ speed = get_move_speed(actor) / 4.0 })
        return true
    end
    return false
end

local function get_jump_height(actor)
    local base = 1.0
    local enc_penalty = core_inventory.get_encumbrance_penalty(actor) or 0
    return math.max(0.25, base - enc_penalty)
end

local function apply_jump(actor)
    if actor and actor.add_velocity then
        actor:add_velocity({ x = 0, y = get_jump_height(actor), z = 0 })
        core_physics.apply_stamina_drain(actor, (core_physics.stamina and core_physics.stamina.jump_drain) or 2)
        return true
    end
    return false
end

return {
    get_move_speed = get_move_speed,
    apply_movement = apply_movement,
    get_jump_height = get_jump_height,
    apply_jump = apply_jump,
}