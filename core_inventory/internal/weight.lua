-- core_inventory/internal/weight.lua

local function get_item_weight(item_id)
    local item = core_items.get(item_id)
    return (item and item.weight) or 0
end

local function get_total_weight(actor)
    local total = 0
    for _, itemstack in pairs(core_inventory.get_equipped(actor)) do
        total = total + get_item_weight(itemstack.name) * (itemstack.count or 1)
    end
    for _, itemstack in pairs(core_inventory.get_quickslots(actor)) do
        total = total + get_item_weight(itemstack.name) * (itemstack.count or 1)
    end
    return total
end

local function get_equipped_weight(actor)
    local total = 0
    for _, itemstack in pairs(core_inventory.get_equipped(actor)) do
        total = total + get_item_weight(itemstack.name) * (itemstack.count or 1)
    end
    return total
end

return {
    get_total_weight = get_total_weight,
    get_equipped_weight = get_equipped_weight,
}