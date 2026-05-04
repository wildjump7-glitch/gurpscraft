-- core_items/internal/registry.lua

local items = {}

local function normalize_definition(def)
    if type(def) ~= "table" then
        return nil
    end

    local normalized = core_foundation.util.deepcopy(def)
    normalized.type = type(normalized.type) == "string" and normalized.type or "misc"
    normalized.tags = type(normalized.tags) == "table" and normalized.tags or {}
    normalized.effects = type(normalized.effects) == "table" and normalized.effects or {}
    normalized.attachment_slots = type(normalized.attachment_slots) == "table" and normalized.attachment_slots or {}
    normalized.compatible_attachments = type(normalized.compatible_attachments) == "table" and normalized.compatible_attachments or {}
    normalized.weight = type(normalized.weight) == "number" and normalized.weight or 1.0
    normalized.durability = type(normalized.durability) == "number" and normalized.durability or nil
    normalized.stack_max = type(normalized.stack_max) == "number" and normalized.stack_max or 99
    normalized.value = type(normalized.value) == "number" and normalized.value or 0
    normalized.rarity = type(normalized.rarity) == "string" and normalized.rarity or "common"

    return normalized
end

local function register(id, def)
    if type(id) ~= "string" or id == "" then
        core_foundation.log.warn("Rejected item with invalid id", "core_items")
        return false
    end
    if type(def) ~= "table" then
        core_foundation.log.warn("Rejected item '" .. id .. "' with invalid definition", "core_items")
        return false
    end
    if items[id] then
        core_foundation.log.warn("Item " .. id .. " already registered", "core_items")
        return false
    end

    local normalized = normalize_definition(def)
    if not normalized then
        core_foundation.log.warn("Failed to normalize item definition for " .. id, "core_items")
        return false
    end

    items[id] = normalized
    return true
end

local function get(id)
    if items[id] == nil then
        return nil
    end
    return core_foundation.util.deepcopy(items[id])
end

local function all()
    return core_foundation.util.deepcopy(items)
end

local function exists(id)
    return items[id] ~= nil
end

return {
    register = register,
    get = get,
    all = all,
    exists = exists,
}