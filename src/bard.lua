function setupBard()
    addGuild({
        name = "Bard",
        buffs = {
            createBuff("Protection", "cast protection at me"),
            createConditionalBuff("Playing", "play", partyNeedInspiration)
        },
        abilities = {
            createAbility("F1", "Shocking grasp",
                          "cast shocking grasp at marked"),
            createAbility("F2", "Sand storm", "cast sand storm at marked")
        }
    })
end

function partyNeedInspiration()
    for i, v in pairs(FR.multis.vitals) do
        if v then
            local gp_fraction = v.gp / v.maxGp
            if v.hp > 0 and gp_fraction < 0.4 then return true end
        end
    end
    return false
end
