-- core_crafting/internal/craft_logic.lua

local recipes = {}

local function register_recipe(id, recipe)
    if type(id) ~= "string" or id == "" or type(recipe) ~= "table" then
        return false
    end
    recipes[id] = recipe
    return true
end

local function get_recipe(id)
    return recipes[id]
end

local function all_recipes()
    local copy = {}
    for id, recipe in pairs(recipes) do
        copy[id] = recipe
    end
    return copy
end

local function get_recipes_by_output(output)
    if type(output) ~= "string" then
        return {}
    end
    local result = {}
    for id, recipe in pairs(recipes) do
        if type(recipe.output) == "string" and recipe.output == output then
            result[id] = recipe
        elseif type(recipe.output) == "table" and recipe.output.item == output then
            result[id] = recipe
        end
    end
    return result
end

local function get_recipes_by_tag(tag)
    if type(tag) ~= "string" then
        return {}
    end
    local result = {}
    for id, recipe in pairs(recipes) do
        if type(recipe.tags) == "table" then
            for _, entry in ipairs(recipe.tags) do
                if entry == tag then
                    result[id] = recipe
                    break
                end
            end
        end
    end
    return result
end

local function can_craft(id, inventory, tools)
    if type(id) ~= "string" or type(inventory) ~= "table" then
        return false
    end
    local recipe = get_recipe(id)
    if not recipe then
        return false
    end
    if not core_crafting.match_ingredients(recipe, inventory) then
        return false
    end
    if not core_crafting.match_tools(recipe, tools or {}) then
        return false
    end
    if type(recipe.unlock_required) == "string" and type(recipe.actor) == "table" then
        -- unlock checks can be implemented here if needed
    end
    return true
end

local function craft(id, inventory, tools)
    if not can_craft(id, inventory, tools) then
        return false
    end
    local result = get_craft_result(id)
    if not result then
        return false
    end
    return {
        success = true,
        output = result,
        failed = false,
        critical = false,
    }
end

local function get_craft_result(id)
    local recipe = get_recipe(id)
    if not recipe then
        return nil
    end
    if type(recipe.output) == "table" then
        return recipe.output
    elseif type(recipe.output) == "string" then
        return {
            item = recipe.output,
            count = recipe.count or 1,
        }
    end
    return nil
end

local function get_failure_result(id)
    local recipe = get_recipe(id)
    return recipe and recipe.failure or nil
end

local function get_critical_success_result(id)
    local recipe = get_recipe(id)
    return recipe and recipe.critical_success or nil
end

return {
    register_recipe = register_recipe,
    get_recipe = get_recipe,
    all_recipes = all_recipes,
    can_craft = can_craft,
    craft = craft,
    get_craft_result = get_craft_result,
    get_failure_result = get_failure_result,
    get_critical_success_result = get_critical_success_result,
}
