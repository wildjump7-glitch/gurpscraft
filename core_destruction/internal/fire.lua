-- core_destruction/internal/fire.lua

local function ignite(pos)
    local node = minetest.get_node(pos)
    if node and node.name ~= "air" then
        minetest.set_node(pos, { name = "fire:basic_flame" })
        return true
    end
    return false
end

local function extinguish(pos)
    local node = minetest.get_node(pos)
    if node and node.name == "fire:basic_flame" then
        minetest.remove_node(pos)
        return true
    end
    return false
end

return {
    ignite = ignite,
    extinguish = extinguish,
}
