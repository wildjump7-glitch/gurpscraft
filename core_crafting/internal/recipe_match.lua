-- core_crafting/internal/recipe_match.lua

local function normalize_ingredients(recipe)
    if type(recipe) ~= "table" then
        return nil
    end

    local ingredients = recipe.ingredients or recipe.inputs
    if type(ingredients) ~= "table" then
        return nil
    end

    local normalized = {}
    local is_array = true
    for key in pairs(ingredients) do
        if type(key) ~= "number" then
            is_array = false
            break
        end
    end

    if is_array then
        for _, item in ipairs(ingredients) do
            if type(item) == "string" then
                normalized[item] = (normalized[item] or 0) + 1
            elseif type(item) == "table" and type(item.item) == "string" then
                normalized[item.item] = (normalized[item.item] or 0) + (type(item.count) == "number" and item.count or 1)
            end
        end
    else
        for item, count in pairs(ingredients) do
            if type(item) == "string" and type(count) == "number" then
                normalized[item] = count
            elseif type(item) == "string" and type(count) == "string" then
                normalized[count] = (normalized[count] or 0) + 1
            end
        end
    end

    return normalized
end

local function match_ingredients(recipe, inventory)
    if type(recipe) ~= "table" or type(inventory) ~= "table" then
        return false
    end
    local ingredients = normalize_ingredients(recipe)
    if type(ingredients) ~= "table" then
        return false
    end

    for item, count in pairs(ingredients) do
        if type(count) ~= "number" or count <= 0 then
            return false
        end
        if not inventory[item] or inventory[item] < count then
            return false
        end
    end
    return true
end

local function list_contains(list, value)
    if type(list) ~= "table" then
        return false
    end
    for _, entry in ipairs(list) do
        if entry == value then
            return true
        end
    end
    return false
end

local function match_tags(recipe, tags)
    if type(recipe) ~= "table" or type(tags) ~= "table" then
        return false
    end
    if not recipe.tags then
        return true
    end
    for _, tag in ipairs(recipe.tags) do
        if not list_contains(tags, tag) then
            return false
        end
    end
    return true
end

local function match_tools(recipe, tools)
    if type(recipe) ~= "table" or type(tools) ~= "table" then
        return false
    end
    if not recipe.tools then
        return true
    end
    for _, tool in ipairs(recipe.tools) do
        if not tools[tool] then
            return false
        end
    end
    return true
end

return {
    match_ingredients = match_ingredients,
    match_tags = match_tags,
    match_tools = match_tools,
}
