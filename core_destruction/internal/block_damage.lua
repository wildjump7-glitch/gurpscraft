-- core_destruction/internal/block_damage.lua

local DAMAGE_MULTIPLIERS = {
    explosive = 1.5,
    siege = 2.0,
    kaiju = 3.0,
    corrosion = 0.75,
    collapse = 2.0,
}

local function clamp_damage(amount)
    return math.max(0, amount or 0)
end

local function damage_multiplier(damage_type)
    return DAMAGE_MULTIPLIERS[damage_type] or 1.0
end

local function break_block(pos, context)
    local _ = context
    minetest.remove_node(pos)
end

local function apply_damage(pos, amount, damage_type)
    local key = minetest.pos_to_string(pos)
    local state = core_destruction._state
    local current = state.block_hp[key] or 100
    local modifier = damage_multiplier(damage_type)
    local next_value = math.max(0, current - clamp_damage(amount) * modifier)
    state.block_hp[key] = next_value
    if next_value <= 0 then
        break_block(pos, { damage_type = damage_type })
    end
    return next_value
end

local function get_block_hp(pos)
    local key = minetest.pos_to_string(pos)
    return core_destruction._state.block_hp[key] or 100
end

local function set_block_hp(pos, value)
    local key = minetest.pos_to_string(pos)
    core_destruction._state.block_hp[key] = math.max(0, value or 0)
end

return {
    apply_damage = apply_damage,
    get_block_hp = get_block_hp,
    set_block_hp = set_block_hp,
    break_block = break_block,
}
