-- tests/core_stats_api_test.lua

local function run()
    assert(type(core_stats) == "table", "core_stats should be loaded")
    return true
end

return {
    run = run,
}
