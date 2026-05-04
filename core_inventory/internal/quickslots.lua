-- core_inventory/internal/quickslots.lua

local can_quickslot

local function get_quickslots(actor)
    actor.quickslots = actor.quickslots or {}
    return actor.quickslots
end

local function set_quickslot(actor, index, itemstack)
    if not can_quickslot(actor, itemstack) then
        return false
    end
    if not actor.quickslots then
        actor.quickslots = {}
    end
    actor.quickslots[index] = itemstack
    return true
end

local function clear_quickslot(actor, index)
    if actor.quickslots then
        actor.quickslots[index] = nil
    end
end

can_quickslot = function(actor, itemstack)
    if type(itemstack) ~= "table" or not itemstack.name then
        return false
    end
    local item = core_items.get(itemstack.name)
    if not item then
        return false
    end
    local count = itemstack.count or 1
    if item.stack_max and count > item.stack_max then
        return false
    end
    return true
end

return {
    get_quickslots = get_quickslots,
    set_quickslot = set_quickslot,
    clear_quickslot = clear_quickslot,
    can_quickslot = can_quickslot,
}