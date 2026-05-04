-- core_physics/debug/physics_overlay.lua

local function show_overlay()
    return {
        base_speed = (core_physics.movement_modifiers and core_physics.movement_modifiers.base_speed) or 0,
        stamina_max = (core_physics.stamina and core_physics.stamina.max) or 0,
        gravity = (core_physics.gravity and core_physics.gravity.default) or 1.0,
    }
end

return {
    show_overlay = show_overlay,
}