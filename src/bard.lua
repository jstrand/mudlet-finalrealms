function setupBard()
    addGuild({
        name = "Bard",
        buffs = {
            createBuff("Protection", "cast protection at me"),
            createBuff("Singing", "play")
        }
    })
end
