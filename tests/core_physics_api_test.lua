-- tests/core_physics_api_test.lua

local function run()
    assert(type(core_physics) == "table", "core_physics should be loaded")
    return true
end

return {
    run = run,
}
