long_exits = {
    n = "north",
    s = "south",
    se = "southeast",
    sw = "southwest",
    w = "west",
    e = "east",
    nw = "northwest",
    ne = "northeast",
    u = "up",
    d = "down"
}

exitmap = {
    n = 1,
    north = 1,
    ne = 2,
    northeast = 2,
    nw = 3,
    northwest = 3,
    e = 4,
    east = 4,
    w = 5,
    west = 5,
    s = 6,
    south = 6,
    se = 7,
    southeast = 7,
    sw = 8,
    southwest = 8,
    u = 9,
    up = 9,
    d = 10,
    down = 10,
    ["in"] = 11,
    out = 12,
    [1] = "north",
    [2] = "northeast",
    [3] = "northwest",
    [4] = "east",
    [5] = "west",
    [6] = "south",
    [7] = "southeast",
    [8] = "southwest",
    [9] = "up",
    [10] = "down",
    [11] = "in",
    [12] = "out"
}

opposingmap = {
    n = "s",
    ne = "sw",
    nw = "se",
    e = "w",
    w = "e",
    s = "n",
    se = "nw",
    sw = "ne",
    u = "d",
    d = "u",
    ["in"] = "out",
    out = "in",
    [1] = "south",
    [2] = "southwest",
    [3] = "southeast",
    [4] = "west",
    [5] = "east",
    [6] = "north",
    [7] = "northwest",
    [8] = "northeast",
    [9] = "down",
    [10] = "up",
    [11] = "out",
    [12] = "in"
}

function getRelativeCoordinates(room_id, dir)
    local x, y, z = getRoomCoordinates(room_id)

    if dir == "n" then
        y = y + 1
    elseif dir == "ne" then
        y = y + 1
        x = x + 1
    elseif dir == "e" then
        x = x + 1
    elseif dir == "se" then
        y = y - 1
        x = x + 1
    elseif dir == "s" then
        y = y - 1
    elseif dir == "sw" then
        y = y - 1
        x = x - 1
    elseif dir == "w" then
        x = x - 1
    elseif dir == "nw" then
        y = y + 1
        x = x - 1
    elseif dir == "u" or dir == "up" then
        z = z + 1
    elseif dir == "d" or dir == "down" then
        z = z - 1
    end
    return x, y, z
end

function setRelativeCoordinates(room_id, relative_to_room, dir)
    local x, y, z = getRelativeCoordinates(relative_to_room, dir)
    setRoomCoordinates(room_id, x, y, z)
end

