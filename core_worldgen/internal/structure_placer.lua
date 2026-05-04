-- core_worldgen/internal/structure_placer.lua

local structures = {}

local function register_structure(id, def)
    if type(id) ~= "string" or id == "" or type(def) ~= "table" then
        return false
    end
    structures[id] = def
    return true
end

local function get_structure(id)
    return structures[id]
end

local function place_structure(id, pos, rotation)
    local def = get_structure(id)
    if not def or type(pos) ~= "table" then
        return false
    end
    if type(pos.x) ~= "number" or type(pos.y) ~= "number" or type(pos.z) ~= "number" then
        return false
    end
    return true
end

return {
    register_structure = register_structure,
    get_structure = get_structure,
    place_structure = place_structure,
}
