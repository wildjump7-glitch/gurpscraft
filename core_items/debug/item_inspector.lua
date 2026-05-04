-- core_items/debug/item_inspector.lua

local function inspect_item(id)
    local item = core_items.get(id)
    if item then
        return true, minetest.serialize(item)
    else
        return false, "Item " .. tostring(id) .. " not found"
    end
end

return {
    inspect_item = inspect_item,
}