-- core_ui/internal/status_effects.lua
-- Status effect tracking and display management

local effects_state = {
    player_effects = {},
}

local function ensure_player(player)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end
    if not player or not player:is_player() then
        return nil
    end
    local name = player:get_player_name()
    effects_state.player_effects[name] = effects_state.player_effects[name] or {}
    return name, effects_state.player_effects[name]
end

local function add_status_effect(player, effect_id, effect)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end
    if not player or not player:is_player() then
        return false
    end
    if type(effect_id) ~= "string" or type(effect) ~= "table" then
        return false
    end
    local name, effects = ensure_player(player)
    if not name then
        return false
    end
    effects[effect_id] = effect
    effect.id = effect_id
    effect.applied_at = os.time()
    return true
end

local function remove_status_effect(player, effect_id)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end
    if not player or not player:is_player() then
        return false
    end
    local name, effects = ensure_player(player)
    if not name then
        return false
    end
    effects[effect_id] = nil
    return true
end

local function get_status_effect(player, effect_id)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end
    if not player or not player:is_player() then
        return nil
    end
    local name, effects = ensure_player(player)
    if not name then
        return nil
    end
    return effects[effect_id]
end

local function get_all_effects(player)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end
    if not player or not player:is_player() then
        return {}
    end
    local name, effects = ensure_player(player)
    if not name then
        return {}
    end
    return effects
end

local function update_status_effects(player, dt)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end
    if not player or not player:is_player() then
        return false
    end
    local name, effects = ensure_player(player)
    if not name then
        return false
    end
    for effect_id, effect in pairs(effects) do
        if effect.duration and type(effect.duration) == "number" then
            effect.duration = effect.duration - (dt or 0)
            if effect.duration <= 0 then
                effects[effect_id] = nil
            end
        end
    end
    return true
end

local function clear_effects(player)
    if type(player) == "string" then
        player = minetest.get_player_by_name(player)
    end
    if not player or not player:is_player() then
        return false
    end
    local name, effects = ensure_player(player)
    if not name then
        return false
    end
    for k in pairs(effects) do
        effects[k] = nil
    end
    return true
end

return {
    add_status_effect = add_status_effect,
    remove_status_effect = remove_status_effect,
    get_status_effect = get_status_effect,
    get_all_effects = get_all_effects,
    update_status_effects = update_status_effects,
    clear_effects = clear_effects,
}
