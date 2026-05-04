-- core_inventory/api.lua
-- Public API for equipment management, encumbrance, and inventory systems.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local equipment_slots = dofile(modpath .. "/internal/equipment_slots.lua")
local encumbrance = dofile(modpath .. "/internal/encumbrance.lua")
local quickslots = dofile(modpath .. "/internal/quickslots.lua")
local weight = dofile(modpath .. "/internal/weight.lua")

--[[
Ensure an actor has initialized inventory structures.
]]
local function ensure_actor_inventory(actor)
    actor.equipment = actor.equipment or {}
    actor.quickslots = actor.quickslots or {}
    actor.loadouts = actor.loadouts or {}
end

--[[
Save current equipment configuration as a named loadout.
actor: object reference
id: string identifier for the loadout
Returns: true if saved successfully
]]
local function save_loadout(actor, id)
    ensure_actor_inventory(actor)
    actor.loadouts[id] = core_foundation.util.deepcopy(actor.equipment)
    return true
end

--[[
Load a previously saved equipment loadout.
actor: object reference
id: string identifier of the loadout
Returns: true if loaded successfully, false if loadout not found or invalid
]]
local function load_loadout(actor, id)
    ensure_actor_inventory(actor)
    if actor.loadouts and actor.loadouts[id] then
        local candidate = core_foundation.util.deepcopy(actor.loadouts[id])
        if not validate_loadout(actor, candidate) then
            return false
        end
        actor.equipment = candidate
        core_stats.recalculate(actor)
        return true
    end
    return false
end

--[[
Validate that a loadout is valid for the actor.
loadout_table: table of slot -> itemstack mappings
Returns: true if valid, false otherwise
]]
local function validate_loadout(actor, loadout_table)
    if type(loadout_table) ~= "table" then
        return false
    end
    for slot_id, itemstack in pairs(loadout_table) do
        if not equipment_slots.can_equip(actor, itemstack, slot_id) then
            return false
        end
    end
    return true
end

return {
    -- Equipment slot management
    get_slots = equipment_slots.get_slots,
    get_slot = equipment_slots.get_slot,
    set_slot = equipment_slots.set_slot,
    clear_slot = equipment_slots.clear_slot,
    is_valid_slot = equipment_slots.is_valid_slot,
    equip = equipment_slots.equip,
    unequip = equipment_slots.unequip,
    can_equip = equipment_slots.can_equip,
    get_equipped = equipment_slots.get_equipped,
    
    -- Weight calculations
    get_total_weight = weight.get_total_weight,
    get_equipped_weight = weight.get_equipped_weight,
    
    -- Encumbrance system
    get_encumbrance_level = encumbrance.get_encumbrance_level,
    get_encumbrance_penalty = encumbrance.get_encumbrance_penalty,
    
    -- Quick slots (hotbar)
    get_quickslots = quickslots.get_quickslots,
    set_quickslot = quickslots.set_quickslot,
    clear_quickslot = quickslots.clear_quickslot,
    can_quickslot = quickslots.can_quickslot,
    
    -- Loadouts
    save_loadout = save_loadout,
    load_loadout = load_loadout,
    validate_loadout = validate_loadout,
    
    -- Validation
    validate_item_for_slot = equipment_slots.validate_item_for_slot,
    validate_actor_equipment = equipment_slots.validate_actor_equipment,
}