-- core_effects/debug/fx_test.lua

local function test_fx(player, preset)
    preset = preset or "fireball_explosion"
    core_effects.play(preset, player:get_pos(), { player = player })
end

if minetest.settings:get_bool("gurpscraft_debug", false) then
    minetest.register_chatcommand("fx_test", {
        params = "[preset]",
        description = "Play a core_effects preset for debugging.",
        func = function(name, param)
            local player = minetest.get_player_by_name(name)
            if not player then
                return false, "Player not found"
            end
            test_fx(player, param ~= "" and param or nil)
            return true, "Played effect preset: " .. (param ~= "" and param or "fireball_explosion")
        end,
    })
end

return {
    test_fx = test_fx,
}