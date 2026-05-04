-- core_destruction/internal/penetration.lua

local function penetrate(origin, direction, power)
    local remaining_power = math.max(0, power or 0)
    local position = vector.new(origin)
    local step = vector.normalize(direction or { x = 0, y = 0, z = 0 })
    local trace = {}
    for _ = 1, 16 do
        position = vector.add(position, step)
        local node = minetest.get_node(position)
        if node and node.name ~= "air" and node.name ~= "ignore" then
            local cost = core_destruction.get_penetration_cost(node.name)
            remaining_power = remaining_power - cost
            table.insert(trace, {
                pos = vector.new(position),
                node = node.name,
                remaining = remaining_power,
            })
            if remaining_power <= 0 then
                break
            end
        end
    end
    return {
        origin = origin,
        remaining_power = remaining_power,
        trace = trace,
    }
end

local function get_penetration_cost(node_name)
    local material = core_destruction.get_material(node_name)
    if material and material.penetration then
        return material.penetration
    end
    return 1
end

return {
    penetrate = penetrate,
    get_penetration_cost = get_penetration_cost,
}
