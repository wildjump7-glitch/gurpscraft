-- core_crafting/api.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local crafting = {}
crafting.data = {}

local state = {
    registry = {},
    actor_state = {},
}

crafting._state = state

crafting.recipe_match = dofile(modpath .. "/internal/recipe_match.lua")
crafting.craft_logic = dofile(modpath .. "/internal/craft_logic.lua")
crafting.reverse_engineering = dofile(modpath .. "/internal/reverse_engineering.lua")
crafting.quality = dofile(modpath .. "/internal/quality.lua")

--- Public API: register_recipe.
function crafting.register_recipe(...)
    if state.registry and state.registry["register_recipe"] then
        return state.registry["register_recipe"](...)
    end
    return nil
end

--- Public API: get_recipe.
function crafting.get_recipe(...)
    if state.registry and state.registry["get_recipe"] then
        return state.registry["get_recipe"](...)
    end
    return nil
end

--- Public API: get_recipes_by_output.
function crafting.get_recipes_by_output(...)
    if state.registry and state.registry["get_recipes_by_output"] then
        return state.registry["get_recipes_by_output"](...)
    end
    return nil
end

--- Public API: get_recipes_by_tag.
function crafting.get_recipes_by_tag(...)
    if state.registry and state.registry["get_recipes_by_tag"] then
        return state.registry["get_recipes_by_tag"](...)
    end
    return nil
end

--- Public API: all_recipes.
function crafting.all_recipes(...)
    if state.registry and state.registry["all_recipes"] then
        return state.registry["all_recipes"](...)
    end
    return nil
end

--- Public API: can_craft.
function crafting.can_craft(...)
    if state.registry and state.registry["can_craft"] then
        return state.registry["can_craft"](...)
    end
    return nil
end

--- Public API: craft.
function crafting.craft(...)
    if state.registry and state.registry["craft"] then
        return state.registry["craft"](...)
    end
    return nil
end

--- Public API: get_craft_result.
function crafting.get_craft_result(...)
    if state.registry and state.registry["get_craft_result"] then
        return state.registry["get_craft_result"](...)
    end
    return nil
end

--- Public API: get_failure_result.
function crafting.get_failure_result(...)
    if state.registry and state.registry["get_failure_result"] then
        return state.registry["get_failure_result"](...)
    end
    return nil
end

--- Public API: get_critical_success_result.
function crafting.get_critical_success_result(...)
    if state.registry and state.registry["get_critical_success_result"] then
        return state.registry["get_critical_success_result"](...)
    end
    return nil
end

--- Public API: match_ingredients.
function crafting.match_ingredients(...)
    if state.registry and state.registry["match_ingredients"] then
        return state.registry["match_ingredients"](...)
    end
    return nil
end

--- Public API: match_tags.
function crafting.match_tags(...)
    if state.registry and state.registry["match_tags"] then
        return state.registry["match_tags"](...)
    end
    return nil
end

--- Public API: match_tools.
function crafting.match_tools(...)
    if state.registry and state.registry["match_tools"] then
        return state.registry["match_tools"](...)
    end
    return nil
end

--- Public API: get_skill_modifier.
function crafting.get_skill_modifier(...)
    if state.registry and state.registry["get_skill_modifier"] then
        return state.registry["get_skill_modifier"](...)
    end
    return nil
end

--- Public API: roll_crafting_check.
function crafting.roll_crafting_check(...)
    if state.registry and state.registry["roll_crafting_check"] then
        return state.registry["roll_crafting_check"](...)
    end
    return nil
end

--- Public API: reverse_engineer.
function crafting.reverse_engineer(...)
    if state.registry and state.registry["reverse_engineer"] then
        return state.registry["reverse_engineer"](...)
    end
    return nil
end

--- Public API: unlock_recipe.
function crafting.unlock_recipe(...)
    if state.registry and state.registry["unlock_recipe"] then
        return state.registry["unlock_recipe"](...)
    end
    return nil
end

--- Public API: get_unlocked_recipes.
function crafting.get_unlocked_recipes(...)
    if state.registry and state.registry["get_unlocked_recipes"] then
        return state.registry["get_unlocked_recipes"](...)
    end
    return nil
end

--- Public API: calculate_quality.
function crafting.calculate_quality(...)
    if state.registry and state.registry["calculate_quality"] then
        return state.registry["calculate_quality"](...)
    end
    return nil
end

--- Public API: apply_quality.
function crafting.apply_quality(...)
    if state.registry and state.registry["apply_quality"] then
        return state.registry["apply_quality"](...)
    end
    return nil
end

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    crafting.craft_test = dofile(modpath .. "/debug/craft_test.lua")
    crafting.reverse_test = dofile(modpath .. "/debug/reverse_test.lua")
end

return crafting
