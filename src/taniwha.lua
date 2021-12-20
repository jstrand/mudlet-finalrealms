function setupTaniwha()
    addGuild({
        name = "Priest of Taniwha",
        buffs = {
            createBuff("Bless", "cast bless at me"),
            createBuff("Rainbow", "cast rainbow at me"),
            createBuff("Prayer", "cast prayer at me")
        },
        abilities = {
            createAbility("F1", "Curse", "cast curse at marked"),
            createAbility("F2", "Chant", "cast chant at marked"),
            createAbility("F3", "Flame strike", "cast flamestrike at marked"),
            createAbility("F4", "Thorn cloud", "cast thorn cloud at marked"),
            createAbility("F5", "Rainbow", "cast rainbow at me"),
            createAbility("F6", "Courage", "cast courage at me"),
            createAbility("F7", "Sanctuary", "cast sanctuary at me")
        }
    })
end
