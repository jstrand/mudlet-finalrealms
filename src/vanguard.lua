function setupVanguard()
    addGuild({
        name = "Vanguard",
        buffs = {
            createBuffF("assault",
                        function() send("assault " .. (level + 4)) end),
            createBuff("vigor", "vigor")
        }
    })
end
