-- core_survival/internal/disease.lua

local function infect(actor, disease_id)
    if type(actor) ~= "table" or type(disease_id) ~= "string" then
        return false
    end
    actor.survival = actor.survival or {}
    actor.survival.diseases = actor.survival.diseases or {}
    actor.survival.disease_timers = actor.survival.disease_timers or {}
    local disease = core_survival and core_survival.data and core_survival.data.diseases and core_survival.data.diseases[disease_id]
    if not disease then
        return false
    end
    actor.survival.diseases[disease_id] = true
    actor.survival.disease_timers[disease_id] = disease.duration or 60
    return true
end

local function cure(actor, disease_id)
    if type(actor) ~= "table" or type(disease_id) ~= "string" then
        return false
    end
    if actor.survival and actor.survival.diseases then
        actor.survival.diseases[disease_id] = nil
    end
    if actor.survival and actor.survival.disease_timers then
        actor.survival.disease_timers[disease_id] = nil
    end
    return true
end

local function update_diseases(actor, dt)
    if type(actor) ~= "table" or type(dt) ~= "number" then
        return false
    end
    if not actor.survival or not actor.survival.diseases then
        return true
    end
    actor.survival.disease_timers = actor.survival.disease_timers or {}
    for disease_id in pairs(actor.survival.diseases) do
        local disease = core_survival and core_survival.data and core_survival.data.diseases and core_survival.data.diseases[disease_id]
        if disease then
            local timer = actor.survival.disease_timers[disease_id] or disease.duration or 0
            timer = timer - dt
            actor.survival.disease_timers[disease_id] = timer
            if disease.damage_per_tick and actor.hp then
                actor.hp = actor.hp - disease.damage_per_tick * dt
            end
            if timer <= 0 then
                actor.survival.diseases[disease_id] = nil
                actor.survival.disease_timers[disease_id] = nil
            end
        end
    end
    return true
end

return {
    infect = infect,
    cure = cure,
    update_diseases = update_diseases,
}
