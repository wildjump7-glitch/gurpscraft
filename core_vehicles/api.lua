-- core_vehicles/api.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local vehicles = {}
vehicles.data = {}

local state = {
    registry = {},
    actor_state = {},
}

vehicles._state = state

vehicles.registry = dofile(modpath .. "/internal/registry.lua")
vehicles.physics = dofile(modpath .. "/internal/physics.lua")
vehicles.damage = dofile(modpath .. "/internal/damage.lua")
vehicles.fuel = dofile(modpath .. "/internal/fuel.lua")
vehicles.seats = dofile(modpath .. "/internal/seats.lua")
vehicles.cargo = dofile(modpath .. "/internal/cargo.lua")
vehicles.ai = dofile(modpath .. "/internal/ai.lua")

--- Public API: register.
function vehicles.register(...)
    if state.registry and state.registry["register"] then
        return state.registry["register"](...)
    end
    return nil
end

--- Public API: get.
function vehicles.get(...)
    if state.registry and state.registry["get"] then
        return state.registry["get"](...)
    end
    return nil
end

--- Public API: all.
function vehicles.all(...)
    if state.registry and state.registry["all"] then
        return state.registry["all"](...)
    end
    return nil
end

--- Public API: spawn.
function vehicles.spawn(...)
    if state.registry and state.registry["spawn"] then
        return state.registry["spawn"](...)
    end
    return nil
end

--- Public API: despawn.
function vehicles.despawn(...)
    if state.registry and state.registry["despawn"] then
        return state.registry["despawn"](...)
    end
    return nil
end

--- Public API: is_vehicle.
function vehicles.is_vehicle(...)
    if state.registry and state.registry["is_vehicle"] then
        return state.registry["is_vehicle"](...)
    end
    return nil
end

--- Public API: enter.
function vehicles.enter(...)
    if state.registry and state.registry["enter"] then
        return state.registry["enter"](...)
    end
    return nil
end

--- Public API: exit.
function vehicles.exit(...)
    if state.registry and state.registry["exit"] then
        return state.registry["exit"](...)
    end
    return nil
end

--- Public API: switch_seat.
function vehicles.switch_seat(...)
    if state.registry and state.registry["switch_seat"] then
        return state.registry["switch_seat"](...)
    end
    return nil
end

--- Public API: get_seat_role.
function vehicles.get_seat_role(...)
    if state.registry and state.registry["get_seat_role"] then
        return state.registry["get_seat_role"](...)
    end
    return nil
end

--- Public API: set_throttle.
function vehicles.set_throttle(...)
    if state.registry and state.registry["set_throttle"] then
        return state.registry["set_throttle"](...)
    end
    return nil
end

--- Public API: set_steering.
function vehicles.set_steering(...)
    if state.registry and state.registry["set_steering"] then
        return state.registry["set_steering"](...)
    end
    return nil
end

--- Public API: apply_physics.
function vehicles.apply_physics(...)
    if state.registry and state.registry["apply_physics"] then
        return state.registry["apply_physics"](...)
    end
    return nil
end

--- Public API: get_speed.
function vehicles.get_speed(...)
    if state.registry and state.registry["get_speed"] then
        return state.registry["get_speed"](...)
    end
    return nil
end

--- Public API: apply_damage.
function vehicles.apply_damage(...)
    if state.registry and state.registry["apply_damage"] then
        return state.registry["apply_damage"](...)
    end
    return nil
end

--- Public API: get_health.
function vehicles.get_health(...)
    if state.registry and state.registry["get_health"] then
        return state.registry["get_health"](...)
    end
    return nil
end

--- Public API: set_health.
function vehicles.set_health(...)
    if state.registry and state.registry["set_health"] then
        return state.registry["set_health"](...)
    end
    return nil
end

--- Public API: damage_component.
function vehicles.damage_component(...)
    if state.registry and state.registry["damage_component"] then
        return state.registry["damage_component"](...)
    end
    return nil
end

--- Public API: get_fuel.
function vehicles.get_fuel(...)
    if state.registry and state.registry["get_fuel"] then
        return state.registry["get_fuel"](...)
    end
    return nil
end

--- Public API: add_fuel.
function vehicles.add_fuel(...)
    if state.registry and state.registry["add_fuel"] then
        return state.registry["add_fuel"](...)
    end
    return nil
end

--- Public API: consume_fuel.
function vehicles.consume_fuel(...)
    if state.registry and state.registry["consume_fuel"] then
        return state.registry["consume_fuel"](...)
    end
    return nil
end

--- Public API: is_out_of_fuel.
function vehicles.is_out_of_fuel(...)
    if state.registry and state.registry["is_out_of_fuel"] then
        return state.registry["is_out_of_fuel"](...)
    end
    return nil
end

--- Public API: get_cargo.
function vehicles.get_cargo(...)
    if state.registry and state.registry["get_cargo"] then
        return state.registry["get_cargo"](...)
    end
    return nil
end

--- Public API: add_cargo.
function vehicles.add_cargo(...)
    if state.registry and state.registry["add_cargo"] then
        return state.registry["add_cargo"](...)
    end
    return nil
end

--- Public API: remove_cargo.
function vehicles.remove_cargo(...)
    if state.registry and state.registry["remove_cargo"] then
        return state.registry["remove_cargo"](...)
    end
    return nil
end

--- Public API: ai_drive.
function vehicles.ai_drive(...)
    if state.registry and state.registry["ai_drive"] then
        return state.registry["ai_drive"](...)
    end
    return nil
end

--- Public API: ai_flee.
function vehicles.ai_flee(...)
    if state.registry and state.registry["ai_flee"] then
        return state.registry["ai_flee"](...)
    end
    return nil
end

--- Public API: ai_patrol.
function vehicles.ai_patrol(...)
    if state.registry and state.registry["ai_patrol"] then
        return state.registry["ai_patrol"](...)
    end
    return nil
end

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    vehicles.spawn_vehicle = dofile(modpath .. "/debug/spawn_vehicle.lua")
    vehicles.vehicle_inspector = dofile(modpath .. "/debug/vehicle_inspector.lua")
    vehicles.vehicle_physics_test = dofile(modpath .. "/debug/vehicle_physics_test.lua")
    vehicles.vehicle_ai_test = dofile(modpath .. "/debug/vehicle_ai_test.lua")
end

return vehicles
