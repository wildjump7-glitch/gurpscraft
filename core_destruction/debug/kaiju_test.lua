-- core_destruction/debug/kaiju_test.lua

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    minetest.register_chatcommand("destruction_kaiju_test", {
        description = "Apply kaiju impact at player position.",
        func = function(name)
            local player = minetest.get_player_by_name(name)
            if not player then
                return false, "Player not found."
            end
            local pos = vector.round(player:get_pos())
            core_destruction.apply_kaiju_impact(pos, 2000, 8)
            return true, "Kaiju test executed."
        end,
    })
end
