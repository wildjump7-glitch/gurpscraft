-- core_destruction/debug/penetration_test.lua

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    minetest.register_chatcommand("destruction_penetration_test", {
        description = "Run a penetration calculation at player position.",
        func = function(name)
            local player = minetest.get_player_by_name(name)
            if not player then
                return false, "Player not found."
            end
            local pos = vector.round(player:get_pos())
            local result = core_destruction.penetrate(pos, { x = 0, y = 0, z = 1 }, 10)
            return true, "Remaining power: " .. tostring(result.remaining_power)
        end,
    })
end
