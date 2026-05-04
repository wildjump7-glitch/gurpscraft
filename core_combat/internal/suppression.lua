-- core_combat/internal/suppression.lua

local suppression_state = setmetatable({}, { __mode = "k" })

local function apply_suppression(target, intensity)
    if target == nil then
        return 0
    end
    local current = suppression_state[target] or 0
    local next_value = math.max(0, current + (intensity or 0))
    suppression_state[target] = next_value
    return next_value
end

local function get_suppression(target)
    if target == nil then
        return 0
    end
    return suppression_state[target] or 0
end

return {
    apply_suppression = apply_suppression,
    get_suppression = get_suppression,
}