-- core_destruction/internal/siege.lua

local function apply_siege_damage(pos, amount)
    return core_destruction.apply_damage(pos, amount, "siege")
end

local function create_breach(pos, radius)
    radius = math.max(1, radius or 2)
    for dx = -radius, radius do
        for dy = -1, 1 do
            for dz = -radius, radius do
                local target = {
                    x = pos.x + dx,
                    y = pos.y + dy,
                    z = pos.z + dz,
                }
                local node = minetest.get_node(target)
                if node and node.name ~= "air" and node.name ~= "ignore" then
                    core_destruction.apply_damage(target, 40, "siege")
                end
            end
        end
    end
    core_destruction.trigger_collapse(pos, radius)
    return true
end

local function undermine(pos, depth)
    depth = math.max(1, depth or 2)
    for d = 1, depth do
        local target = {
            x = pos.x,
            y = pos.y - d,
            z = pos.z,
        }
        core_destruction.apply_damage(target, 30, "siege")
    end
    return true
end

return {
    apply_siege_damage = apply_siege_damage,
    create_breach = create_breach,
    undermine = undermine,
}
