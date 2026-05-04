-- core_destruction/debug/explosion_test.lua

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    minetest.register_chatcommand("destruction_explosion_test", {
        description = "Apply explosion damage at player position.",
        func = function(name)
            local player = minetest.get_player_by_name(name)
            if not player then
                return false, "Player not found."
            end
            local pos = vector.round(player:get_pos())
            core_destruction.explode(pos, 25, {})
            return true, "Explosion test executed."
        end,
    })
end
