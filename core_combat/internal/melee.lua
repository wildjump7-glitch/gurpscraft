-- core_combat/internal/melee.lua

local function perform_melee_attack(actor, weapon_id)
    if not actor or not actor.get_pos then
        return false
    end
    local pos = actor:get_pos()
    local nearby = minetest.get_objects_inside_radius(pos, 2)
    for _, obj in ipairs(nearby) do
        if obj ~= actor then
            local amount = 10 -- placeholder damage
            local weapon = core_items.get(weapon_id)
            if weapon and weapon.damage then
                amount = weapon.damage
            end
            -- Apply damage directly, assuming target has set_hp
            if obj.set_hp and obj.get_hp then
                obj:set_hp(obj:get_hp() - amount)
            end
            return true
        end
    end
    return false
end

return {
    perform_melee_attack = perform_melee_attack,
}