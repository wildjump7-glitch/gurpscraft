-- core_items/internal/item_tags.lua

local function has_tag(id, tag)
    local item = core_items.get(id)
    if item and item.tags then
        for _, t in ipairs(item.tags) do
            if t == tag then
                return true
            end
        end
    end
    return false
end

local function get_by_tag(tag)
    local list = {}
    for id, _ in pairs(core_items.all()) do
        if has_tag(id, tag) then
            table.insert(list, id)
        end
    end
    table.sort(list)
    return list
end

local function get_tags(id)
    local item = core_items.get(id)
    if not item or not item.tags then
        return {}
    end
    return core_foundation.util.deepcopy(item.tags)
end

return {
    has_tag = has_tag,
    get_by_tag = get_by_tag,
    get_tags = get_tags,
}