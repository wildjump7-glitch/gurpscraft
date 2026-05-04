-- core_destruction/debug/siege_test.lua

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    minetest.register_chatcommand("destruction_siege_test", {
        description = "Apply siege damage at player position.",
        func = function(name)
            local player = minetest.get_player_by_name(name)
            if not player then
                return false, "Player not found."
            end
            local pos = vector.round(player:get_pos())
            core_destruction.apply_siege_damage(pos, 20)
            return true, "Siege test executed."
        end,
    })
end
