display("Loading FR module")

FR = FR or {}

local files = {
    "buttons.lua", "effects.lua", "buffs.lua", "abilities.lua", "guilds.lua",
    "dps.lua", "taniwha.lua", "vanguard.lua", "bard.lua"
}

for i, file in ipairs(files) do dofile(frModulePath() .. "/src/" .. file) end

function FR.setup()
    -- Init code
    -- TODO: setupContainers
    leftOfMapContainer = Geyser.Container:new({
        name = "leftOfMapContainer",
        x = 0,
        y = 0,
        width = "70%",
        height = "100%"
    })
    leftOfMapContainer:flash()

    setupButtons()
    FR.setupDps()
end
