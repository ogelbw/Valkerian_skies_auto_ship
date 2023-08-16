args = {...}

local ship_data = peripheral.wrap("bottom")
coords = ship_data.getWorldspacePosition()

if fs.exists(args[1]..".coords") then
    fs.delete(args[1]..".coords")
end

local f = fs.open(args[1], "w")
f.write(coords.x..',')
f.write(coords.y..',')
f.write(coords.z..',')
f.write(ship_data.getRotation().yaw)