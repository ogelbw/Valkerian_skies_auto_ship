helm = peripheral.wrap("right")
ship_reader = peripheral.wrap("bottom")
args = {...}

function split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end


local f = fs.open(args[1]..".coords", "r")
target = f.readAll()
f.close()
target = split(target, ",")
target = {
    ['x']   = target[1],
    ['y']   = target[2],
    ['z']   = target[3],
    ['yaw'] = target[4]
}

while true do
    local pos = ship_reader.getWorldspacePosition()
    local rot = ship_reader.getRotation()
    if (pos.x - target.x) == 0 then
        yaw = math.pi/2
    else
        yaw = math.atan((pos.z - target.z) / (pos.x - target.x) ) - rot.roll
    end

    local err = {
        ['x']   = pos.x - target.x ,
        ['y']   = pos.y - target.y ,
        ['z']   = pos.z - target.z ,
        ['yaw'] = math.atan2(pos.z - target.z, pos.x - target.x ) - rot.roll -- mod has this mislabeled
    }

    if (pos.x > 0 and pos.z > 0) or ((pos.x < 0 and pos.z < 0)) then 
        sign = 1
    else
        sign = -1
    end

    if err.yaw > math.pi then
        err.yaw = (-2*math.pi) + err.yaw
    elseif err.yaw < -math.pi then
        err.yaw = 2*math.pi + err.yaw
    end

    if (err.yaw > -math.pi/2 or err.yaw < math.pi/2) and (math.abs(err.x) + math.abs(err.z)) > 10 then
        helm.move("forward", true)
    elseif (err.x + err.z) < 10 then
        helm.move("forward", false)
        helm.resetAllMovement()
    else
        helm.move("forward", false)

    end

    if (err.yaw * sign) > 0.1 or (err.yaw * sign) < -0.1 then
        if err.yaw > 0 then
            helm.move('right', false)
            helm.move('left', true)
        else
            helm.move('left', false)
            helm.move('right', true)
        end
    else
        helm.move('left', false)
        helm.move('right', false)
    end

    sleep(0.1)
end
