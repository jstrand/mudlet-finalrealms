flee_limit = 0.6
health_limit_percent = 0.8
heal_limit_percent = 0.65
gp_limit = 0.26
repop_delta = 600

fleeing = fleeing or false

-- xp_goal = max_xp*1.3
xp_goal = 30000000
function goalReached()
    return false
    -- return xp >= xp_goal
end

function checkHealth()
    if not xp_helper and not xp_health_pause then return end

    if hp < max_hp * flee_limit and current_room ~= xp_area.waiting_room then
        -- run to waiting room
        if not fleeing and xp_area.waiting_room and
            getPath(current_room, xp_area.waiting_room) then
            echo("\nBrave sir robin...\n")
            refreshButtons()
            xp_path = copySpeedWalkDir()
            fighting = 0
            fleeing = true
            stepXp()
        end
    else
        fleeing = false
    end

    if hp < max_hp * heal_limit_percent then
        send("cast cure large wounds at me")
    end

    if hp < max_hp * health_limit_percent then
        if not xp_health_pause then
            xp_helper = false
            xp_health_pause = true
            echo("\nPauseing XP, too little HP\n")
            refreshButtons()
        end

        --		if xp_health_timer then
        --			killTimer(xp_health_timer)
        --		end
        --		xp_health_timer = tempTimer(60, [[send("sc")]])
    elseif xp_health_pause then
        xp_helper = true
        xp_health_pause = false
        echo("\nHealth regained, resuming XP\n")
        -- refreshButtons()
        stepXp()
    end
end

function checkGuildPoints()
    if not xp_helper and not xp_gp_pause then return end

    gp_disabled = true
    if gp_disabled then return end

    if gp <= 30 then -- gp_limit * max_gp then
        if not xp_gp_pause then
            xp_helper = false
            xp_gp_pause = true
            echo("\nPauseing XP, regenerating GP\n")
        end
    elseif xp_gp_pause and gp >= max_gp then
        xp_helper = true
        xp_gp_pause = false
        echo("\nGP regained, resuming XP\n")
        stepXp()
    end

    if xp_gp_pause then
        if xp_gp_timer then killTimer(xp_gp_timer) end
        xp_gp_timer = tempTimer(60, [[send("sc")]])
    end
end

function removeFight()
    if fighting ~= nil and fighting > 0 then
        fighting = fighting - 1
    else
        fighting = 0
    end

    if not xp_helper and not xp_health_pause and not xp_gp_pause then return end

    if fighting == 0 then
        -- send("loot_bury")
        visitRoom()
        stepXp()
    end
end

xp_area = xp_area or {}

function repopped(room_id)
    if xp_visit_time[room_id] then
        return xp_visit_time[room_id] <= (os.time() - repop_delta)
    else
        return false
    end
end

function stepXp()
    if not xp_helper and not fleeing then return end

    if xp_movement_timer then
        killTimer(xp_movement_timer)
        xp_movement_timer = nil
    end

    -- If a movement has been set wait for a new room before doing anything else
    if movement ~= nil then return end

    -- checkHealth()
    -- checkGuildPoints()

    if fighting > 0 and not fleeing then return end

    -- test if the goal is reached, if so return to waiting room and stop
    if goalReached() and current_room == xp_area.waiting_room then
        toggleXp() -- stop working
        -- send("q")
        auto_buff = false
        refreshButtons()
        return
    elseif goalReached() then
        -- reuse fleeing to get back
        if not fleeing and xp_area.waiting_room and
            getPath(current_room, xp_area.waiting_room) then
            echo("\nGoal reached, going to waiting room...\n")
            xp_path = copySpeedWalkDir()
            fighting = 0
            fleeing = true
        end
    end

    if (moving and not fleeing) and repopped(current_room) then
        -- Attack targets, but only if this is a room where we expect to find monsters
        send("xpk")
        moving = false
        return
    end

    if fleeing and current_room == xp_area.waiting_room then
        fleeing = false
    else
        -- not fighting or moving, move
        movement = nextXpDir()
        if movement == nil then
            echo("\nWaiting for a room to repop.\n")
            xp_restart_timer = tempTimer(60, stepXp)
        else
            moving = true
            xp_movement_timer = tempTimer(60, [[send("gl")]])
            -- send("party move " .. movement)
            send(movement)
        end
    end
end

function nextXpDir()
    xp_path = xp_path or {}

    -- check if there are saved directions for us
    if #xp_path == 0 then
        -- no saved directions, calculate path to next room
        local bestWeight = nil
        for room_id, _ in pairs(xp_visit_time) do
            local hasPath, routeWeight = getPath(current_room, room_id)
            if repopped(room_id) and hasPath then
                -- local route_length = tablelength(speedWalkDir)
                -- local routeWeight = totalWeight
                if bestWeight == nil or routeWeight < bestWeight or #xp_path ==
                    0 then
                    bestWeight = routeWeight
                    xp_path = copySpeedWalkDir()
                end
            end
        end

        -- no more directions, return to waiting room
        if #xp_path == 0 and xp_area.waiting_room and
            getPath(current_room, xp_area.waiting_room) then
            xp_path = copySpeedWalkDir()
        end
    end

    if #xp_path > 0 then
        next_dir = xp_path[1]
        table.remove(xp_path, 1)
        return next_dir
    end

    return nil
end

function visitRoom()
    if xp_helper or xp_health_pause then
        -- make sure the current room shows as visited
        unHighlightRoom(current_room)

        if xp_visit_time[current_room] then
            -- record the time this room was visited last
            xp_visit_time[current_room] = os.time()
        end
    end
end

function copySpeedWalkDir()
    local result = {}
    for i, d in pairs(speedWalkDir) do result[i] = d end
    return result
end
