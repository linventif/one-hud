local icons = {
    ["health"]  =   Material("one_hud/health.png"),
    ["shield"]  =   Material("one_hud/shield.png"),
    ["team"]    =   Material("one_hud/team.png"),
    ["wallet"]  =   Material("one_hud/wallet.png"),
    ["food"]    =   Material("one_hud/food.png"),
    ["ammo"]    =   Material("one_hud/ammo.png"),
    ["ping"]    =   Material("one_hud/ping.png"),
    ["level"]   =   Material("one_hud/level.png"),
    ["name"]    =   Material("one_hud/name.png"),
    ["rank"]    =   Material("one_hud/rank.png"),
    ["group"]   =   Material("one_hud/group.png"),
    ["props"]   =   Material("one_hud/props.png"),
    ["ammo"]    =   Material("one_hud/ammo.png"),
    ["speammo"] =   Material("one_hud/spe_ammo.png"),
    ["weapon"]  =   Material("one_hud/weapon.png"),
    ["talk"]    =   Material("one_hud/talk.png"),
}

surface.CreateFont("OneHUDFont", {
	font = OneHud.Config.TextFont,
	extended = false,
	size = OneHud.Config.TextSize,
	weight = 500,
})

function OneHud:RespX(x)
    if OneHud.Config.Responsive then
        return x/1920*ScrW()
    else
        return x
    end
end

function OneHud:RespY(y)
    if OneHud.Config.Responsive then
        return y/1080*ScrH()
    else
        return y
    end
end

function OneHud:Resp(x, y)
    if OneHud.Config.Responsive then
        return x/1920*ScrW(), y/1080*ScrH()
    else
        return x, y
    end
end

local function GetPos(element, SpWeRi, SpWeLe, SpHeRi, SpHeLe)
    local iconspace = 0
    if OneHud.Config.Icon then
        iconspace = 34
    end
    local x, y = 0, 0
    if element == "left" then
        x = 40 + SpWeLe
        y = 1080 - 80 - SpHeLe
    elseif element == "right" then
        x = 1920 - 340 - SpWeRi - iconspace
        y = 1080 - 80 - SpHeRi
    end
    return x, y
end

local function NewSpace(element, SpWeRi, SpWeLe, SpHeRi, SpHeLe)
    if element == "left" then
        SpHeLe = SpHeLe + 40 + OneHud.Config.HeightSpacing
    elseif element == "right" then
        SpHeRi = SpHeRi + 40 + OneHud.Config.HeightSpacing
    end
    return SpWeRi, SpWeLe, SpHeRi, SpHeLe
end

local function MvIcon(element, id)
    local rtn = 0
    if OneHud.Config.Icon then
        if OneHud.Config.Possition[element] == "left" then
            if id == 1 then
                rtn = 0
            else
                rtn = 34
            end
        elseif OneHud.Config.Possition[element] == "right" then
            if id == 1 then
                rtn = 300-6
            elseif id == 2 then
                rtn = 0
            else
                rtn = 34
            end
        end
    else
        if OneHud.Config.Possition[element] == "left" then
            rtn = 0
        elseif OneHud.Config.Possition[element] == "right" then
            rtn = 0
        end
    end
    return rtn
end

local function Smooth(smooth, val, max)
    smooth = Lerp(FrameTime() * 6, smooth, val / max)
    return smooth
end

local function AddBar(v, r, x, y, w, h, c)
    surface.SetDrawColor(c)
    if r then
        surface.DrawRect(x+(300-12)-w, y, w, h)
    else
        surface.DrawRect(x, y, w, h)
    end
end

local function AddText(x, y, t, force, aling)
    if aling == 0 then
        aling = TEXT_ALIGN_LEFT
    elseif aling == 1 then
        aling = TEXT_ALIGN_CENTER
    elseif aling == 2 then
        aling = TEXT_ALIGN_RIGHT
    end
    if OneHud.Config.Text || OneHud.Config.AlwayText[force] then
        draw.SimpleTextOutlined(t, "OneHUDFont", x, y, OneHud.Config.TextColor, aling, TEXT_ALIGN_CENTER, 0, Color(0, 0, 0, 255))
    end
end

local function ShowMaxValue(p1, p2)
    if OneHud.Config.MaxValue then
        return p1
    else
        return p1 .. p2
    end
end

