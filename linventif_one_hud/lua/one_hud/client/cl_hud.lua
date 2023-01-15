local function RespW(x)
    return x/1920*ScrW()
end

local function RespH(y)
    return y/1080*ScrH()
end

surface.CreateFont("OneHUDFont", {
	font = OneHud.Config.TextFont,
	extended = false,
	size = RespW(OneHud.Config.TextSize),
	weight = 500,
})

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

local function AddBar(round, value, right, x, y, w, h, c)
    if right then
        draw.RoundedBox(math.Clamp(OneHud.Config.RoundValue + round, 0, 28), x+(300-12)-w, y, w, h, c)
    else
        draw.RoundedBox(math.Clamp(OneHud.Config.RoundValue + round, 0, 28), x, y, w, h, c)
    end
end

local function isright(element)
    if OneHud.Config.Possition[element] == "right" then
        return true
    else
        return false
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
        draw.SimpleTextOutlined(t, "OneHUDFont", x, y, OneHud.Config.Color["text"], aling, TEXT_ALIGN_CENTER, 0, Color(0, 0, 0, 255))
    end
end

local function ShowMaxValue(v, p1, p2)
    if OneHud.Config.MaxValue then
        return p1 .. p2
    else
        return p1 .. OneHud.Config.Postfix[v]
    end
end

local function ModeSpace(v)
    if OneHud.Config.MaxValue && OneHud.Config.MoreSpace[v] then
        return OneHud.Config.MoreSpace[v]
    else
        return 0.8
    end
end

local function AddIcon(x, y, icon, color)
    if OneHud.Config.Icon then
        surface.SetMaterial(icon)
        surface.SetDrawColor(color)
        surface.DrawTexturedRect(x, y, RespW(28), RespH(28))
    end
end

