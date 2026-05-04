-- core_ui/internal/overlays.lua
-- Contextual overlay system for status indicators and effects

local overlay_state = {
    active = {},
    bars = {},
    overlays = {},
}

local function show_overlay(name, params)
    if type(name) ~= "string" or name == "" then
        return false
    end
    overlay_state.active[name] = params or true
    overlay_state.overlays[name] = {
        shown_at = os.time(),
        params = params,
    }
    return true
end

local function hide_overlay(name)
    if type(name) ~= "string" or name == "" then
        return false
    end
    overlay_state.active[name] = nil
    overlay_state.overlays[name] = nil
    return true
end

local function is_overlay_visible(name)
    if type(name) ~= "string" or name == "" then
        return false
    end
    return overlay_state.active[name] ~= nil
end

local function flash_overlay(name, duration)
    if type(name) ~= "string" or name == "" then
        return false
    end
    show_overlay(name)
    if type(duration) == "number" and minetest.after then
        minetest.after(duration or 0.5, function()
            hide_overlay(name)
        end)
    end
    return true
end

local function create_bar(name, params)
    if type(name) ~= "string" or name == "" or type(params) ~= "table" then
        return false
    end
    overlay_state.bars[name] = {
        value = params.value or 0,
        max = params.max or 100,
        label = params.label or name,
        color = params.color or "#FFFFFF",
    }
    return true
end

local function update_bar(name, value)
    if type(name) ~= "string" or not overlay_state.bars[name] then
        return false
    end
    if type(value) == "number" then
        overlay_state.bars[name].value = value
    end
    overlay_state.bars[name].updated_at = os.time()
    return true
end

local function get_bar(name)
    if type(name) ~= "string" then
        return nil
    end
    return overlay_state.bars[name]
end

local function remove_bar(name)
    if type(name) ~= "string" or name == "" then
        return false
    end
    overlay_state.bars[name] = nil
    return true
end

local function get_all_bars()
    local result = {}
    for name, bar in pairs(overlay_state.bars) do
        result[name] = bar
    end
    return result
end

return {
    show_overlay = show_overlay,
    hide_overlay = hide_overlay,
    is_overlay_visible = is_overlay_visible,
    flash_overlay = flash_overlay,
    create_bar = create_bar,
    update_bar = update_bar,
    get_bar = get_bar,
    remove_bar = remove_bar,
    get_all_bars = get_all_bars,
}
    overlay_state.bars[name].value = value or overlay_state.bars[name].value
    return true
end

local function remove_bar(name)
    if type(name) ~= "string" or name == "" then
        return false
    end
    overlay_state.bars[name] = nil
    return true
end

return {
    show_overlay = show_overlay,
    hide_overlay = hide_overlay,
    flash_overlay = flash_overlay,
    create_bar = create_bar,
    update_bar = update_bar,
    remove_bar = remove_bar,
}
