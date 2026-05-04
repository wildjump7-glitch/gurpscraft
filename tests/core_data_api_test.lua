-- tests/core_data_api_test.lua

local function run()
    assert(type(core_data) == "table", "core_data should be loaded")
    return true
end

return {
    run = run,
}
