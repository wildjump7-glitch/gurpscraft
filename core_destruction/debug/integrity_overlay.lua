-- core_destruction/debug/integrity_overlay.lua

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    minetest.register_chatcommand("destruction_integrity", {
        params = "",
        description = "Print current node integrity estimate.",
        func = function(name)
            local player = minetest.get_player_by_name(name)
            if not player then
                return false, "Player not found."
            end
            local pos = vector.round(player:get_pos())
            local integrity = core_destruction.get_integrity(pos)
            return true, "Integrity: " .. tostring(integrity)
        end,
    })
end
