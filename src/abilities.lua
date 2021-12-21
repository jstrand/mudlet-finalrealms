function setupAbilities()
    if not guild or not guild.abilities then return end

    for i, ability in ipairs(guild.abilities) do
        addAbilityButton(ability.name, i,
                         ability.shortcutKey .. ". " .. ability.name)
    end
end

function createAbility(shortcutKey, name, command)
    return {name = name, shortcutKey = shortcutKey, command = command}
end

function abilityByName(name)
    for i, v in ipairs(guild.abilities) do
        if v.name == name then return v end
    end
end

function activateAbilityShortcut(shortcutKey)
    for i, v in ipairs(guild.abilities) do
        if v.shortcutKey == shortcutKey then send(v.command) end
    end
end

function activateAbility(name)
    local ability = abilityByName(name)
    send(ability.command)
end
