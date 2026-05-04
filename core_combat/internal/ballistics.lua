-- core_combat/internal/ballistics.lua

local function raycast(origin, direction, range)
    local ray = minetest.raycast(origin, vector.add(origin, vector.multiply(direction, range)), false, true)
    local hit = ray:next()
    if hit then
        return hit
    end
    return nil
end

local function fire_weapon(acore_combat/internalctor, weapon_id, context)
    local _ = context
    local weapon = core_items.get(weapon_id)
    if weapon and weapon.type == "weapon" then
        local origin = actor:get_pos()
        local direction = actor:get_look_dir()
        -- Simple spread calculation
        local spread = (weapon.spread or 0.01) * (1 + (actor.combat_recoil or 0))
        direction = vector.normalize({
            x = direction.x + math.random() * spread - (spread * 0.5),
            y = direction.y + math.random() * spread - (spread * 0.5),
            z = direction.z + math.random() * spread - (spread * 0.5),
        })
        local hit = raycast(origin, direction, weapon.range or 100)
        if hit and hit.object and hit.object.set_hp then
            local hitzone = "torso" -- simplified
            local amount = weapon.damage or 10
            hit.object:set_hp(hit.object:get_hp() - amount)
        end
        -- Apply recoil
        actor.combat_recoil = (actor.combat_recoil or 0) + (weapon.recoil or 0.1)
        return true
    end
    return false
end

return {
    fire_weapon = fire_weapon,
    raycast = raycast,
}