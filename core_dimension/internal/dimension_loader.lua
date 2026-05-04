-- core_dimension/internal/dimension_loader.lua

local dimensions = {}
local current_dimension = nil

local function register(id, def)
    if type(id) ~= "string" or id == "" or type(def) ~= "table" then
        return false
    end
    dimensions[id] = def
    return true
end

local function get(id)
    return dimensions[id]
end

local function all()
    local copy = {}
    for id, def in pairs(dimensions) do
        copy[id] = def
    end
    return copy
end

local function get_current()
    return current_dimension
end

local function set_current(id)
    if id == nil then
        current_dimension = nil
        return true
    end
    if dimensions[id] then
        current_dimension = id
        return true
    end
    return false
end

return {
    register = register,
    get = get,
    all = all,
    get_current = get_current,
    set_current = set_current,
}
