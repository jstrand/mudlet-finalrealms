function setupVanguard()
    addGuild({
        name = "Vanguard",
        buffs = {
            createBuffF("assault",
                        function() send("assault " .. (level + 4)) end, 5),
            createBuff("vigor", "vigor", 5)
        }
    })
end
