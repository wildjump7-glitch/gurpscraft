-- core_inventory/debug/inventory_viewer.lua

local function view_inventory(name, actor)
    local payload = {
        equipped = core_inventory.get_equipped(actor),
        quickslots = core_inventory.get_quickslots(actor),
        total_weight = core_inventory.get_total_weight(actor),
        equipped_weight = core_inventory.get_equipped_weight(actor),
        encumbrance = core_inventory.get_encumbrance_level(actor),
    }
    minetest.chat_send_player(name, minetest.serialize(payload))
    return true
end

return {
    view_inventory = view_inventory,
}