// -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Linventif Library
// -- // -- // -- // -- // -- // -- // -- // -- // -- //
if !LinvLib then
    print(" ")
    print(" ")
    print(" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    print(" -                                                           - ")
    print(" -               Linventif Library is missing !              - ")
    print(" -                                                           - ")
    print(" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    print(" ")
    print("Linventif Library is missing ! Please install it !")
    print(" ")
    print("You can download the latest version here : https://linventif.fr/gmod-lib")
    print("Or you can download it directly from the github : https://github.com/linventif/gmod-lib")
    print("Or you can download it directly from the workshop : https://steamcommunity.com/sharedfiles/filedetails/?id=2882747990")
    print("If you don't know how to install it, please read the documentation : https://linventif.fr/gmod-lib-doc")
    print("If you have any questions, you can join my discord : https://linventif.fr/discord")
    print("If you don't download it, you won't be able to use some scripts.")
    print(" ")
    print(" ")
    return
end

// -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Load Variables
// -- // -- // -- // -- // -- // -- // -- // -- // -- //

local folder = "one_hud"
local name = "One HUD"
local full_name = "One HUD"
local workshop = {}
local license = "CC BY-SA 4.0"
local version = 1.0
OneHud = {}
OneHud.Hud = {} or OneHud.Hud

// -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Print Console Informations
// -- // -- // -- // -- // -- // -- // -- // -- // -- //

LinvLib.LoadStr(full_name, version, license)

// -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Create Dir Data - Load Configurations & Language
// -- // -- // -- // -- // -- // -- // -- // -- // -- //

include(folder .. "/sh_config.lua")
//include(folder .. "/languages/" .. OneHud.Language .. ".lua")

if SERVER then
    AddCSLuaFile(folder .. "/sh_config.lua")
    if not file.Exists(folder, "DATA") then
        file.CreateDir(folder)
    end
    if workshop != {} then
        for k, v in pairs(workshop) do
            resource.AddWorkshop(v)
            print("| " .. name .. " | Add Workshop | " .. workshop)
        end
    end
    //AddCSLuaFile(folder .. "/languages/" .. OneHud.Language .. ".lua")
end

print("| " .. name .. " | File Load | " .. folder .. "/sh_config.lua")
//print("| " .. name .. " | File Load | " .. folder .. "/languages/" .. OneHud.Language .. ".lua")

// -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Load All Files
// -- // -- // -- // -- // -- // -- // -- // -- // -- //
local function Loader(folder, name)
    local files, folders = file.Find(folder .. "/*", "LUA")
    for k, v in pairs(files) do
        local path = folder .. "/" .. v
        local cantLoad = false
        if string.StartWith(v, "cl_") then
            print("| " .. name .. " | File Load | " .. path)
            if SERVER then
                AddCSLuaFile(path)
            else
                include(path)
            end
        elseif string.StartWith(v, "sv_") then
            print("| " .. name .. " | File Load | " .. path)
            if SERVER then
                include(path)
            end
        elseif string.StartWith(v, "sh_") then
            print("| " .. name .. " | File Load | " .. path)
            if SERVER then
                AddCSLuaFile(path)
            end
            include(path)
        else
            print("| " .. name .. " | - Error - | File Name Invalid : " .. path)
        end
    end
    for k, v in pairs(folders) do
        loadFiles(folder .. "/" .. v)
    end
end
Loader(folder .. "/shared", name)
Loader(folder .. "/server", name)
Loader(folder .. "/client", name)

print(" ")
print(" ")