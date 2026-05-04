-- core_combat/internal/weapon_state.lua

local weapon_state_by_actor = setmetatable({}, { __mode = "k" })

local function get_state(actor)
    local state = weapon_state_by_actor[actor]
    if not state then
        state = {
            reloading = false,
            fire_mode = "semi",
            ads = false,
        }
        weapon_state_by_actor[actor] = state
    end
    return state
end

local function start_reload(actor)
    local state = get_state(actor)
    state.reloading = true
    return true
end

local function finish_reload(actor)
    local state = get_state(actor)
    state.reloading = false
    return true
end

local function toggle_fire_mode(actor)
    local state = get_state(actor)
    if state.fire_mode == "semi" then
        state.fire_mode = "burst"
    elseif state.fire_mode == "burst" then
        state.fire_mode = "auto"
    else
        state.fire_mode = "semi"
    end
    return state.fire_mode
end

local function set_ads(actor, enabled)
    local state = get_state(actor)
    state.ads = enabled == true
    return state.ads
end

return {
    start_reload = start_reload,
    finish_reload = finish_reload,
    toggle_fire_mode = toggle_fire_mode,
    set_ads = set_ads,
}