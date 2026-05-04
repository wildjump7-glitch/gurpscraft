-- tests/core_foundation_api_test.lua

local function run()
    assert(type(core_foundation) == "table", "core_foundation should be loaded")
    assert(type(core_foundation.log) == "table", "core_foundation.log should exist")
    assert(type(core_foundation.util) == "table", "core_foundation.util should exist")
    return true
end

return {
    run = run,
}
