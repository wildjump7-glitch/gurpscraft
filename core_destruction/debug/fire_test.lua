-- core_destruction/debug/fire_test.lua

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    minetest.register_chatcommand("destruction_fire_test", {
        description = "Toggle fire at player position.",
        func = function(name)
            local player = minetest.get_player_by_name(name)
            if not player then
                return false, "Player not found."
            end
            local pos = vector.round(player:get_pos())
            if not core_destruction.extinguish(pos) then
                core_destruction.ignite(pos)
            end
            return true, "Fire test executed."
        end,
    })
end