local smHealth, smArmor, smAmmo, smFood, smLevel, smProps, ping, pingcd = 0, 0, 0, 0, 0, 0, 0, 0
local time = 0

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
        OneHud.Config.PingColor = OneHud.Config.Color["ping"]["good"]
    elseif ping > OneHud.Config.PingGood && ping < OneHud.Config.PingBad then
        OneHud.Config.PingColor = OneHud.Config.Color["ping"]["medium"]
    else
        OneHud.Config.PingColor = OneHud.Config.Color["ping"]["bad"]
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
    local wanted = ply:getDarkRPVar("wanted") or false
    local license = ply:getDarkRPVar("HasGunlicense") or false
    local level = 0
    local nexlvl = 0
    if LevelSystemConfiguration then
        level = ply:getDarkRPVar("level") or 0
        nexlvl = math.Round((ply:getDarkRPVar("xp") or 0) / (((10 + (((ply:getDarkRPVar("level") or 1)*((ply:getDarkRPVar("level") or 1)+1)*90))))*LevelSystemConfiguration.XPMult), 2)
    elseif GlorifiedLeveling then
        level = GlorifiedLeveling.GetPlayerLevel(ply) or 0
        nexlvl = math.Round((GlorifiedLeveling.GetPlayerXP(ply) or 0) / (GlorifiedLeveling.GetPlayerMaxXP(ply)or 1), 2)
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

    local wep = {}
    wep.active = ply:GetActiveWeapon() or nil
    if IsValid(wep.active) then
        wep.wepclass = wep.active:GetClass()
        wep.wepname = OneHud.Config.WepsName[wep.wepclass] || "ERROR"
        wep.ammo = ply:GetAmmoCount(wep.active:GetPrimaryAmmoType()) or 0
        wep.magammo = wep.active:Clip1() or 0
        wep.maxammo = wep.active:GetMaxClip1() or 0
        wep.ammo2 = ply:GetAmmoCount(wep.active:GetSecondaryAmmoType()) or 0
    end

    local SpHeRi = 0
    local SpWeRi = 0
    local SpHeLe = 0
    local SpWeLe = 0

    if OneHud.Config.Theme == "Flat" then
        for k, v in SortedPairs(OneHud.Config.Order, true) do
            if v == "Money" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["text_background"])
                AddText(RespW(posx+MvIcon(v, 2)+156), RespH(posy+20), money, v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["wallet"], OneHud.Config.Color["icon"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Team" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["text_background"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), teamname, v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["team"], OneHud.Config.Color["icon"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Name" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["text_background"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), name, v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["name"], OneHud.Config.Color["icon"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Group" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["text_background"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), OneHud.Config.Groups[group], v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["group"], OneHud.Config.Color["icon"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Weapon" && IsValid(wep.active) then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["text_background"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), wep.wepname, v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["weapon"], OneHud.Config.Color["icon"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Health" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["health"]["back"])
                smHealth = Smooth(smHealth, health, maxhealth)
                AddBar(-2, v, isright(v), RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), math.Clamp(smHealth * RespW(288), 0, RespW(288)), RespH(40-12), OneHud.Config.Color["health"]["front"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), ShowMaxValue(v, math.Round(smHealth * maxhealth), " / " .. maxhealth), v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["health"], OneHud.Config.Color["health"]["front"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Food" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["food"]["back"])
                smFood = Smooth(smFood, food, 100)
                AddBar(-2, v, isright(v), RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), math.Clamp(smFood * RespW(288), 0, RespW(288)), RespH(40-12), OneHud.Config.Color["food"]["front"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), ShowMaxValue(v, math.Round(smFood * 100)," / 100"), v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["food"], OneHud.Config.Color["food"]["front"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Armor" && (OneHud.Config.ArmorWhenNone || armor > 0 ) then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["armor"]["back"])
                smArmor = Smooth(smArmor, armor, maxarmor)
                AddBar(-2, v, isright(v), RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), math.Clamp(smArmor * RespW(288), 0, RespW(288)), RespH(40-12), OneHud.Config.Color["armor"]["front"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), ShowMaxValue(v, math.Round(smArmor * maxarmor)," / " .. maxarmor), v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["shield"], OneHud.Config.Color["armor"]["front"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Props" && (OneHud.Config.PropsWhenNone || props > 0 ) then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["props"]["back"])
                smProps = Smooth(smProps, props, maxprops)
                AddBar(-2, v, isright(v), RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), math.Clamp(smProps * RespW(288), 0, RespW(288)), RespH(40-12), OneHud.Config.Color["props"]["front"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), ShowMaxValue(v, math.Round(smProps * maxprops), " / " .. maxprops), v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["props"], OneHud.Config.Color["props"]["front"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Level" then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["level"]["back"])
                smLevel = Smooth(smLevel, nexlvl, 1)
                AddBar(-2, v, isright(v), RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), math.Clamp(smLevel * RespW(288), 0, RespW(288)), RespH(40-12), OneHud.Config.Color["level"]["front"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), ShowMaxValue(v, level, " - " .. nexlvl*100 .. "%"), v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["level"], OneHud.Config.Color["level"]["front"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Ammo" && IsValid(wep.active) && !OneHud.Config.HideAmmoWeps[wep.wepclass] && wep.magammo != -1 then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["ammo"]["back"])
                smAmmo = Smooth(smAmmo, wep.magammo, wep.maxammo)
                AddBar(-2, v, isright(v), RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), math.Clamp(smAmmo * RespW(288), 0, RespW(288)), RespH(40-12), OneHud.Config.Color["ammo"]["front"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), wep.magammo .. " / " .. wep.maxammo .. " - " .. wep.ammo, v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["ammo"], OneHud.Config.Color["ammo"]["front"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Special Ammo" && IsValid(wep.active) && (OneHud.Config.SpeAmmoWhenNone || wep.ammo2 > 0) then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["spe_ammo"]["back"])
                AddBar(-2, v, isright(v), RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), math.Clamp(wep.ammo2, 0, 1)*RespW(288), RespH(40-12), OneHud.Config.Color["spe_ammo"]["front"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), math.Clamp(wep.ammo2, 0, 1) .. " / 1 - " .. math.Clamp(wep.ammo2-1, 0, 9999), v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["spe_ammo"], OneHud.Config.Color["spe_ammo"]["front"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            end
        end
    elseif OneHud.Config.Theme == "Flat Bar" then
        AddBar(0, v, false, RespW(0), RespH(1080-40-OneHud.Config.HeightSpacing ), RespW(1920), RespH(40+OneHud.Config.HeightSpacing ), OneHud.Config.Color["background"])
        if OneHud.Config.FlatBarMessage then
            AddText(RespW(1920-string.len(OneHud.Config.FlatBarMessage)), RespH(1080-20-OneHud.Config.HeightSpacingFlatBar/2), OneHud.Config.FlatBarMessage, "FlatBarMessage", 2)
        end
        local posx, posy = SpWeLe+20, 1080-40 - OneHud.Config.HeightSpacingFlatBar / 2
        SpWeLe = SpWeLe + 20
        SpHeRi = SpHeRi + 40 + OneHud.Config.HeightSpacingFlatBar
        SpHeRi = SpHeLe + 40 + OneHud.Config.HeightSpacingFlatBar
        for k, v in SortedPairs(OneHud.Config.Order) do
            if v == "Money" then
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["wallet"], OneHud.Config.Color["icon"])
                SpWeLe = SpWeLe + 45
                AddText(RespW(SpWeLe),RespH(posy+20), money, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(money) * (7 + ModeSpace(v)) + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Team" then
                local multi = 7
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["team"], OneHud.Config.Color["icon"])
                SpWeLe = SpWeLe + 45
                AddText(RespW(SpWeLe),RespH(posy+20), teamname, v, 0)
                if string.len(teamname) > 10 then
                    multi = 6
                end
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing + string.len(teamname) * (multi + ModeSpace(v)) + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Wanted" then
                if !wanted then continue end
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["wanted"], OneHud.Config.Color["wanted"])
                SpWeLe = SpWeLe + 45
                AddText(RespW(SpWeLe),RespH(posy+20), OneHud.GetTranslation("wanted"), v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(OneHud.GetTranslation("wanted")) * (7 + ModeSpace(v)) + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "License" then
                if !license && !OneHud.Config.LicenseWhenNone then continue end
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["license"], OneHud.Config.Color["license"])
                SpWeLe = SpWeLe + 45
                local txt = OneHud.GetTranslation("no")
                if license then txt = OneHud.GetTranslation("yes") end
                AddText(RespW(SpWeLe),RespH(posy+20), txt, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(txt) * (10 + ModeSpace(v)) + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Name" then
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["name"], OneHud.Config.Color["icon"])
                SpWeLe = SpWeLe + 45
                AddText(RespW(SpWeLe),RespH(posy+20), name, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(name) * (7 + ModeSpace(v)) + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Group" then
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["group"], OneHud.Config.Color["icon"])
                SpWeLe = SpWeLe + 45
                AddText(RespW(SpWeLe),RespH(posy+20), OneHud.Config.Groups[group], v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(OneHud.Config.Groups[group]) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Weapon" && IsValid(wep.active) then
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["weapon"], OneHud.Config.Color["icon"])
                SpWeLe = SpWeLe + 45
                AddText(RespW(SpWeLe),RespH(posy+20), wep.wepname, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(wep.wepname) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Health" then
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["health"], OneHud.Config.Color["health"]["front"])
                SpWeLe = SpWeLe + 45
                smHealth = Smooth(smHealth, health, maxhealth)
                local txt = ShowMaxValue(v, math.Round(smHealth * maxhealth), " / " .. maxhealth)
                AddText(RespW(SpWeLe),RespH(posy+20), txt, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(txt) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Food" then
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["food"], OneHud.Config.Color["food"]["front"])
                SpWeLe = SpWeLe + 45
                smFood = Smooth(smFood, food, 100)
                local txt = ShowMaxValue(v, math.Round(smFood*100), " / 100")
                AddText(RespW(SpWeLe),RespH(posy+20), txt, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(txt) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Armor" && (OneHud.Config.ArmorWhenNone || armor > 0 ) then
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["shield"], OneHud.Config.Color["armor"]["front"])
                SpWeLe = SpWeLe + 45
                smArmor = Smooth(smArmor, armor, maxarmor)
                local txt = ShowMaxValue(v, math.Round(smArmor * maxarmor), " / " .. maxarmor)
                AddText(RespW(SpWeLe),RespH(posy+20), txt, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(txt) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)
            elseif v == "Props" && (OneHud.Config.PropsWhenNone || props > 0 ) then
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["props"], OneHud.Config.Color["props"]["front"])
                SpWeLe = SpWeLe + 45
                smProps = Smooth(smProps, props, maxprops)
                local txt = ShowMaxValue(v, math.Round(smProps * maxprops), " / " .. maxprops)
                AddText(RespW(SpWeLe),RespH(posy+20), txt, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(txt) * (10 + ModeSpace(v)) + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize) - 24
            elseif v == "Level" then
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["level"], OneHud.Config.Color["level"]["front"])
                SpWeLe = SpWeLe + 45
                smLevel = Smooth(smLevel, nexlvl, 1)
                local txt = level .. " - " .. math.Round(smLevel*100) .. "%"
                AddText(RespW(SpWeLe),RespH(posy+20), txt, v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing  + string.len(txt) * (10 + ModeSpace(v)) + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize)-10
            elseif v == "Ping" then
                AddIcon(RespW(SpWeLe), RespH(posy+6), OneHud.Materials["ping"], OneHud.Config.PingColor)
                SpWeLe = SpWeLe + 45
                AddText(RespW(SpWeLe),RespH(posy+20), math.Round(ping) .. "ms", v, 0)
                SpWeLe = SpWeLe + OneHud.Config.WidthSpacing + string.len(ping) * 10 + math.Clamp(OneHud.Config.TextSize-10, 0, OneHud.Config.TextSize) + 20 + ModeSpace(v)
            elseif v == "Ammo" && IsValid(wep.active) && !OneHud.Config.HideAmmoWeps[wep.wepclass] && wep.magammo != -1 then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                if OneHud.Config.SpeAmmoWhenNone || wep.ammo2 > 0 then
                    posy = posy - (40 + OneHud.Config.HeightSpacing)
                end
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, isright(v), RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["ammo"]["back"])
                smAmmo = Smooth(smAmmo, wep.magammo, wep.maxammo)
                AddBar(-2, v, true, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), math.Clamp(smAmmo * RespW(288), 0, RespW(288)), RespH(40-12), OneHud.Config.Color["ammo"]["front"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), wep.magammo .. " / " .. wep.maxammo .. " - " .. wep.ammo, v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["ammo"], OneHud.Config.Color["ammo"]["front"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            elseif v == "Special Ammo" && IsValid(wep.active) && (OneHud.Config.SpeAmmoWhenNone || wep.ammo2 > 0) then
                local posx, posy = GetPos(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
                posy = posy + 40 + OneHud.Config.HeightSpacing
                AddBar(0, v, false, RespW(posx), RespH(posy), RespW(MvIcon(v, 0)+300), RespH(40), OneHud.Config.Color["background"])
                AddBar(-2, v, false, RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), RespW(300-12), RespH(40-12), OneHud.Config.Color["spe_ammo"]["back"])
                AddBar(-2, v, isright(v), RespW(posx+MvIcon(v, 2)+6), RespH(posy+6), math.Clamp(wep.ammo2, 0, 1)*RespW(288), RespH(40-12), OneHud.Config.Color["spe_ammo"]["front"])
                AddText(RespW(posx+MvIcon(v, 2)+156),RespH(posy+20), math.Clamp(wep.ammo2, 0, 1) .. " / 1 - " .. math.Clamp(wep.ammo2-1, 0, 9999), v, 1)
                AddIcon(RespW(posx+6+MvIcon(v, 1)), RespH(posy+6), OneHud.Materials["spe_ammo"], OneHud.Config.Color["spe_ammo"]["front"])
                SpWeRi, SpWeLe, SpHeRi, SpHeLe = NewSpace(OneHud.Config.Possition[v], SpWeRi, SpWeLe, SpHeRi, SpHeLe)
            end
        end
    end
end)