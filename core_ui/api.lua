-- core_ui/api.lua
-- Public API for user interface management, HUD elements, status effects, and notifications.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local ui = {}
ui.data = {}

local state = {
    registry = {},
    actor_state = {},
}

ui._state = state

ui.hud = dofile(modpath .. "/internal/hud.lua")
ui.status_effects = dofile(modpath .. "/internal/status_effects.lua")
ui.notifications = dofile(modpath .. "/internal/notifications.lua")
ui.icons = dofile(modpath .. "/internal/icons.lua")
ui.overlays = dofile(modpath .. "/internal/overlays.lua")

--- Initializes the HUD for a player.
-- @param player ObjectRef: The player to initialize HUD for
-- @return boolean: True if initialization successful
function ui.init_hud(player)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    if state.registry and state.registry["init_hud"] then
        return state.registry["init_hud"](player)
    end
    return false
end

--- Updates the HUD for a player.
-- @param player ObjectRef: The player to update HUD for
-- @return boolean: True if update successful
function ui.update_hud(player)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    if state.registry and state.registry["update_hud"] then
        return state.registry["update_hud"](player)
    end
    return false
end

--- Clears all HUD elements for a player.
-- @param player ObjectRef: The player to clear HUD for
-- @return boolean: True if clearing successful
function ui.clear_hud(player)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    if state.registry and state.registry["clear_hud"] then
        return state.registry["clear_hud"](player)
    end
    return false
end

--- Sets a specific HUD element for a player.
-- @param player ObjectRef: The player to set HUD element for
-- @param element_id string: Unique identifier for the HUD element
-- @param element_data table: HUD element configuration (type, position, text, etc.)
-- @return boolean: True if setting successful
function ui.set_hud_element(player, element_id, element_data)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    assert(type(element_id) == "string", "element_id must be a string")
    assert(type(element_data) == "table", "element_data must be a table")
    if state.registry and state.registry["set_hud_element"] then
        return state.registry["set_hud_element"](player, element_id, element_data)
    end
    return false
end

--- Gets a specific HUD element for a player.
-- @param player ObjectRef: The player to get HUD element for
-- @param element_id string: Unique identifier for the HUD element
-- @return table|nil: HUD element data if found, nil otherwise
function ui.get_hud_element(player, element_id)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    assert(type(element_id) == "string", "element_id must be a string")
    if state.registry and state.registry["get_hud_element"] then
        return state.registry["get_hud_element"](player, element_id)
    end
    return nil
end

--- Adds a status effect icon to a player's HUD.
-- @param player ObjectRef: The player to add status effect for
-- @param effect_id string: Unique identifier for the status effect
-- @param effect_data table: Status effect configuration (icon, duration, description, etc.)
-- @return boolean: True if addition successful
function ui.add_status_effect(player, effect_id, effect_data)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    assert(type(effect_id) == "string", "effect_id must be a string")
    assert(type(effect_data) == "table", "effect_data must be a table")
    if state.registry and state.registry["add_status_effect"] then
        return state.registry["add_status_effect"](player, effect_id, effect_data)
    end
    return false
end

--- Removes a status effect icon from a player's HUD.
-- @param player ObjectRef: The player to remove status effect from
-- @param effect_id string: Unique identifier for the status effect
-- @return boolean: True if removal successful
function ui.remove_status_effect(player, effect_id)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    assert(type(effect_id) == "string", "effect_id must be a string")
    if state.registry and state.registry["remove_status_effect"] then
        return state.registry["remove_status_effect"](player, effect_id)
    end
    return false
end

--- Updates all status effect icons for a player.
-- @param player ObjectRef: The player to update status effects for
-- @return boolean: True if update successful
function ui.update_status_effects(player)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    if state.registry and state.registry["update_status_effects"] then
        return state.registry["update_status_effects"](player)
    end
    return false
end

--- Shows a notification to a player.
-- @param player ObjectRef: The player to notify
-- @param message string: The notification message
-- @param type string: Notification type ("info", "warning", "error", "success")
-- @param duration number: How long to show the notification in seconds (optional)
-- @return boolean: True if notification shown successfully
function ui.notify(player, message, type, duration)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    assert(type(message) == "string", "message must be a string")
    assert(type(type) == "string", "type must be a string")
    if duration then assert(type(duration) == "number", "duration must be a number") end
    if state.registry and state.registry["notify"] then
        return state.registry["notify"](player, message, type, duration)
    end
    return false
end

--- Shows a notification with an icon to a player.
-- @param player ObjectRef: The player to notify
-- @param icon_id string: The icon identifier to display
-- @param message string: The notification message
-- @param type string: Notification type ("info", "warning", "error", "success")
-- @param duration number: How long to show the notification in seconds (optional)
-- @return boolean: True if notification shown successfully
function ui.notify_icon(player, icon_id, message, type, duration)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    assert(type(icon_id) == "string", "icon_id must be a string")
    assert(type(message) == "string", "message must be a string")
    assert(type(type) == "string", "type must be a string")
    if duration then assert(type(duration) == "number", "duration must be a number") end
    if state.registry and state.registry["notify_icon"] then
        return state.registry["notify_icon"](player, icon_id, message, type, duration)
    end
    return false
