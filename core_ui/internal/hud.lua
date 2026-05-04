-- core_ui/internal/hud.lua
-- HUD system for rendering health, stamina, mana, and other elements

local hud_state = {
    players = {},
}

local function ensure_player(player)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end
    if not player or not player:is_player() then
        return nil
    end
    local name = player:get_player_name()
    hud_state.players[name] = hud_state.players[name] or { elements = {}, ids = {} }
    return name, hud_state.players[name]
end

local function init_hud(player)
    local name, state = ensure_player(player)
    if not name then
        return false
    end
    for key, id in pairs(state.ids) do
        if id then
            player:hud_remove(id)
        end
    end
    state.elements = {}
    state.ids = {}
    return true
end

local function update_hud(player, data)
    local name, state = ensure_player(player)
    if not name or type(data) ~= "table" then
        return false
    end
    for key, value in pairs(data) do
        if state.ids[key] then
            player:hud_change(state.ids[key], "text", tostring(value))
            state.elements[key] = value
        else
            local id = player:hud_add({
                hud_elem_type = "text",
                position = { x = 0.5, y = 0.5 },
                offset = { x = 0, y = 0 },
                text = tostring(value),
                alignment = { x = 0, y = 0 },
                scale = { x = 100, y = 100 }
            })
            state.ids[key] = id
            state.elements[key] = value
        end
    end
    return true
end

local function clear_hud(player)
    local name, state = ensure_player(player)
    if not name then
        return false
    end
    for key, id in pairs(state.ids) do
        if id then
            player:hud_remove(id)
        end
    end
    state.elements = {}
    state.ids = {}
    return true
end

local function set_hud_element(player, element_id, element_data)
    if not (player and (type(player) == "string" or player:is_player())) then
        return false
    end
    if type(element_id) ~= "string" or type(element_data) ~= "table" then
        return false
    end
    local name, state = ensure_player(player)
    if not name then
        return false
    end
    if state.ids[element_id] then
        if element_data.text then
            player:hud_change(state.ids[element_id], "text", element_data.text)
        end
    else
        local hud_def = {
            hud_elem_type = element_data.type or "text",
            position = element_data.position or { x = 0.5, y = 0.5 },
            offset = element_data.offset or { x = 0, y = 0 },
            text = element_data.text or "",
            direction = element_data.direction or 0,
            alignment = element_data.alignment or { x = 0, y = 0 },
            scale = element_data.scale or { x = 100, y = 100 }
        }
        if element_data.type == "bar" then
            hud_def.number = element_data.value or 0
            hud_def.max = element_data.max or 100
            hud_def.item = element_data.item or 0
            hud_def.direction = element_data.direction or 0
        end
        local id = player:hud_add(hud_def)
        state.ids[element_id] = id
    end
    state.elements[element_id] = element_data
    return true
end

local function get_hud_element(player, element_id)
    if not (player and (type(player) == "string" or player:is_player())) then
        return nil
    end
    local name, state = ensure_player(player)
    if not name then
        return nil
    end
    return state.elements[element_id]
end

return {
    init_hud = init_hud,
    update_hud = update_hud,
    clear_hud = clear_hud,
    set_hud_element = set_hud_element,
    get_hud_element = get_hud_element,
}

local function clear_hud(player)
    local name, state = ensure_player(player)
    if not name then
        return false
    end
    for _, id in pairs(state.ids) do
        if id then
            player:hud_remove(id)
        end
    end
    state.elements = {}
    state.ids = {}
    return true
end

local function set_hud_element(player, key, value)
    return update_hud(player, { [key] = value })
end

local function get_hud_element(player, key)
    local name, state = ensure_player(player)
    if not name or not key then
        return nil
    end
    return state.elements[key]
end

return {
    init_hud = init_hud,
    update_hud = update_hud,
    clear_hud = clear_hud,
    set_hud_element = set_hud_element,
    get_hud_element = get_hud_element,
}
