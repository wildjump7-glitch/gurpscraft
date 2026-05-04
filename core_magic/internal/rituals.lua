-- core_magic/internal/rituals.lua

local active_rituals = {}

local function generate_instance_id(ritual_id)
    return tostring(ritual_id) .. ":" .. tostring(os.time()) .. ":" .. tostring(math.random(100000))
end

local function start_ritual(actor, ritual_id, position)
    if type(actor) ~= "table" or type(ritual_id) ~= "string" then
        return false
    end
    actor.magic = actor.magic or {}
    local instance_id = generate_instance_id(ritual_id)
    local ritual_state = {
        id = ritual_id,
        instance_id = instance_id,
        position = (type(position) == "table" and position) or actor.position,
        elapsed = 0,
    }
    actor.magic.ritual = ritual_state
    active_rituals[instance_id] = actor
    return instance_id
end

local function update_ritual(ritual_instance_id, dt)
    if type(ritual_instance_id) ~= "string" or type(dt) ~= "number" then
        return false
    end
    local actor = active_rituals[ritual_instance_id]
    if type(actor) ~= "table" or type(actor.magic) ~= "table" or type(actor.magic.ritual) ~= "table" then
        return false
    end
    actor.magic.ritual.elapsed = actor.magic.ritual.elapsed + dt
    return true
end

local function finish_ritual(ritual_instance_id)
    if type(ritual_instance_id) ~= "string" then
        return false
    end
    local actor = active_rituals[ritual_instance_id]
    if type(actor) ~= "table" then
        return false
    end
    actor.magic = actor.magic or {}
    actor.magic.ritual = nil
    active_rituals[ritual_instance_id] = nil
    return true
end

local function abort_ritual(ritual_instance_id)
    return finish_ritual(ritual_instance_id)
end

return {
    start_ritual = start_ritual,
    update_ritual = update_ritual,
    finish_ritual = finish_ritual,
    abort_ritual = abort_ritual,
}
