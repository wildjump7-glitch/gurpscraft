-- core_stats/data/derived.lua

return {
    HP = { mode = "sum", attributes = { "HT" }, offset = 0 },
    Will = { mode = "attribute", attribute = "IQ" },
    Perception = { mode = "attribute", attribute = "IQ" },
    Fatigue = { mode = "attribute", attribute = "HT" },
    Basic_Speed = { mode = "average", attributes = { "HT", "DX" } },
    Basic_Move = { mode = "average", attributes = { "HT", "DX" }, round = "floor" },
}