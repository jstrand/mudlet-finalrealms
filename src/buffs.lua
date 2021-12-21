buff_gp_limit = buff_gp_limit or 0.2

function createBuff(name, command)
    return {name = name, command = command, auto = false}
end

function createBuffF(name, commandF)
    local buff = createBuff(name, nil)
    buff.commandF = commandF

    return buff
end

function activateBuff(buff)
    if buff.commandF then
        buff.commandF()
    else
        send(buff.command)
    end
end

function refreshBuffs()
    if not guild then return end
    if gp >= max_gp * buff_gp_limit then

        for i, buff in ipairs(guild.buffs) do
            if not hasEffect(buff.name) and buff.auto then
                activateBuff(buff)
            end
        end

    end
end

function buffByName(name)
    for i, v in ipairs(guild.buffs) do if v.name == name then return v end end
end

function clickBuff(name)
    local buff = buffByName(name)
    buff.auto = not buff.auto
    if not hasEffect(name) then activateBuff(buff) end
    refreshBuffButtons()
end

function setupBuffButtons()
    if not guild then return end
    for i, buff in ipairs(guild.buffs) do
        buff.label = addBuffButton("buff_" .. i .. "_button", buff.name)
    end
    refreshBuffButtons()
end

function refreshBuffButtons()
    if not guild then return end
    for i, buff in ipairs(guild.buffs) do
        updateStyleWithTrying(buff.label, hasEffect(buff.name), buff.auto)
    end
end
