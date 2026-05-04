-- core_actor/internal/perception.lua

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

local function can_see(actor, target)
    local actor_pos = get_position(actor)
    local target_pos = get_position(target)
    if not actor_pos or not target_pos then
        return false
    end

    local vision_range = (actor.stats and actor.stats.attributes and actor.stats.attributes.perception) or 10
    if type(vision_range) ~= "number" or vision_range <= 0 then
        vision_range = 10
    end

    local distance = get_distance(actor_pos, target_pos)
    if distance > vision_range then
        return false
    end

    return true
end

local function can_hear(actor, source)
    local actor_pos = get_position(actor)
    local source_pos = get_position(source)
    if not actor_pos or not source_pos then
        return false
    end

    local hearing_range = (actor.stats and actor.stats.attributes and actor.stats.attributes.hearing) or 8
    if type(hearing_range) ~= "number" or hearing_range <= 0 then
        hearing_range = 8
    end

    local distance = get_distance(actor_pos, source_pos)
    return distance <= hearing_range
end

local function get_targets_in_range(actor, range)
    if type(actor) ~= "table" then
        return {}
    end

    local actor_pos = get_position(actor)
    if not actor_pos then
        return {}
    end

    range = type(range) == "number" and range or (actor.stats and actor.stats.attributes and actor.stats.attributes.perception) or 10
    if range <= 0 then
        range = 10
    end

    if type(minetest) == "table" and type(minetest.get_objects_inside_radius) == "function" then
        local objects = minetest.get_objects_inside_radius(actor_pos, range)
        local targets = {}
        for _, obj in ipairs(objects) do
            if obj and obj ~= actor then
                targets[#targets + 1] = obj
            end
        end
        return targets
    end

    return {}
end

local function get_alertness(actor)
    if type(actor) ~= "table" then
        return 0
    end
    return actor.alertness or 0
end

return {
    can_see = can_see,
    can_hear = can_hear,
    get_targets_in_range = get_targets_in_range,
    get_alertness = get_alertness,
}
