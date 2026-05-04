-- core_actor/internal/combat_ai.lua

local function get_position(subject)
    if type(subject) ~= "table" then
        return nil
    end
    if type(subject.position) == "table" then
        return subject.position
    end
    if type(subject.get_pos) == "function" then
        return subject:get_pos()
    end
    return nil
end

local function get_distance(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        return math.huge
    end
    local dx = (a.x or 0) - (b.x or 0)
    local dy = (a.y or 0) - (b.y or 0)
    local dz = (a.z or 0) - (b.z or 0)
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function is_hostile(actor, target)
    if type(core_factions) == "table" and type(core_factions.is_hostile) == "function" then
        if type(actor) == "table" and type(target) == "table" then
            if type(actor.id) == "string" and type(target.id) == "string" then
                return core_factions.is_hostile(actor.id, target.id)
            end
            return core_factions.is_faction_hostile(actor.faction, target.faction)
        end
    end
    return true
end

local function choose_target(actor, targets)
    if type(actor) ~= "table" then
        return nil
    end
    if type(targets) ~= "table" then
        targets = actor.targets or {}
    end

    local actor_pos = get_position(actor)
    local best_target = nil
    local best_distance = math.huge

    for _, target in ipairs(targets) do
        if target ~= actor then
            local target_pos = get_position(target)
            if actor_pos and target_pos and is_hostile(actor, target) then
                local distance = get_distance(actor_pos, target_pos)
                if distance < best_distance then
                    best_distance = distance
                    best_target = target
                end
            end
        end
    end

    return best_target
end

local function should_flee(actor)
    if type(actor) ~= "table" then
        return false
    end
    local hp = type(actor.hp) == "number" and actor.hp or 0
    local max_hp = type(actor.max_hp) == "number" and actor.max_hp or 100
    local low_health = hp < max_hp * 0.25
    local suppressed = (actor.suppression or 0) >= 0.6
    return low_health or suppressed
end

local function should_reload(actor)
    if type(actor) ~= "table" then
        return false
    end
    local weapon = actor.inventory and actor.inventory.weapon
    if type(weapon) ~= "table" then
        return false
    end
    if type(weapon.ammo) ~= "number" or type(weapon.max_ammo) ~= "number" then
        return false
    end
    return weapon.ammo <= weapon.max_ammo * 0.25
end

local function should_switch_weapon(actor)
    if type(actor) ~= "table" then
        return false
    end
    if should_reload(actor) and type(actor.inventory) == "table" and type(actor.inventory.secondary_weapon) == "table" then
        return true
    end
    return false
end

return {
    choose_target = choose_target,
    should_flee = should_flee,
    should_reload = should_reload,
    should_switch_weapon = should_switch_weapon,
}
