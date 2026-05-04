-- tests/core_ui_api_test.lua

local api = dofile("../core_ui/init.lua")

-- Validate data loaded
assert(type(api.data.hud_layout) == "table", "hud_layout data not loaded")
assert(type(api.data.status_effect_icons) == "table", "status_effect_icons data not loaded")
assert(api.data.status_effect_icons.poisoned ~= nil, "poisoned effect not in data")

-- Test icon registration
assert(api.icons.register_icon("test_icon", "test.png"), "should register test icon")
assert(api.icons.get_icon("test_icon") == "test.png", "should retrieve test icon")
assert(not api.icons.register_icon("test_icon", "duplicate.png"), "should not re-register existing icon")

-- Test status effects
local mock_player = { is_player = function() return true end, get_player_name = function() return "test_player" end }
assert(api.status_effects.add_status_effect(mock_player, "poisoned", {duration = 10}), "should add status effect")
local effect = api.status_effects.get_status_effect(mock_player, "poisoned")
assert(effect ~= nil, "should retrieve status effect")
assert(effect.duration == 10, "effect duration should be 10")
assert(api.status_effects.update_status_effects(mock_player, 5), "should update effects")
effect = api.status_effects.get_status_effect(mock_player, "poisoned")
assert(effect.duration == 5, "effect duration should be reduced to 5")
assert(api.status_effects.remove_status_effect(mock_player, "poisoned"), "should remove status effect")
assert(api.status_effects.get_status_effect(mock_player, "poisoned") == nil, "effect should be gone")

-- Test overlays
assert(api.overlays.show_overlay("test_overlay"), "should show overlay")
assert(api.overlays.is_overlay_visible("test_overlay"), "overlay should be visible")
assert(api.overlays.hide_overlay("test_overlay"), "should hide overlay")
assert(not api.overlays.is_overlay_visible("test_overlay"), "overlay should not be visible")

-- Test bars
assert(api.overlays.create_bar("health", {value = 50, max = 100}), "should create bar")
local bar = api.overlays.get_bar("health")
assert(bar ~= nil, "should retrieve bar")
assert(bar.value == 50, "bar value should be 50")
assert(api.overlays.update_bar("health", 75), "should update bar")
bar = api.overlays.get_bar("health")
assert(bar.value == 75, "bar value should be 75")
assert(api.overlays.remove_bar("health"), "should remove bar")
assert(api.overlays.get_bar("health") == nil, "bar should be gone")

-- Test notifications (mocked)
assert(api.notifications.notify(mock_player, "test message") == true or false, "notify should execute without error")
assert(api.notifications.notify_icon(mock_player, "test message", "icon") == true or false, "notify_icon should execute without error")

return {
    module = "core_ui",
    has_api = type(api) == "table",
    data_loaded = api.data.hud_layout ~= nil and api.data.status_effect_icons ~= nil,
    icons_registered = api.icons.get_icon("poisoned") ~= nil,
}
