-- core_physics/internal/swimming.lua

local function is_swimming(actor)
    if not actor or not actor.get_pos then
        return false
    end
    local node = minetest.get_node(actor:get_pos())
    return node and node.name and node.name:find("water", 1, true) ~= nil
end

local function apply_swim_movement(actor)
    if not actor or not actor.add_velocity then
        return false
    end
    if not is_swimming(actor) then
        return false
    end
    actor:add_velocity({ x = 0, y = 0.2, z = 0 })
    core_physics.apply_stamina_drain(actor, (core_physics.stamina and core_physics.stamina.swim_drain) or 3)
    return true
end

local function apply_drowning(actor)
    if not actor or not actor.set_hp or not actor.get_hp then
        return false
    end
    if not is_swimming(actor) then
        return false
    end
    local stamina = core_physics.get_stamina(actor)
    if stamina <= 0 then
        actor:set_hp(actor:get_hp() - 1)
        return true
    end
    return false
end

return {
    is_swimming = is_swimming,
    apply_swim_movement = apply_swim_movement,
    apply_drowning = apply_drowning,
}