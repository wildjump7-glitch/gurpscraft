-- tests/core_vehicles_api_test.lua

local minetest = minetest or {
    get_modpath = function(_)
        return "../core_vehicles"
    end,
    get_current_modname = function()
        return "core_vehicles"
    end,
    settings = {
        get_bool = function()
            return false
        end,
    },
}

local api = dofile("../core_vehicles/init.lua")
assert(type(api) == "table")
assert(type(api.register) == "function")
assert(type(api.get) == "function")
assert(type(api.all) == "function")
assert(type(api.spawn) == "function")
assert(type(api.despawn) == "function")
assert(type(api.is_vehicle) == "function")
assert(type(api.enter) == "function")
assert(type(api.exit) == "function")
assert(type(api.switch_seat) == "function")
assert(type(api.get_seat_role) == "function")
assert(type(api.set_throttle) == "function")
assert(type(api.set_steering) == "function")
assert(type(api.apply_physics) == "function")
assert(type(api.get_speed) == "function")
assert(type(api.apply_damage) == "function")
assert(type(api.get_health) == "function")
assert(type(api.get_fuel) == "function")
assert(type(api.add_fuel) == "function")
assert(type(api.consume_fuel) == "function")
assert(type(api.get_cargo) == "function")
assert(type(api.add_cargo) == "function")
assert(type(api.remove_cargo) == "function")
assert(type(api.ai_drive) == "function")
assert(type(api.ai_flee) == "function")
assert(type(api.ai_patrol) == "function")

local vehicle_def = api.get("cart")
assert(type(vehicle_def) == "table")
assert(vehicle_def.id == "cart")
assert(api.register("test_vehicle", { id = "test_vehicle", name = "Test Vehicle", speed = 1 }))
assert(api.get("test_vehicle") ~= nil)
assert(type(api.all()) == "table")

local spawned = api.spawn("test_vehicle", { x = 10, y = 0, z = 5 })
assert(type(spawned) == "table")
assert(spawned.definition_id == "test_vehicle")
assert(api.is_vehicle(spawned))
assert(api.set_throttle(spawned, 0.5))
assert(api.set_steering(spawned, 0.2))
assert(api.apply_physics(spawned, 0.1))
assert(type(api.get_speed(spawned)) == "number")
assert(api.add_fuel(spawned, 10))
assert(api.get_fuel(spawned) == 10)
assert(api.consume_fuel(spawned, 5))
assert(api.get_fuel(spawned) == 5)
assert(api.add_cargo(spawned, { name = "crate" }))
assert(type(api.get_cargo(spawned)) == "table")
assert(api.apply_damage(spawned, 5))
assert(api.get_health(spawned) == spawned.health)
assert(api.despawn(spawned))

return {
    module = "core_vehicles",
    has_api = type(api) == "table",
    checks = {
        register = true,
        get = true,
        all = true,
        spawn = true,
        despawn = true,
    },
}
