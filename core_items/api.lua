-- core_items/api.lua
-- Public API for item registry, tags, effects, and crafting recipes.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local registry = dofile(modpath .. "/internal/registry.lua")
local item_tags = dofile(modpath .. "/internal/item_tags.lua")
local item_effects = dofile(modpath .. "/internal/item_effects.lua")

--[[
Get a specific recipe by ID.
Returns: recipe definition table or nil
]]
local function get_recipe(id)
    local crafting = core_items and core_items.crafting or {}
    return crafting[id]
end

--[[
Get all recipes that produce a specific output item.
output_id: string item ID
Returns: table of recipe definitions
]]
local function get_recipes_by_output(output_id)
    local recipes = {}
    for _, recipe in pairs(core_items.crafting or {}) do
        if recipe.output == output_id then
            table.insert(recipes, recipe)
        end
    end
    return recipes
end

--[[
Get all recipes tagged with a specific tag.
tag: string tag ID
Returns: table of recipe definitions
]]
local function get_recipes_by_tag(tag)
    local recipes = {}
    for _, recipe in pairs(core_items.crafting or {}) do
        if recipe.tags then
            for _, t in ipairs(recipe.tags) do
                if t == tag then
                    table.insert(recipes, recipe)
                    break
                end
            end
        end
    end
    return recipes
end

--[[
Get attachment slots available on an item.
item_id: string
Returns: table of slot names and max count
]]
local function get_attachment_slots(item_id)
    local item = core_items.get(item_id)
    return item and item.attachment_slots or {}
end

--[[
Get all attachments compatible with an item.
item_id: string
Returns: table of compatible attachment IDs
]]
local function get_compatible_attachments(item_id)
    local item = core_items.get(item_id)
    if not item or not item.compatible_attachments then return {} end
    local list = {}
    for _, att_id in ipairs(item.compatible_attachments) do
        local attachment = core_items.get(att_id)
        if attachment then
            table.insert(list, att_id)
        end
    end
    return list
end

--[[
Apply an attachment to an item.
item_id: base item ID
attachment_id: attachment ID to apply
Returns: modified item definition with attachment applied, or nil if incompatible
]]
local function apply_attachment(item_id, attachment_id)
    local item = core_items.get(item_id)
    local att = core_items.get(attachment_id)
    if not item or not att then
        return nil
    end
    local slots = item.attachment_slots or {}
    local slot = att.slot
    if slot and not slots[slot] then
        return nil
    end
    local merged = core_foundation.util.deepcopy(item)
    merged.applied_attachments = merged.applied_attachments or {}
    table.insert(merged.applied_attachments, attachment_id)
    return merged
end

return {
    -- Registry functions
    register = registry.register,
    get = registry.get,
    all = registry.all,
    exists = registry.exists,
    
    -- Tagging system
    has_tag = item_tags.has_tag,
    get_by_tag = item_tags.get_by_tag,
    get_tags = item_tags.get_tags,
    
    -- Effects
    apply_effects = item_effects.apply_effects,
    get_effects = item_effects.get_effects,
    
    -- Crafting recipes
    get_recipe = get_recipe,
    get_recipes_by_output = get_recipes_by_output,
    get_recipes_by_tag = get_recipes_by_tag,
    
    -- Attachments
    get_attachment_slots = get_attachment_slots,
    get_compatible_attachments = get_compatible_attachments,
    apply_attachment = apply_attachment,
}