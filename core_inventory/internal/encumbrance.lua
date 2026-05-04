-- core_inventory/internal/encumbrance.lua

local function get_encumbrance_level(actor)
    local total_weight = core_inventory.get_total_weight(actor)
    local max_weight = core_stats.get_derived(actor, "Carry_Weight") or 10
    local ratio = total_weight / max_weight
    if ratio < core_inventory.encumbrance_thresholds.light then
        return "none"
    elseif ratio < core_inventory.encumbrance_thresholds.medium then
        return "light"
    elseif ratio < core_inventory.encumbrance_thresholds.heavy then
        return "medium"
    elseif ratio < core_inventory.encumbrance_thresholds.max then
        return "heavy"
    end
    return "overloaded"
end

local function get_encumbrance_penalty(actor)
    local level = get_encumbrance_level(actor)
    if level == "light" then
        return 0.1
    elseif level == "medium" then
        return 0.2
    elseif level == "heavy" then
        return 0.3
    elseif level == "overloaded" then
        return 0.5
    end
    return 0
end

return {
    get_encumbrance_level = get_encumbrance_level,
    get_encumbrance_penalty = get_encumbrance_penalty,
}