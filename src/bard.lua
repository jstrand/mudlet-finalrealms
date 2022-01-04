function setupBard()
    addGuild({
        name = "Bard",
        buffs = {
            createBuff("Protection", "cast protection at me"),
            createBuff("Singing", "play")
        },
        abilities = {
            createAbility("F1", "Shocking grasp",
                          "cast shocking grasp at marked"),
            createAbility("F2", "Sand storm", "cast sand storm at marked")
        }
    })
end

function partyNeedInspiration() return true end