function listRooms(room_ids)
    for i, room in pairs(room_ids) do
        name = getRoomName(room)
        echo(name .. " (" .. room .. ")\n")
    end
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function findRoom(room_name)
    if room_name == nil then return nil end
    searched_rooms = searchRoom(room_name)
    potential_rooms = {}
    for i, name in pairs(searched_rooms) do
        if name == room_name then
            potential_rooms[#potential_rooms + 1] = i
        end
    end
    if tablelength(potential_rooms) == 1 then
        --			echo("\nFound a room, centering on it\n")
        return potential_rooms[1]
    end
    return nil
end

function doSpeedWalk()
    echo("Move manually to stop speedwalking.\n")
    echo("Path we need to take: " .. table.concat(speedWalkDir, ", ") .. "\n")
    echo("Rooms we'll pass through: " .. table.concat(speedWalkPath, ", ") ..
             "\n")
    speed_walking = true
    stepWalk()
end

function stepWalk()
    if not next(speedWalkDir) then
        speed_walking = false
        return
    end
    movement = speedWalkDir[1]
    table.remove(speedWalkDir, 1)
    send(movement)
end

function detectAndSetRoomEnvironment(room_id)
    name = getRoomName(room_id)
    selectString(name, 1)
    r, g, b = getFgColor()
    color_id = r * 256 * 256 + g * 256 + b
    environment = getCustomEnvColorTable()[color_id]
    if environment == nil then setCustomEnvColor(color_id, r, g, b, 255) end
    setRoomEnv(room_id, color_id)
end

function onMovement(room_name, direction_string)
    -- check if the current room has been deleted
    if current_room and not roomExists(current_room) then current_room = nil end
    -- display(matches)
    -- room_name = matches[2]
    room_name = room_name:gsub(">", "")
    room_name = room_name:trim()

    -- display(room_name)
    room_name = room_name:trim()
    -- direction_string = matches[3]
    directions = string.split(direction_string, ",")
    -- display(directions)

    if movement then
        if not current_room and auto_mapping then
            -- Start of area
            room_id = createRoomID()
            addRoom(room_id)
            setRoomName(room_id, room_name)
            setRoomArea(room_id, area_id)
            setRoomCoordinates(room_id, 0, 0, 0)
            detectAndSetRoomEnvironment(room_id)
            for i, dir in pairs(directions) do
                normalized_dir = exitmap[dir]
                if normalized_dir == nil then
                elseif normalized_dir >= 1 and normalized_dir <= 10 then
                    setExitStub(room_id, normalized_dir, true)
                end
            end
            current_room = room_id
        elseif not current_room then -- and map_locate then
            current_room = findRoom(room_name)
        elseif current_room then
            -- Try to find an existing room by following the exit from the last room
            current_exits = getRoomExits(current_room)
            -- Check if there are any exits, if not the room is not valid anymore
            --		if not current_exits then
            --			current_room = nil
            --			return
            --		end
            room_id = nil
            for dir, room in pairs(current_exits) do
                if exitmap[dir] == exitmap[movement] then
                    room_id = room
                end
            end
            for dir, room in pairs(getSpecialExitsSwap(current_room)) do
                if dir == movement then room_id = room end
            end
            if room_id == nil and auto_mapping then
                -- No room found when moving that direction, is it a normal move?
                if exitmap[movement] ~= nil then
                    -- try to find one at the coordinates
                    x, y, z = getRelativeCoordinates(current_room, movement)
                    potential_rooms = getRoomsByPosition(getRoomArea(
                                                             current_room), x,
                                                         y, z)
                    if potential_rooms[0] ~= nil and
                        getRoomName(potential_rooms[0]) == room_name then
                        room_id = potential_rooms[0]
                    end
                end
                if room_id == nil then
                    room_id = createRoomID()
                    addRoom(room_id)
                    setRoomName(room_id, room_name)
                    setRoomArea(room_id, area_id)
                    setRelativeCoordinates(room_id, current_room, movement)
                    detectAndSetRoomEnvironment(room_id)
                    -- new room, create stubs
                    for i, dir in pairs(directions) do
                        normalized_dir = exitmap[dir]
                        if normalized_dir == nil then
                        elseif normalized_dir >= 1 and normalized_dir <= 10 then
                            setExitStub(room_id, exitmap[dir], true)
                        end
                    end
                end
                if exitmap[movement] ~= nil then
                    coming_from = opposingmap[movement]
                    for i, dir in pairs(directions) do
                        if coming_from == dir then
                            setExit(room_id, current_room, exitmap[coming_from])
                        end
                    end
                    -- Connect with the room we came from
                    setExit(current_room, room_id, exitmap[movement])
                else
                    addSpecialExit(current_room, room_id, movement)
                end
            elseif room_id then
                -- There was a room, but are we really there?
                found_room_name = getRoomName(room_id)
                if room_name ~= found_room_name and not xp_helper and
                    not string.starts(room_name, "There are ") then
                    echo(
                        "Not in the expected room, trying to find the right room...\n")
                    room_id = findRoom(room_name)
                end
            end
            -- And remember that we moved
            current_room = room_id
        end
    elseif current_room == nil or getRoomName(current_room) ~= room_name then
        -- No known room and we're not moving, a glance or login happend, or the room name was not correct
        -- could also be a special move
        current_room = findRoom(room_name)
    end

    -- echo("\n")
    -- echo("Area: " .. area .. "\n")
    -- echo("Room: " .. room_name .. "\n")
    -- echo("Directions: " .. direction_string .. "\n")

    -- display(directions)

    movement = nil
    if current_room then
        --	detectAndSetRoomEnvironment(current_room)
        centerview(current_room)
        if auto_mapping then echo("(" .. current_room .. ")") end
        if speed_walking then stepWalk() end
        if xp_helper or fleeing then
            --		xp_timer = tempTimer(2, stepXp)
            stepXp()
        end
    end
    -- display(current_room)

end
