display("Loading FR module")

FR = FR or {}

local files = {"effects.lua"}

for i, file in ipairs(files) do dofile(frModulePath() .. "/src/" .. file) end

