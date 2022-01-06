buff_gp_limit = buff_gp_limit or 0.2
default_buff_lockout = 5

function createBuff(name, command, buffLockout)
    return {name = name, command = command, auto = false, lockout = buffLockout}
end

function createBuffF(name, commandF, buffLockout)
    local buff = createBuff(name, nil, buffLockout)
    buff.commandF = commandF

    return buff
end

function createConditionalBuff(name, command, conditionF, buffLockout)
    local buff = createBuff(name, command, buffLockout)
    buff.conditionF = conditionF

    return buff

end

function activateBuff(buff)
    if buff.conditionF and not buff.conditionF() then return 0 end

    if buff.commandF then
        buff.commandF()
    else
        send(buff.command)
    end
    return buff.lockout or default_buff_lockout
end

function refreshBuffs()
    if not guild then return end
    if gp >= max_gp * buff_gp_limit then

        for i, buff in ipairs(guild.buffs) do
            if not hasEffect(buff.name) and buff.auto then
                return activateBuff(buff)
            end
        end
    end
    return 0
end

function buffByName(name)
    for i, v in ipairs(guild.buffs) do if v.name == name then return v end end
end

function clickBuff(name)
    local buff = buffByName(name)
    buff.auto = not buff.auto
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
