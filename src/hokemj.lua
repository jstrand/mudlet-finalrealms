function setupHokemj()
    addGuild({
        name = "Priest of Hokemj",
        buffs = {
            --
            createBuff("Bless", "cast bless at me")
        },
        abilities = {
            createAbility("F1", "Curse", "cast curse at marked"),
            createAbility("F2", "Thorn shock", "cast thorn shock at marked"),
            createAbility("F3", "Thorn cloud", "cast thorn cloud at marked"),
            createAbility("F4", "Sanctuary", "cast sanctuary at me")
        }
    })
end
