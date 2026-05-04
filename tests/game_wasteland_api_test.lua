-- tests/game_wasteland_api_test.lua

local api = dofile("../game_wasteland/api.lua")

return { module = "game_wasteland", has_api = type(api) == "table" }
