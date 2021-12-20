guilds = guilds or {}

function setupGuild(guild_name)
    setupBard()
    setupTaniwha()
    setupVanguard()

    is_bard = guild_name == "Bard"
    is_taniwha = guild_name == "Priest of Taniwha"
    is_vanguard = guild_name == "Vanguard"

    guild = guilds[guild_name]

    setupButtons()
    setupAbilities()
    setupBuffButtons()
end

function addGuild(guild) guilds[guild.name] = guild end

