helm = peripheral.wrap("right")
ship_reader = peripheral.wrap("bottom")

print("Github script loaded")

while true do
    term.clear()
    print("x " .. ship_reader.getWorldspacePosition().x)
    print("y " .. ship_reader.getWorldspacePosition().y)
    print("z " .. ship_reader.getWorldspacePosition().z)
    sleep(0.5)
end
