display("Loading FR module")

FR = FR or {}

local files = {
    "buttons.lua", "effects.lua", "buffs.lua", "abilities.lua", "guilds.lua",
    "taniwha.lua"
}

for i, file in ipairs(files) do dofile(frModulePath() .. "/src/" .. file) end

function FR.setup()
    -- ...
end
