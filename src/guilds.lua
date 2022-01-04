guilds = guilds or {}

function setupGuild(guild_name)
    setupBard()
    setupTaniwha()
    setupHokemj()
    setupVanguard()

    if not guilds[guild_name] then return end
    echo("Setting up guild " .. guild_name)

    is_bard = guild_name == "Bard"
    is_taniwha = guild_name == "Priest of Taniwha"
    is_vanguard = guild_name == "Vanguard"

    guild = guilds[guild_name]

    setupAbilities()
    setupBuffButtons()
end

function addGuild(guild) guilds[guild.name] = guild end

