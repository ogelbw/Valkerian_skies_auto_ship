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
    local err = {
        ['x']   = target.x - pos.x,
        ['y']   = target.y - pos.y,
        ['z']   = target.z - pos.z,
        ['yaw'] = math.atan2(target.z - pos.z, target.x - pos.x - rot.roll) -- mod has this mislabeled
    }

    if err.yaw > math.pi then
        err.yaw = (-2*math.pi) + err.yaw
    elseif err.yaw < -math.pi then
        err.yaw = 2*math.pi + err.yaw
    end

    if err.yaw > 0.1 or err.yaw < -0.1 then
        if err.yaw < 0 then
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
end
