-- core_destruction/debug/collapse_test.lua

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    minetest.register_chatcommand("destruction_collapse_test", {
        description = "Trigger a local collapse simulation.",
        func = function(name)
            local player = minetest.get_player_by_name(name)
            if not player then
                return false, "Player not found."
            end
            local pos = vector.round(player:get_pos())
            core_destruction.trigger_collapse(pos, 2)
            return true, "Collapse simulation triggered."
        end,
    })
end
