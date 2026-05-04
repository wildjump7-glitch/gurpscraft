-- core_magic/internal/casting.lua

local spells = {}

local function register_spell(id, definition)
    if type(id) ~= "string" or id == "" or type(definition) ~= "table" then
        return false
    end
    if spells[id] then
        return false
    end
    spells[id] = definition
    return true
end

local function get_spell(id)
    if type(id) ~= "string" or id == "" then
        return nil
    end
    return spells[id]
end

local function all_spells()
    local copy = {}
    for id, def in pairs(spells) do
        copy[id] = def
    end
    return copy
end

local function get_spell_cost(spell)
    if type(spell) ~= "table" then
        return 0
    end
    return spell.mana_cost or spell.cost or 0
end

local function can_cast(actor, spell_id)
    if type(spell_id) ~= "string" or spell_id == "" or type(actor) ~= "table" then
        return false
    end
    local spell = get_spell(spell_id)
    if not spell then
        return false
    end
    local mana = core_magic.get_mana(actor)
    return mana >= get_spell_cost(spell)
end

local function get_cast_cost(spell_id)
    local spell = get_spell(spell_id)
    return get_spell_cost(spell)
end

local function cast(actor, spell_id, target)
    if not can_cast(actor, spell_id) then
        return false
    end

    local cost = get_cast_cost(spell_id)
    core_magic.modify_mana(actor, -cost)

    local spell = get_spell(spell_id)
    if spell and spell.effect_id then
        if spell.area then
            core_magic.apply_area_effect(spell.effect_id, target and target.position or actor.position, spell.radius or 0, actor, spell.power or 1)
        else
            core_magic.apply_spell_effect(spell.effect_id, target or { position = actor.position }, actor, spell.power or 1)
        end
    end

    return true
end

local function interrupt(actor)
    if type(actor) ~= "table" then
        return false
    end
    actor.magic = actor.magic or {}
    actor.magic.is_casting = false
    return true
end

return {
    register_spell = register_spell,
    get_spell = get_spell,
    all_spells = all_spells,
    can_cast = can_cast,
    get_cast_cost = get_cast_cost,
    cast = cast,
    interrupt = interrupt,
}
