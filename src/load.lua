display("Loading FR module")

FR = FR or {}

local files = {
    "buttons.lua", "effects.lua", "buffs.lua", "abilities.lua", "guilds.lua",
    "dps.lua", "taniwha.lua", "vanguard.lua", "bard.lua"
}

for i, file in ipairs(files) do dofile(frModulePath() .. "/src/" .. file) end

function FR.setup()
    -- Init code
    setupButtons()
    FR.setupDps()
end
