-- core_factions/internal/strategy.lua

local function get_region_data(rx, rz)
    if type(core_simulation) ~= "table" or type(core_simulation.get_region) ~= "function" then
        return nil
    end
    return core_simulation.get_region(rx, rz)
end

local function is_region_contested(rx, rz)
    local region = get_region_data(rx, rz)
    return region and region.contested or false
end

local function adjust_influence(rx, rz, faction_id, delta)
    if type(rx) ~= "number" or type(rz) ~= "number" or type(faction_id) ~= "string" or type(delta) ~= "number" then
        return false
    end
    if type(core_simulation) ~= "table" or type(core_simulation.add_region_influence) ~= "function" then
        return false
    end
    return core_simulation.add_region_influence(rx, rz, faction_id, delta)
end

local function create_squad(def)
    if type(def) ~= "table" then
        return nil
    end
    if type(core_simulation) ~= "table" or type(core_simulation.create_squad) ~= "function" then
        return nil
    end
    return core_simulation.create_squad(def)
end

local function redirect_squad(id, target_region)
    if type(id) ~= "string" or type(target_region) ~= "table" then
        return false
    end
    if type(core_simulation) ~= "table" or type(core_simulation.set_squad_target) ~= "function" then
        return false
    end
    return core_simulation.set_squad_target(id, target_region)
end

local function get_objective_priority_modifier(faction_id, objective)
    if type(faction_id) ~= "string" or type(objective) ~= "table" then
        return 0
    end
    local bonus = 0
    if type(objective.region) == "table" and is_region_contested(objective.region.rx, objective.region.rz) then
        bonus = bonus + 1
    end
    if objective.type == "investigate" then
        bonus = bonus + 0.5
    elseif objective.type == "flee" then
        bonus = bonus - 0.5
    end
    return bonus
end

local function get_faction_tags(faction_id)
    if type(faction_id) ~= "string" then
        return {}
    end
    if type(core_factions) ~= "table" or type(core_factions.get) ~= "function" then
        return {}
    end
    local definition = core_factions.get(faction_id)
    if type(definition) ~= "table" or type(definition.tags) ~= "table" then
        return {}
    end
    return definition.tags
end

local function get_territory_behavior_modifiers(actor, rx, rz)
    local modifiers = { aggression = 0, caution = 0 }
    local region = get_region_data(rx, rz)
    if not region then
        return modifiers
    end
    if region.contested then
        modifiers.caution = modifiers.caution + 0.4
    end
    if type(actor) == "table" and actor.faction and region.ownerfactionid == actor.faction then
        modifiers.aggression = modifiers.aggression + 0.3
    end
    return modifiers
end

return {
    is_region_contested = is_region_contested,
    adjust_influence = adjust_influence,
    create_squad = create_squad,
    redirect_squad = redirect_squad,
    get_objective_priority_modifier = get_objective_priority_modifier,
    get_faction_tags = get_faction_tags,
    get_territory_behavior_modifiers = get_territory_behavior_modifiers,
}
