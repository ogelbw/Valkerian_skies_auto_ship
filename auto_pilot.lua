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


local f = fs.open(args[1]..".coords")
target = fs.readAll()
f.close()
target = split(target, ",")
target = {
    ['x']   = target[1],
    ['y']   = target[2],
    ['z']   = target[3],
    ['yaw'] = target[4]
}

rot_error = math.atan2(target.z, target.pos.x)

while true do
    local pos = ship_reader.getWorldspacePosition()
    local error = {
        ['x']   = target.x - pos.x,
        ['y']   = target.y - pos.y,
        ['z']   = target.z - pos.z,
        ['yaw'] = math.atan2(target.z - pos.z, target.x - pos.x)
    }

    if error.yaw < 0 then
        helm.move('left', true)
        helm.move('right', false)
    else
        helm.move('left', false)
        helm.move('right', true)
    end
end
