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
        sign = 1
    else
        sign = -1
    end
    
    
    local err = {
        ['x']   = pos.x - target.x ,
        ['y']   = pos.y - target.y ,
        ['z']   = pos.z - target.z ,
        ['yaw'] = math.atan2(target.x - pos.x, target.z - pos.z ) - (rot.roll*sign) -- mod has this mislabeled
    }
    

    local yawDiff = err.yaw
    if yawDiff > math.pi then
        yawDiff = yawDiff - 2*math.pi
    elseif yawDiff < -math.pi then
        yawDiff = yawDiff + 2*math.pi
    end

    if (math.abs(yawDiff) > math.pi/2) and (math.abs(err.x) + math.abs(err.z)) > 10 then
        helm.move("forward", true)
    else 
        helm.move("forward", false)
    end

    if (math.abs(yawDiff) > (math.pi - 0.1)) then
        helm.move('left', false)
        helm.move('right', false)
    else
        if (yawDiff) < 0 then
            helm.move('right', false)
            helm.move('left', true)
        else
            helm.move('left', false)
            helm.move('right', true)
        end
    end
    print(err.yaw)
    

    sleep(0.1)
end
