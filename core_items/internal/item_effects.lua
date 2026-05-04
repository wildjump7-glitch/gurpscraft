-- core_items/internal/item_effects.lua

local function apply_effects(actor, item_id, context)
    local item = core_items.get(item_id)
    if item and item.effects and item.effects[context] then
        local effect_set = item.effects[context]
        if effect_set.stats and actor then
            for stat, mod in pairs(effect_set.stats) do
                core_stats.modify_attribute(actor, stat, mod or 0)
            end
        end
        if effect_set.heal and actor and type(actor) == "table" then
            actor.hp = (actor.hp or 0) + effect_set.heal
        end
        return true
    end
    return false
end

local function get_effects(item_id)
    local item = core_items.get(item_id)
    return item and item.effects or {}
end

return {
    apply_effects = apply_effects,
    get_effects = get_effects,
}