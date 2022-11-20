-- no
/*
local allowgroup = {
    ["vip"] = true,
    ["admin"] = true,
    ["superadmin"] = true
}

local weps = {
    "weapon_physgun",
    "gmod_tool",
    "weapon_physcannon",
    "weapon_crowbar",
    "weapon_stunstick",
}

hook.Add("PlayerSpawn", "SpawnProtection", function(ply)
    if allowgroup[ply:GetUserGroup()] then
        for k, v in pairs(weps) do
            ply:Give(v)
        end
    end
end)

hook.Add("DropWeapon", "SpawnProtection", function(ply, wep)
    if allowgroup[ply:GetUserGroup()] && weps[wep:GetClass()] then
        return false
    end
end)
*/