guilds = guilds or {}

function setupGuild(guild_name)
    setupBard()
    setupTaniwha()
    setupHokemj()
    setupVanguard()

    if not guilds[guild_name] then return end
    echo("Setting up guild " .. guild_name .. "\n")

    guild = guilds[guild_name]

    setupAbilities()
    setupBuffButtons()
end

function addGuild(guild) guilds[guild.name] = guild end

