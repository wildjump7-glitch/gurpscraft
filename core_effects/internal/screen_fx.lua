-- core_effects/internal/screen_fx.lua

local function add_overlay(player, texture, duration, offset)
    if not player or not player:get_player_name() then
        return
    end
    local id = player:hud_add({
        hud_elem_type = "image",
        position = {x = 0.5, y = 0.5},
        offset = offset or {x = 0, y = 0},
        scale = {x = 2, y = 2},
        text = texture,
        alignment = {x = 0, y = 0},
        number = 0xFFFFFF,
    })
    minetest.after(duration or 0.2, function()
        player:hud_remove(id)
    end)
end

local function screen_shake(player, intensity, duration)
    if not player then
        return
    end
    add_overlay(player, "screen_shake_overlay.png", duration or 0.2)
end

local function screen_flash(player, color, duration)
    if not player then
        return
    end
    add_overlay(player, "screen_flash_overlay.png", duration or 0.15)
end

local function screen_overlay(player, texture, duration)
    if not player then
        return
    end
    add_overlay(player, texture or "", duration or 1.0)
end

local function hit_indicator(player, _direction)
    if not player then
        return
    end
    add_overlay(player, "hit_indicator_overlay.png", 0.2)
end

return {
    screen_shake = screen_shake,
    screen_flash = screen_flash,
    screen_overlay = screen_overlay,
    hit_indicator = hit_indicator,
}