local function AddIcon(x, y, icon, color)
    if OneHud.Config.Icon then
        surface.SetMaterial(icon)
        surface.SetDrawColor(color)
        surface.DrawTexturedRect(x, y, 28, 28)
    end
end

local smHealth, smArmor, smAmmo, smFood, smLevel, smProps, ping, pingcd = 0, 0, 0, 0, 0, 0, 0, 0

hook.Add("HUDPaint", "HUDPaint", function()
    if OneHud.Config.FontLiveTest then
        surface.CreateFont("OneHUDFont", {
            font = OneHud.Config.TextFont,
            extended = false,
            size = OneHud.Config.TextSize,
            weight = 500,
        })
    end

    if !LocalPlayer():Alive() || !IsValid(LocalPlayer()) then return end

    local ply = LocalPlayer()
    local group = ply:GetUserGroup() or "user"
    local name = ply:Nick() or "Unknown"

    if pingcd < CurTime() then
        ping = LocalPlayer():Ping() or 0
        pingcd = CurTime() + OneHud.Config.PingRefrech
    end

    if ping < OneHud.Config.PingGood then
        OneHud.Config.PingColor = OneHud.Config.PingColorGood
    elseif ping > OneHud.Config.PingGood && ping < OneHud.Config.PingBad then
        OneHud.Config.PingColor = OneHud.Config.PingColorMedium
    else
        OneHud.Config.PingColor = OneHud.Config.PingColorBad
    end

    local health = math.Clamp(ply:Health(), 0, ply:GetMaxHealth()) or 0
    local maxhealth = ply:GetMaxHealth() or 100
    local armor = math.Clamp(ply:Armor(), 0, ply:GetMaxArmor()) or 0
    local maxarmor = ply:GetMaxArmor() or 100
    local props = ply:GetCount("props") or 0
    local maxprops = ply:GetNWInt("props_max") or -1
    if maxprops == 0 then maxprops = -1 end

    local salary = "" .. ply:getDarkRPVar("salary") or "ERROR"
    local food = ply:getDarkRPVar("Energy") or 100
    local wanted = ply:getDarkRPVar("wanted") or 0
    local level = 0
    local nexlvl = 0
    if LevelSystemConfiguration then
        level = ply:getDarkRPVar("level") or 0
        nexlvl = math.Round((ply:getDarkRPVar("xp") or 0) / (((10 + (((ply:getDarkRPVar("level") or 1)*((ply:getDarkRPVar("level") or 1)+1)*90))))*LevelSystemConfiguration.XPMult), 2)
    elseif GlorifiedLeveling then
        level = GlorifiedLeveling.GetPlayerLevel(ply) or 0
        nexlvl = math.Round((GlorifiedLeveling.GetPlayerXP(ply) or 0) / (GlorifiedLeveling.GetPlayerMaxXP(ply) or 1))
    end

    local money = "" .. ply:getDarkRPVar("money") or "ERROR"
    local monlen = string.len(money)
    local moneystr = ""
    for i = 1, monlen do
        if i % 3 == 0 then
            moneystr = OneHud.Config.MoneySeparator .. string.sub(money, monlen - i + 1, monlen - i + 1) .. moneystr
        else
            moneystr = string.sub(money, monlen - i + 1, monlen - i + 1) .. moneystr
        end
    end
    money = moneystr
    if OneHud.Config.MoneyLeft then
        money = OneHud.Config.MoneySymbol .. money
        salary = OneHud.Config.MoneySymbol .. salary
    else
        money = money .. OneHud.Config.MoneySymbol
        salary = salary .. OneHud.Config.MoneySymbol
    end
    if OneHud.Config.Salary then
        money = money .. " + " .. salary
    end

    local teamcolor = team.GetColor(ply:Team()) or Color(255, 255, 255, 255)
    local teamname = team.GetName(ply:Team()) or "ERROR"

    local wep = ply:GetActiveWeapon() or "ERROR"
    local wepclass = wep:GetClass() or "ERROR"
    local wepname = OneHud.Config.WepsName[wepclass] or wep:GetPrintName()
    local ammo = ply:GetAmmoCount(wep:GetPrimaryAmmoType()) or 0
    local magammo = wep:Clip1() or 0
    local maxammo = wep:GetMaxClip1() or 0
    local ammo2 = ply:GetAmmoCount(wep:GetSecondaryAmmoType()) or 0

    local SpHeRi = 0
    local SpWeRi = 0
    local SpHeLe = 0
    local SpWeLe = 0

    if OneHud.Config.Theme == "Flat" then
        for k, v in SortedPairs(OneHud.Config.Order, true) do
            if v == "Money" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.TextBackColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156), OneHud:RespY(posy+20), money, v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.wallet, OneHud.Config.IconColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Team" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.TextBackColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), teamname, v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.team, OneHud.Config.IconColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Name" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.TextBackColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), name, v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.name, OneHud.Config.IconColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Group" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.TextBackColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), OneHud.Config.Groups[group], v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.group, OneHud.Config.IconColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Weapon" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.TextBackColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), wepname, v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.weapon, OneHud.Config.IconColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Health" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.HealthBackColor)
                smHealth = Smooth(smHealth, health, maxhealth)
                AddBar(v, true, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), math.Clamp(smHealth * OneHud:RespX(288), 0, OneHud:RespX(288)), OneHud:RespY(40-12), OneHud.Config.HealthColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), ShowMaxValue(math.Round(smHealth * maxhealth), " / " .. maxhealth), v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.health, OneHud.Config.HealthColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Food" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.FoodBackColor)
                smFood = Smooth(smFood, food, 100)
                AddBar(v, true, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), math.Clamp(smFood * OneHud:RespX(288), 0, OneHud:RespX(288)), OneHud:RespY(40-12), OneHud.Config.FoodColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), ShowMaxValue(math.Round(smFood * 100)," / 100"), v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.food, OneHud.Config.FoodColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Armor" && (OneHud.Config.ArmorWhenNone || armor > 0 ) then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.ArmorBackColor)
                smArmor = Smooth(smArmor, armor, maxarmor)
                AddBar(v, true, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), math.Clamp(smArmor * OneHud:RespX(288), 0, OneHud:RespX(288)), OneHud:RespY(40-12), OneHud.Config.ArmorColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), ShowMaxValue(math.Round(smArmor * maxarmor)," / " .. maxarmor), v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.shield, OneHud.Config.ArmorColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Props" && (OneHud.Config.PropsWhenNone || props > 0 ) then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.PropsBackColor)
                smProps = Smooth(smProps, props, maxprops)
                AddBar(v, true, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), math.Clamp(smProps * OneHud:RespX(288), 0, OneHud:RespX(288)), OneHud:RespY(40-12), OneHud.Config.PropsColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), ShowMaxValue(math.Round(smProps * maxprops), " / " .. maxprops), v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.props, OneHud.Config.PropsColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Level" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.LevelBackColor)
                smLevel = Smooth(smLevel, nexlvl, 1)
                AddBar(v, true, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), math.Clamp(smLevel * OneHud:RespX(288), 0, OneHud:RespX(288)), OneHud:RespY(40-12), OneHud.Config.LevelColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), ShowMaxValue(level, " - " .. nexlvl*100 .. "%"), v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.level, OneHud.Config.LevelColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Ammo" && !OneHud.Config.HideAmmoWeps[wepclass] && magammo != -1 then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.AmmoBackColor)
                smAmmo = Smooth(smAmmo, magammo, maxammo)
                AddBar(v, true, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), math.Clamp(smAmmo * OneHud:RespX(288), 0, OneHud:RespX(288)), OneHud:RespY(40-12), OneHud.Config.AmmoColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), magammo .. " / " .. maxammo .. " - " .. ammo, v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.ammo, OneHud.Config.AmmoColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Special Ammo" && (OneHud.Config.SpeAmmoWhenNone || ammo2 > 0) then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.SpeAmmoBackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), math.Clamp(ammo2, 0, 1)*OneHud:RespX(288), OneHud:RespY(40-12), OneHud.Config.SpeAmmoColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), math.Clamp(ammo2, 0, 1) .. " / 1 - " .. math.Clamp(ammo2-1, 0, 9999), v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.speammo, OneHud.Config.SpeAmmoColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            end
        end
    elseif OneHud.Config.Theme == "Flat Bar" then
        AddBar(v, false, OneHud:RespX(0), OneHud:RespY(1080-40-OneHud.Config.HeightSpacing ), OneHud:RespX(1920), OneHud:RespY(40+OneHud.Config.HeightSpacing ), OneHud.Config.BackColor)
        if OneHud.Config.FlatBarMessage then
            AddText(OneHud:RespX(1920-string.len(OneHud.Config.FlatBarMessage)), OneHud:RespY(1080-20-OneHud.Config.HeightSpacingFlatBar/2), OneHud.Config.FlatBarMessage, "FlatBarMessage", 2)
        end
        local posx, posy = SpWeLe+20, 1080-40 - OneHud.Config.HeightSpacingFlatBar / 2
        SpWeLe = SpWeLe + 20
        SpHeRi = SpHeRi + 40 + OneHud.Config.HeightSpacingFlatBar
        SpHeRi = SpHeLe + 40 + OneHud.Config.HeightSpacingFlatBar
        for k, v in SortedPairs(OneHud.Config.Order) do
            if v == "Money" then
                AddIcon(OneHud:RespX(SpWeLe), OneHud:RespY(posy+6), icons.wallet, OneHud.Config.IconColor)
                SpWeLe = SpWeLe + 45
                AddText(OneHud:RespX(SpWeLe),OneHud:RespY(posy+20), money, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(money) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Team" then
                AddIcon(OneHud:RespX(SpWeLe), OneHud:RespY(posy+6), icons.team, OneHud.Config.IconColor)
                SpWeLe = SpWeLe + 45
                AddText(OneHud:RespX(SpWeLe),OneHud:RespY(posy+20), teamname, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(teamname) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Name" then
                AddIcon(OneHud:RespX(SpWeLe), OneHud:RespY(posy+6), icons.name, OneHud.Config.IconColor)
                SpWeLe = SpWeLe + 45
                AddText(OneHud:RespX(SpWeLe),OneHud:RespY(posy+20), name, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(name) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Group" then
                AddIcon(OneHud:RespX(SpWeLe), OneHud:RespY(posy+6), icons.group, OneHud.Config.IconColor)
                SpWeLe = SpWeLe + 45
                AddText(OneHud:RespX(SpWeLe),OneHud:RespY(posy+20), OneHud.Config.Groups[group], v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(OneHud.Config.Groups[group]) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Weapon" then
                AddIcon(OneHud:RespX(SpWeLe), OneHud:RespY(posy+6), icons.weapon, OneHud.Config.IconColor)
                SpWeLe = SpWeLe + 45
                AddText(OneHud:RespX(SpWeLe),OneHud:RespY(posy+20), wepname, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(wepname) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Health" then
                AddIcon(OneHud:RespX(SpWeLe), OneHud:RespY(posy+6), icons.health, OneHud.Config.HealthColor)
                SpWeLe = SpWeLe + 45
                smHealth = Smooth(smHealth, health, maxhealth)
                local txt = ShowMaxValue(math.Round(smHealth * maxhealth), " / " .. maxhealth)
                AddText(OneHud:RespX(SpWeLe),OneHud:RespY(posy+20), txt, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(txt) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Food" then
                AddIcon(OneHud:RespX(SpWeLe), OneHud:RespY(posy+6), icons.food, OneHud.Config.FoodColor)
                SpWeLe = SpWeLe + 45
                smFood = Smooth(smFood, food, 100)
                local txt = ShowMaxValue(math.Round(smFood), " / 100")
                AddText(OneHud:RespX(SpWeLe),OneHud:RespY(posy+20), txt, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(txt) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Armor" && (OneHud.Config.ArmorWhenNone || armor > 0 ) then
                AddIcon(OneHud:RespX(SpWeLe), OneHud:RespY(posy+6), icons.shield, OneHud.Config.ArmorColor)
                SpWeLe = SpWeLe + 45
                smArmor = Smooth(smArmor, armor, maxarmor)
                local txt = ShowMaxValue(math.Round(smArmor * maxarmor), " / " .. maxarmor)
                AddText(OneHud:RespX(SpWeLe),OneHud:RespY(posy+20), txt, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(txt) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Props" && (OneHud.Config.PropsWhenNone || props > 0 ) then
                AddIcon(OneHud:RespX(SpWeLe), OneHud:RespY(posy+6), icons.props, OneHud.Config.PropsColor)
                SpWeLe = SpWeLe + 45
                smProps = Smooth(smProps, props, maxprops)
                local txt = ShowMaxValue(math.Round(smProps * maxprops), " / " .. maxprops)
                AddText(OneHud:RespX(SpWeLe),OneHud:RespY(posy+20), txt, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(txt) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Level" then
                AddIcon(OneHud:RespX(SpWeLe), OneHud:RespY(posy+6), icons.level, OneHud.Config.LevelColor)
                SpWeLe = SpWeLe + 45
                smLevel = Smooth(smLevel, nexlvl, 1)
                AddText(OneHud:RespX(SpWeLe),OneHud:RespY(posy+20), level .. " - " .. nexlvl*100 .. "%", v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + (string.len(level .. " - " .. nexlvl*100 .. "%") + 0.6) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Ping" then
                AddIcon(OneHud:RespX(SpWeLe), OneHud:RespY(posy+6), icons.ping, OneHud.Config.PingColor)
                SpWeLe = SpWeLe + 45
                AddText(OneHud:RespX(SpWeLe),OneHud:RespY(posy+20), math.Round(ping) .. "ms", v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + (string.len(level .. " - " .. nexlvl*100 .. "%")-0.6) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Ammo" && !OneHud.Config.HideAmmoWeps[wepclass] && magammo != -1 then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                if OneHud.Config.SpeAmmoWhenNone || ammo2 > 0 then
                    posy = posy - (40 + OneHud.Config.HeightSpacing)
                end
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.AmmoBackColor)
                smAmmo = Smooth(smAmmo, magammo, maxammo)
                AddBar(v, true, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), math.Clamp(smAmmo * OneHud:RespX(288), 0, OneHud:RespX(288)), OneHud:RespY(40-12), OneHud.Config.AmmoColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), magammo .. " / " .. maxammo .. " - " .. ammo, v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.ammo, OneHud.Config.AmmoColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Special Ammo" && (OneHud.Config.SpeAmmoWhenNone || ammo2 > 0) then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                posy = posy + 40 + OneHud.Config.HeightSpacing
                AddBar(v, false, OneHud:RespX(posx), OneHud:RespY(posy), OneHud:RespX(MvIcon(v, 0)+300), OneHud:RespY(40), OneHud.Config.BackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), OneHud:RespX(300-12), OneHud:RespY(40-12), OneHud.Config.SpeAmmoBackColor)
                AddBar(v, false, OneHud:RespX(posx+MvIcon(v, 2)+6), OneHud:RespY(posy+6), math.Clamp(ammo2, 0, 1)*OneHud:RespX(288), OneHud:RespY(40-12), OneHud.Config.SpeAmmoColor)
                AddText(OneHud:RespX(posx+MvIcon(v, 2)+156),OneHud:RespY(posy+20), math.Clamp(ammo2, 0, 1) .. " / 1 - " .. math.Clamp(ammo2-1, 0, 9999), v, 1)
                AddIcon(OneHud:RespX(posx+6+MvIcon(v, 1)), OneHud:RespY(posy+6), icons.speammo, OneHud.Config.SpeAmmoColor)
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            end
        end
    end
end)

if OneHud.Config.TalkIcon then
    local VoiceIsActived = false
    local PlayerVoicePanels = {}

    function draw.RotatedBox(x, y, w, h)
        local Rotating = math.sin(CurTime() * 3)
            local backwards = 0

            if Rotating < 0 then
                Rotating = 1 - (1 + Rotating)
            backwards = 1
        end

        surface.SetMaterial(icons.talk)
        surface.SetDrawColor(OneHud.Config.IconColor)
        surface.DrawTexturedRectRotated(x, y, Rotating * 64, 64,  backwards)
    end

    hook.Add("HUDPaint", "MicIcon_HUD", function()
        if VoiceIsActived then
            draw.RotatedBox( ScrW()-55, ScrH()/2-32, 64, 64)
        end
    end)

    hook.Add("PlayerStartVoice", "MicIcon_EnableVoice", function(ply)
        Material("voice/icntlk_pl"):SetFloat("$alpha", 0)
        if ply == LocalPlayer() then
            VoiceIsActived = true
        end
    end)

    hook.Add("PlayerEndVoice", "MicIcon_DisableVoice", function(ply)
        if ply == LocalPlayer() then
            VoiceIsActived = false
        end
    end)
end

hook.Add("HUDShouldDraw", "HideDefautHUD", function(name )
    local talkicon = OneHud.Config.TalkIcon
    local hideHUD = {
        ["CHudAmmo"] = true,
        ["CHudBattery"] = true,
        ["CHudHealth"] = true,
        ["CHudBattery"] = true,
        ["DarkRP_HUD"] = true,
        ["DarkRP_Hungermod"] = true,
        ["CHudSecondaryAmmo"] = true,
        ["DarkRP_ChatReceivers"] = talkicon
    }
    if hideHUD[name] then
        return false
    end
end)