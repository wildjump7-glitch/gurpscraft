-- core_ui/data/hud_layout.lua
-- HUD element layout and positioning definitions

return {
    health_bar = {
        id = 'health_bar',
        name = 'Health Bar',
        position = { x = 0.05, y = 0.9 },
        size = { width = 0.2, height = 0.03 },
        show = true,
    },
    stamina_bar = {
        id = 'stamina_bar',
        name = 'Stamina Bar',
        position = { x = 0.05, y = 0.87 },
        size = { width = 0.2, height = 0.03 },
        show = true,
    },
    mana_bar = {
        id = 'mana_bar',
        name = 'Mana Bar',
        position = { x = 0.05, y = 0.84 },
        size = { width = 0.2, height = 0.03 },
        show = true,
    },
    minimap = {
        id = 'minimap',
        name = 'Minimap',
        position = { x = 0.8, y = 0.8 },
        size = { width = 0.18, height = 0.18 },
        show = true,
    },
    status_effects = {
        id = 'status_effects',
        name = 'Status Effects',
        position = { x = 0.05, y = 0.7 },
        size = { width = 0.15, height = 0.1 },
        show = true,
    },
    compass = {
        id = 'compass',
        name = 'Compass',
        position = { x = 0.5, y = 0.05 },
        size = { width = 0.1, height = 0.05 },
        show = false,
    },
    crosshair = {
        id = 'crosshair',
        name = 'Crosshair',
        position = { x = 0.5, y = 0.5 },
        size = { width = 0.02, height = 0.02 },
        show = true,
    },
}
