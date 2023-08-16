-- updating starting script if needed
res = http.get("https://raw.githubusercontent.com/ogelbw/Valkerian_skies_auto_ship/main/startup.lua")

if res ~= nil then
    start_up_script = res.readAll()

    if fs.exists("startup.lua") then
        startup_on_disk = fs.open("startup.lua", "r")

        if startup_on_disk.readAll() ~= start_up_script then
            startup_on_disk.close()
            fs.delete("startup.lua")
            f = fs.open("startup.lua", "w")
            f.write(start_up_script)
            f.close()
            print("updated start script.")
            shell.run("startup")
        end
    end
end

function update_script(script_name)
    res = http.get("https://raw.githubusercontent.com/ogelbw/Valkerian_skies_auto_ship/main/"..script_name..".lua")

    if res ~= nil then
        git_script = res.readAll()

        if fs.exists(script_name..".lua") then
            script_on_disk = fs.open(script_name..".lua", "r")

            if script_on_disk.readAll() == git_script then script_on_disk.close(); return 0 end
            script_on_disk.close()
            fs.delete(script_name..".lua")
        end

        f = fs.open(script_name..".lua", "w")
        f.write(git_script)
        f.close()
        print("updated "..script_name.." script.")
    end
end

update_script("auto_pilot")
update_script("save_location")