end

--- Clears all notifications for a player.
-- @param player ObjectRef: The player to clear notifications for
-- @return boolean: True if clearing successful
function ui.clear_notifications(player)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    if state.registry and state.registry["clear_notifications"] then
        return state.registry["clear_notifications"](player)
    end
    return false
end

--- Registers a new icon in the icon registry.
-- @param icon_id string: Unique identifier for the icon
-- @param icon_data table: Icon configuration (texture, size, description, etc.)
-- @return boolean: True if registration successful
function ui.register_icon(icon_id, icon_data)
    assert(type(icon_id) == "string", "icon_id must be a string")
    assert(type(icon_data) == "table", "icon_data must be a table")
    if state.registry and state.registry["register_icon"] then
        return state.registry["register_icon"](icon_id, icon_data)
    end
    return false
end

--- Gets icon data by ID.
-- @param icon_id string: The icon identifier to look up
-- @return table|nil: Icon data table if found, nil otherwise
function ui.get_icon(icon_id)
    assert(type(icon_id) == "string", "icon_id must be a string")
    if state.registry and state.registry["get_icon"] then
        return state.registry["get_icon"](icon_id)
    end
    return nil
end

--- Gets the texture path for an icon.
-- @param icon_id string: The icon identifier
-- @return string|nil: Texture path if icon exists, nil otherwise
function ui.get_icon_texture(icon_id)
    assert(type(icon_id) == "string", "icon_id must be a string")
    if state.registry and state.registry["get_icon_texture"] then
        return state.registry["get_icon_texture"](icon_id)
    end
    return nil
end

--- Shows an overlay screen to a player.
-- @param player ObjectRef: The player to show overlay to
-- @param overlay_id string: Unique identifier for the overlay
-- @param overlay_data table: Overlay configuration (type, content, buttons, etc.)
-- @return boolean: True if overlay shown successfully
function ui.show_overlay(player, overlay_id, overlay_data)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    assert(type(overlay_id) == "string", "overlay_id must be a string")
    assert(type(overlay_data) == "table", "overlay_data must be a table")
    if state.registry and state.registry["show_overlay"] then
        return state.registry["show_overlay"](player, overlay_id, overlay_data)
    end
    return false
end

--- Hides an overlay screen from a player.
-- @param player ObjectRef: The player to hide overlay from
-- @param overlay_id string: Unique identifier for the overlay
-- @return boolean: True if overlay hidden successfully
function ui.hide_overlay(player, overlay_id)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    assert(type(overlay_id) == "string", "overlay_id must be a string")
    if state.registry and state.registry["hide_overlay"] then
        return state.registry["hide_overlay"](player, overlay_id)
    end
    return false
end

--- Flashes an overlay screen briefly to a player.
-- @param player ObjectRef: The player to flash overlay to
-- @param overlay_id string: Unique identifier for the overlay
-- @param duration number: How long to flash in seconds (default 0.5)
-- @return boolean: True if flash successful
function ui.flash_overlay(player, overlay_id, duration)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    assert(type(overlay_id) == "string", "overlay_id must be a string")
    if duration then assert(type(duration) == "number", "duration must be a number") end
    if state.registry and state.registry["flash_overlay"] then
        return state.registry["flash_overlay"](player, overlay_id, duration)
    end
    return false
end

--- Creates a progress bar HUD element for a player.
-- @param player ObjectRef: The player to create bar for
-- @param bar_id string: Unique identifier for the bar
-- @param bar_data table: Bar configuration (position, size, colors, max_value, etc.)
-- @return boolean: True if bar created successfully
function ui.create_bar(player, bar_id, bar_data)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    assert(type(bar_id) == "string", "bar_id must be a string")
    assert(type(bar_data) == "table", "bar_data must be a table")
    if state.registry and state.registry["create_bar"] then
        return state.registry["create_bar"](player, bar_id, bar_data)
    end
    return false
end

--- Updates a progress bar HUD element for a player.
-- @param player ObjectRef: The player to update bar for
-- @param bar_id string: Unique identifier for the bar
-- @param value number: New value for the bar
-- @param max_value number: Maximum value for the bar (optional)
-- @return boolean: True if bar updated successfully
function ui.update_bar(player, bar_id, value, max_value)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    assert(type(bar_id) == "string", "bar_id must be a string")
    assert(type(value) == "number", "value must be a number")
    if max_value then assert(type(max_value) == "number", "max_value must be a number") end
    if state.registry and state.registry["update_bar"] then
        return state.registry["update_bar"](player, bar_id, value, max_value)
    end
    return false
end

--- Removes a progress bar HUD element from a player.
-- @param player ObjectRef: The player to remove bar from
-- @param bar_id string: Unique identifier for the bar
-- @return boolean: True if bar removed successfully
function ui.remove_bar(player, bar_id)
    assert(player and player:is_player(), "player must be a valid player ObjectRef")
    assert(type(bar_id) == "string", "bar_id must be a string")
    if state.registry and state.registry["remove_bar"] then
        return state.registry["remove_bar"](player, bar_id)
    end
    return false
end

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    ui.ui_test = dofile(modpath .. "/debug/ui_test.lua")
end

return ui
