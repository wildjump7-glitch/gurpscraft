-- core_effects/internal/sound_fx.lua

local function sound(id, pos, params)
    minetest.sound_play(id, {pos = pos, gain = params.gain or 1.0})
end

local function sound_local(player, id, params)
    minetest.sound_play(id, {to_player = player:get_player_name(), gain = params.gain or 1.0})
end

local function sound_loop_start(player, id, params)
    local handle = minetest.sound_play(id, {
        to_player = player and player:get_player_name() or nil,
        gain = params.gain or 1.0,
        max_hear_distance = params.max_hear_distance or 64,
        loop = true,
    })
    return handle
end

local function sound_loop_stop(loop_id)
    if loop_id then
        minetest.sound_stop(loop_id)
    end
end

return {
    sound = sound,
    sound_local = sound_local,
    sound_loop_start = sound_loop_start,
    sound_loop_stop = sound_loop_stop,
}