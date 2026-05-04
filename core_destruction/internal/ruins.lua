-- core_destruction/internal/ruins.lua

local function save_ruin(pos, data)
    local key = minetest.pos_to_string(pos)
    core_destruction._state.ruins[key] = data
    return true
end

local function load_ruin(pos)
    local key = minetest.pos_to_string(pos)
    return core_destruction._state.ruins[key]
end

local function clear_ruin(pos)
    local key = minetest.pos_to_string(pos)
    core_destruction._state.ruins[key] = nil
    return true
end

return {
    save_ruin = save_ruin,
    load_ruin = load_ruin,
    clear_ruin = clear_ruin,
}
