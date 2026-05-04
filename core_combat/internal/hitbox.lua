-- core_combat/internal/hitbox.lua

local function get_melee_hitbox(actor, weapon_id)
    local _ = weapon_id
    if not actor or not actor.get_pos then
        return {}
    end
    local pos = actor:get_pos()
    local nearby = minetest.get_objects_inside_radius(pos, 2)
    for _, obj in ipairs(nearby) do
        if obj ~= actor then
            return { target = obj, origin = pos, radius = 2 }
        end
    end
    return { target = nil, origin = pos, radius = 2 }
end

return {
    get_melee_hitbox = get_melee_hitbox,
}