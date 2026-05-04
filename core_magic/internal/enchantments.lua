-- core_magic/internal/enchantments.lua

local function apply_enchantment(item, enchantment_id, level)
    if type(item) ~= "table" or type(enchantment_id) ~= "string" or type(level) ~= "number" then
        return false
    end
    item.enchantments = item.enchantments or {}
    item.enchantments[enchantment_id] = level
    return item
end

local function remove_enchantment(item, enchantment_id)
    if type(item) ~= "table" or type(enchantment_id) ~= "string" then
        return false
    end
    if not item.enchantments then
        return false
    end
    if item.enchantments[enchantment_id] == nil then
        return false
    end
    item.enchantments[enchantment_id] = nil
    return item
end

local function get_enchantments(item)
    if type(item) ~= "table" then
        return {}
    end
    return item.enchantments or {}
end

return {
    apply_enchantment = apply_enchantment,
    remove_enchantment = remove_enchantment,
    get_enchantments = get_enchantments,
}
