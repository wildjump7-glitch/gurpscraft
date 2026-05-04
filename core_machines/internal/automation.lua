-- core_machines/internal/automation.lua
-- Item I/O automation system: filters, sorting, conveying

local function push_items(instance_id, items)
    if type(instance_id) ~= "string" or type(items) ~= "table" then
        return false
    end
    -- Store items in a push buffer on the instance
    -- In a real implementation, would use core_inventory APIs
    return true
end

local function pull_items(instance_id, filter)
    if type(instance_id) ~= "string" then
        return false
    end
    if type(filter) ~= "table" and type(filter) ~= "nil" then
        return false
    end
    -- Pull items from adjacent inventories matching filter
    -- In a real implementation, would use core_inventory APIs
    return true
end

local function sort_items(instance_id)
    if type(instance_id) ~= "string" then
        return false
    end
    -- Sort items within the machine's inventory by some criteria
    return true
end

local function filter_items(items, filter_config)
    if type(items) ~= "table" or type(filter_config) ~= "table" then
        return {}
    end
    local filtered = {}
    for _, item in ipairs(items) do
        if type(filter_config.name) == "string" and item.name == filter_config.name then
            table.insert(filtered, item)
        elseif type(filter_config.tag) == "string" and item.tags and item.tags[filter_config.tag] then
            table.insert(filtered, item)
        end
    end
    return filtered
end

local function route_items(source_inv, dest_inv, items)
    if type(source_inv) ~= "table" or type(dest_inv) ~= "table" or type(items) ~= "table" then
        return false
    end
    -- Move items from source to destination inventory
    return true
end

return {
    push_items = push_items,
    pull_items = pull_items,
    sort_items = sort_items,
    filter_items = filter_items,
    route_items = route_items,
}
