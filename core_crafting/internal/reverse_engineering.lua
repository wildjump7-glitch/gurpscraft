-- core_crafting/internal/reverse_engineering.lua

local unlocked = {}

local function reverse_engineer(actor, item_id)
    if type(actor) ~= "table" or type(item_id) ~= "string" then
        return false
    end
    unlocked[actor.id or tostring(actor)] = unlocked[actor.id or tostring(actor)] or {}
    unlocked[actor.id or tostring(actor)][item_id] = true
    return true
end

local function unlock_recipe(actor, recipe_id)
    if type(actor) ~= "table" or type(recipe_id) ~= "string" then
        return false
    end
    unlocked[actor.id or tostring(actor)] = unlocked[actor.id or tostring(actor)] or {}
    unlocked[actor.id or tostring(actor)][recipe_id] = true
    return true
end

local function get_unlocked_recipes(actor)
    return unlocked[actor.id or tostring(actor)] or {}
end

local function get_skill_modifier(actor, skill_id)
    if type(actor) ~= "table" or type(skill_id) ~= "string" then
        return 0
    end
    return 0
end

local function roll_crafting_check(actor, skill_id)
    return math.random(1, 100)
end

return {
    reverse_engineer = reverse_engineer,
    unlock_recipe = unlock_recipe,
    get_unlocked_recipes = get_unlocked_recipes,
    get_skill_modifier = get_skill_modifier,
    roll_crafting_check = roll_crafting_check,
}
