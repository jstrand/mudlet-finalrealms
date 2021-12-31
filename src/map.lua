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
        local name = getRoomName(room)
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
    local searched_rooms = searchRoom(room_name)
    local potential_rooms = {}
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

function findRoomByNum(roomNum)
    local foundRooms = searchRoomUserData("num", roomNum)
    if #foundRooms == 1 then return foundRooms[1] end
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
    local name = getRoomName(room_id)
    local selectResult = selectString(name, 1)
    if selectResult < 0 then return end
    local r, g, b = getFgColor()
    local color_id = r * 256 * 256 + g * 256 + b
    local environment = getCustomEnvColorTable()[color_id]
    if environment == nil then setCustomEnvColor(color_id, r, g, b, 255) end
    setRoomEnv(room_id, color_id)
end

function onBriefDescription(room_name)
    local room_name = room_name:gsub(">", "")
    room_name = room_name:trim()

    handleRoom(room_name)
end

-- Main entry into feeding the mapper with the current position
-- brief description is only used to get colors and to handle rooms
-- in the map without a gmcp "num"
function onGmcpRoomChange() handleRoom(gmcp.Room.Info.name) end

function verifyRoom(room_name, room_id)
    -- There was a room, but are we really there?
    local roomNum = getRoomNumber(room_id)
    if roomNum == gmcp.Room.Info.num then
        return room_id
    else
        local foundRoom = findRoomByNum(gmcp.Room.Info.num)
        if foundRoom ~= nil then return foundRoom end
    end

    local found_room_name = getRoomName(room_id)
    if room_name ~= found_room_name and not xp_helper and
        not string.starts(room_name, "There are ") then
        echo("Not in the expected room, trying to find the right room...\n")
        return findRoom(room_name)
    end

    return room_id
end

function addExits(room_id)
    for exitDirection, exitToRoomNum in pairs(gmcp.Room.Info.exits) do
        local exitToExistingRoomId = findRoomByNum(exitToRoomNum)
        if exitToExistingRoomId then
            if exitmap[exitDirection] ~= nil then
                -- Try to reach out to any stubs on the other side
                setExitStub(room_id, exitDirection, true)
                connectExitStub(room_id, exitToExistingRoomId)
            else
                addSpecialExit(room_id, exitToExistingRoomId, exitDirection)
            end
        elseif exitmap[exitDirection] ~= nil then
            setExitStub(room_id, exitDirection, true)
        end
    end
end

function createRoom()
    local room_id = createRoomID()
    addRoom(room_id)
    setRoomArea(room_id, area_id)
    setRoomUserData(room_id, "num", gmcp.Room.Info.num)
    setRoomName(room_id, gmcp.Room.Info.name)
    addExits(room_id)
    return room_id
end

function tryCreateFirstRoomInArea()
    local rooms = getAreaRooms(area_id)
    if #rooms > 0 then
        echo("There are already rooms in the area," ..
                 " please move to one of them to let the mapper know where you are.\n")
        return
    end
    local movedToRoomId = createRoom()
    setRoomCoordinates(movedToRoomId, 0, 0, 0)
    return movedToRoomId
end

function getRoomNumber(roomId)
    if roomId == nil then return nil end
    local num, _ = getRoomUserData(roomId, "num", true)
    if not num then return nil end
    return tonumber(num)
end

function setRoomNumber(roomId, roomNumber)
    setRoomUserData(roomId, "num", roomNumber)
end

function handleMovement(room_name, movement)
    if not current_room and auto_mapping then
        return tryCreateFirstRoomInArea()
    elseif not current_room then
        return findRoomByNum(gmcp.Room.Info.num) or findRoom(room_name)
    elseif current_room then
        local movedToRoomId = findRoomByNum(gmcp.Room.Info.num)

        -- Try to find an existing room by following the exit from the last room
        if movedToRoomId == nil then
            local current_exits = getRoomExits(current_room)
            for dir, room in pairs(current_exits) do
                if exitmap[dir] == exitmap[movement] then
                    movedToRoomId = room
                end
            end
            for dir, room in pairs(getSpecialExitsSwap(current_room)) do
                if dir == movement then movedToRoomId = room end
            end
        end
        if movedToRoomId == nil and auto_mapping then
            movedToRoomId = createRoom()
            setRelativeCoordinates(movedToRoomId, current_room, movement)
        elseif movedToRoomId then
            movedToRoomId = verifyRoom(room_name, movedToRoomId)
        end

        if auto_mapping then
            if exitmap[movement] ~= nil then
                coming_from = opposingmap[movement]
                for exitDirection, exitToRoomNum in pairs(gmcp.Room.Info.exits) do
                    if coming_from == exitDirection and
                        not getRoomExits(movedToRoomId)[long_exits[exitDirection]] then
                        setExit(movedToRoomId, current_room,
                                exitmap[coming_from])
                    end
                end
                -- Connect with the room we came from
                setExit(current_room, movedToRoomId, exitmap[movement])
            else
                addSpecialExit(current_room, movedToRoomId, movement)
            end
        end

        -- And remember that we moved
        return movedToRoomId
    end
end

function handleRoom(room_name)

    if not gmcp.Room then
        send("gmcp on")
        return
    end

    -- check if the current room has been deleted
    if current_room and not roomExists(current_room) then current_room = nil end

    if gmcp.Room.Info.num == getRoomNumber(current_room) then
        -- Most probably here because of a brief description when gmcp has already put us in the right room
        -- use the brief description to set the color of the room as gmcp doesn't include color
        if auto_mapping then
            detectAndSetRoomEnvironment(current_room)
            echo("(" .. current_room .. ")")
        end
        return
    end

    if movement then
        current_room = handleMovement(room_name, movement)
        movement = nil
    elseif current_room == nil or getRoomName(current_room) ~= room_name then
        -- No known room and we're not moving, a glance or login happend, or the room name was not correct
        -- could also be a special move
        current_room = findRoomByNum(gmcp.Room.Info.num) or findRoom(room_name)
    end

    if current_room then
        centerview(current_room)

        local num = getRoomNumber(current_room)
        if not num and gmcp.Room.Info.num > 0 then
            setRoomNumber(current_room, gmcp.Room.Info.num)
        end

        if speed_walking then stepWalk() end
        if xp_helper or fleeing then stepXp() end
    end
end

function getFinalRealmsMapPath() return FR.getModuleLocation() .. "map.json" end

function loadFinalRealmsMap()
    local mapPath = getFinalRealmsMapPath()

    echo("Loading map from " .. mapPath .. "\n")
    if loadJsonMap(mapPath) then
        echo("OK" .. "\n")
    else
        echo("Failed!" .. "\n")
    end
end

function saveFinalRealmsMap()
    local mapPath = getFinalRealmsMapPath()

    echo("Saving map to " .. mapPath .. "\n")
    if saveJsonMap(mapPath) then
        echo("OK" .. "\n")
    else
        echo("Failed!" .. "\n")
    end
end
