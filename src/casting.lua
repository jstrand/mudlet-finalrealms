-- Set in guild-specific to adjust
gp_needed = 0.2
multi_limit = 2
lockout = lockout or 0
max_lockout = max_lockout or 0

function castOnSingle() send("xp1") end

function castOnMultiple() send("xp2") end

function refreshLockoutGauge()
    if not lockoutGauge then return end

    if lockout <= 0 then
        lockoutGauge:hide()
    else
        lockoutGauge:show()
        lockoutGauge:setValue(lockout, max_lockout, "")
    end
end

function setLockout(new_lockout)
    if new_lockout < 0 then
        lockout = 0
        max_lockout = 0
    else
        lockout = new_lockout
        if lockout > max_lockout then max_lockout = lockout end
    end

    refreshLockoutGauge()
end

function lockedOut() return lockout > 0 end

function doCasts()

    if lockedOut() then
        setLockout(lockout - 0.1)
        return
    end

    if gp == nil or max_gp == nil or gp < max_gp * gp_needed then return end

    local buffLockout = refreshBuffs()
    if buffLockout > 0 then
        setLockout(buffLockout)
        return
    end

    if not auto_cast then return end

    local fighting = #gmcp.Action.Round.Fighting

    if fighting == 0 then
        -- nothing
    elseif fighting >= multi_limit then
        castOnMultiple()
        setLockout(8)
    else
        castOnSingle()
        setLockout(4)
    end
end
