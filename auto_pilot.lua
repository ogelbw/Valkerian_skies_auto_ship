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

print("going to "..target.x.." "..target.z)

while true do
    local pos = ship_reader.getWorldspacePosition()
    local rot = ship_reader.getRotation()
    
    if (pos.x > 0 and pos.z > 0) or ((pos.x < 0 and pos.z < 0)) then 
        sign = -1
    else
        sign = 1
    end

    local err = {
        ['x']   = pos.x - target.x ,
        ['y']   = pos.y - target.y ,
        ['z']   = pos.z - target.z ,
        ['yaw'] = math.atan2(pos.x - target.x, pos.z - target.z ) - (rot.roll*sign) -- mod has this mislabeled
    }


    -- if (math.abs(err.yaw) < math.pi/2) and (math.abs(err.x) + math.abs(err.z)) > 10 then
    --     helm.move("forward", true)
    -- elseif (err.x + err.z) < 10 then
    --     helm.move("forward", false)
    --     helm.resetAllMovement()
    -- else
    --     helm.move("forward", false)

    -- end

    -- if (math.abs(err.yaw) > 0.1) and (math.abs(err.yaw) < (math.pi - 0.1)) then
    if (err.yaw* sign) > 0 then
        helm.move('right', false)
        helm.move('left', true)
    else
        helm.move('left', false)
        helm.move('right', true)
    end
    print(err.yaw)
    -- else
    --     helm.move('left', false)
    --     helm.move('right', false)
    -- end
    

    sleep(0.1)
end
