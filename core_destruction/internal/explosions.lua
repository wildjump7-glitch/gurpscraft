-- core_destruction/internal/explosions.lua

local function explode(pos, power, params)
    local radius = math.max(1, math.floor((power or 0) / 10))
    radius = params and params.radius or radius
    local center_damage = math.max(1, power or 0)
    for dx = -radius, radius do
        for dy = -radius, radius do
            for dz = -radius, radius do
                local target = {
                    x = pos.x + dx,
                    y = pos.y + dy,
                    z = pos.z + dz,
                }
                local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
                if distance <= radius then
                    local node = minetest.get_node(target)
                    if node and node.name ~= "air" and node.name ~= "ignore" then
                        local damage = math.max(0, center_damage * (1 - distance / (radius + 1)))
                        core_destruction.apply_damage(target, damage, "explosive")
                    end
                end
            end
        end
    end
    return true
end

local function apply_shockwave(pos, power)
    local radius = math.max(1, math.floor((power or 0) / 5))
    local objects = minetest.get_objects_inside_radius(pos, radius)
    for _, obj in ipairs(objects) do
        local obj_pos = obj:get_pos()
        if obj_pos then
            local direction = vector.direction(pos, obj_pos)
            local velocity = vector.multiply(direction, (power or 0) * 0.2)
            obj:set_velocity(velocity)
        end
    end
    return #objects
end

return {
    explode = explode,
    apply_shockwave = apply_shockwave,
}
