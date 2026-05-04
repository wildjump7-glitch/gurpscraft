-- core_stats/debug/stat_inspector.lua

local function inspect_actor(name, actor)
    if not actor or not actor.stats then
        return false, "Actor has no stat sheet."
    end
    local payload = minetest.serialize(actor.stats)
    if not payload then
        return false, "Failed to serialize actor stats."
    end
    minetest.chat_send_player(name, payload)
    return true, "Stat sheet printed."
end

return {
    inspect_actor = inspect_actor,
}