-- core_destruction/internal/materials.lua

local function get_material(node_name)
    local state = core_destruction and core_destruction._state or nil
    if not state then
        return nil
    end
    return state.materials[node_name]
end

local function register_material(id, def)
    local state = core_destruction and core_destruction._state or nil
    if not state then
        return
    end
    state.materials[id] = def
end

return {
    get_material = get_material,
    register_material = register_material,
}