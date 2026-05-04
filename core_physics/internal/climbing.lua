-- core_physics/internal/climbing.lua

local function is_climbing(actor)
    if not actor or not actor.get_pos then
        return false
    end
    local pos = actor:get_pos()
    local node = minetest.get_node(pos)
    return node and node.name and node.name:find("ladder", 1, true) ~= nil
end

local function get_climb_speed()
    local modifiers = core_physics.movement_modifiers or {}
    return modifiers.climb_speed or 2.0
end

local function as_object_ref(actor)
    if actor and actor.add_velocity then
        return actor
    end
    if actor and actor.get_luaentity and actor.object then
        return actor.object
    end
    return nil
end

local function apply_climb_movement(actor)
    local obj = as_object_ref(actor)
    if not obj or not is_climbing(obj) then
        return false
    end
    obj:add_velocity({ x = 0, y = get_climb_speed(), z = 0 })
    core_physics.apply_stamina_drain(obj, (core_physics.stamina and core_physics.stamina.climb_drain) or 2)
    return true
end

return {
    is_climbing = is_climbing,
    apply_climb_movement = apply_climb_movement,
}