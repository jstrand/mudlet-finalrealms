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
