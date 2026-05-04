-- tests/core_actor_api_test.lua

local api = dofile("../core_actor/api.lua")

local actor = nil
if type(api.spawn) == "function" then
    actor = api.spawn("soldier", { x = 1, y = 2, z = 3 }, { faction = "neutral" })
end

return {
    module = "core_actor",
    has_api = type(api) == "table",
    checks = {
        spawn = type(api.spawn) == "function",
        despawn = type(api.despawn) == "function",
        is_actor = type(api.is_actor) == "function",
        get_faction = type(api.get_faction) == "function",
        set_faction = type(api.set_faction) == "function",
        spawn_created_actor = type(actor) == "table" and api.is_actor(actor),
        actor_faction = type(actor) == "table" and api.get_faction(actor) == "neutral",
    },
}
