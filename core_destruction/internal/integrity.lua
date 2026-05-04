-- core_destruction/internal/integrity.lua

local function is_solid_node(node_name)
    if not node_name then
        return false
    end
    return node_name ~= "air" and node_name ~= "ignore" and node_name ~= "fire:basic_flame"
end

local function count_support(pos)
    local offsets = {
        { x = 0, y = -1, z = 0 },
        { x = 1, y = 0, z = 0 },
        { x = -1, y = 0, z = 0 },
        { x = 0, y = 0, z = 1 },
        { x = 0, y = 0, z = -1 },
    }
    local support = 0
    for _, offset in ipairs(offsets) do
        local check_pos = {
            x = pos.x + offset.x,
            y = pos.y + offset.y,
            z = pos.z + offset.z,
        }
        local node = minetest.get_node(check_pos)
        if is_solid_node(node.name) then
            support = support + 1
        end
    end
    return support
end

local function check_support(pos)
    return count_support(pos) >= 1
end

local function get_integrity(pos)
    local health = core_destruction.get_block_hp(pos)
    local support = count_support(pos)
    local ratio = math.min(1.0, math.max(0.0, health / 100))
    if support == 0 then
        ratio = ratio * 0.3
    elseif support == 1 then
        ratio = ratio * 0.7
    end
    return ratio
end

local function trigger_collapse(pos, radius)
    radius = math.max(1, radius or 1)
    for dx = -radius, radius do
        for dy = -radius, radius do
            for dz = -radius, radius do
                local target = {
                    x = pos.x + dx,
                    y = pos.y + dy,
                    z = pos.z + dz,
                }
                if not check_support(target) then
                    core_destruction.apply_damage(target, 50, "collapse")
                end
            end
        end
    end
    return true
end

local function update_integrity(pos)
    if not check_support(pos) then
        core_destruction.apply_damage(pos, 12, "collapse")
        return false
    end
    return true
end

return {
    check_support = check_support,
    get_integrity = get_integrity,
    trigger_collapse = trigger_collapse,
    update_integrity = update_integrity,
}
