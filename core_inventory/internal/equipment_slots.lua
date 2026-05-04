-- core_inventory/internal/equipment_slots.lua

local function get_slots(actor)
    return core_foundation.util.deepcopy(core_inventory.slots or {})
end

local function get_slot(actor, slot_id)
    return actor.equipment and actor.equipment[slot_id]
end

local function set_slot(actor, slot_id, itemstack)
    if not actor.equipment then
        actor.equipment = {}
    end

    local previous_item = actor.equipment[slot_id]
    if previous_item and previous_item.name then
        core_items.apply_effects(actor, previous_item.name, "unequip")
    end

    actor.equipment[slot_id] = itemstack
    if itemstack and itemstack.name then
        core_items.apply_effects(actor, itemstack.name, "equip")
    end
    core_stats.recalculate(actor)
    return true
end

local function clear_slot(actor, slot_id)
    local item = get_slot(actor, slot_id)
    if item and item.name then
        core_items.apply_effects(actor, item.name, "unequip")
    end
    if actor.equipment then actor.equipment[slot_id] = nil end
    core_stats.recalculate(actor)
    return true
end

local function is_valid_slot(slot_id)
    return (core_inventory.slots or {})[slot_id] ~= nil
end

local function equip(actor, itemstack, slot_id)
    if can_equip(actor, itemstack, slot_id) then
        set_slot(actor, slot_id, itemstack)
        return true
    end
    return false
end

local function unequip(actor, slot_id)
    clear_slot(actor, slot_id)
end

local function can_equip(actor, itemstack, slot_id)
    local slot_def = (core_inventory.slots or {})[slot_id]
    if not slot_def or type(itemstack) ~= "table" or not itemstack.name then
        return false
    end
    local item_def = core_items.get(itemstack.name)
    if not item_def then
        return false
    end
    if slot_def.type and item_def.type ~= slot_def.type then
        return false
    end
    if slot_def.tags then
        for _, tag in ipairs(slot_def.tags) do
            if not core_items.has_tag(itemstack.name, tag) then
                return false
            end
        end
    end
    return true
end

local function get_equipped(actor)
    return actor.equipment or {}
end

local function validate_item_for_slot(item_id, slot_id)
    local slot_def = core_inventory.slots[slot_id]
    if not slot_def then return false end
    local item_def = core_items.get(item_id)
    if not item_def then return false end
    if slot_def.type and item_def.type ~= slot_def.type then return false end
    if slot_def.tags then
        for _, tag in ipairs(slot_def.tags) do
            if not core_items.has_tag(item_id, tag) then return false end
        end
    end
    return true
end

local function validate_actor_equipment(actor)
    local ok = true
    for slot_id, itemstack in pairs(get_equipped(actor)) do
        if not can_equip(actor, itemstack, slot_id) then
            core_foundation.log.warn("Invalid equipment for actor: " .. slot_id)
            ok = false
        end
    end
    return ok
end

return {
    get_slots = get_slots,
    get_slot = get_slot,
    set_slot = set_slot,
    clear_slot = clear_slot,
    is_valid_slot = is_valid_slot,
    equip = equip,
    unequip = unequip,
    can_equip = can_equip,
    get_equipped = get_equipped,
    validate_item_for_slot = validate_item_for_slot,
    validate_actor_equipment = validate_actor_equipment,
}