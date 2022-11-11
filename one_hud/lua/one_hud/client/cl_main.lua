local icons = {
    ["health"] = Material("one_hud/health.png"),
    ["shield"] = Material("one_hud/shield.png"),
    ["team"] = Material("one_hud/team.png"),
    ["wallet"] =  Material("one_hud/wallet.png"),
    ["food"] =  Material("one_hud/food.png")
}

surface.CreateFont("OneHUDFont", {
	font = OneHud.Config.TextFont,
	extended = false,
	size = OneHud.Config.TextSize,
	weight = 500,
})

function OneHud:RespX(x)
    return x/1920*ScrW()
end

function OneHud:RespY(y)
    return y/1080*ScrH()
end

function OneHud:Resp(x, y)
    return hud:RespX(x), hud:RespY(y)
end

local start, oldhp, newhp = 0, -1, -1
local animationTime = 0.6
local smHealth = 0
local smArmor = 0
local smFood = 0
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
    local name = ply:Nick()
    local ping = ply:Ping()

    local health = math.Clamp(ply:Health(), 0, ply:GetMaxHealth())
    local maxhealth = ply:GetMaxHealth()
    local armor = math.Clamp(ply:Armor(), 0, ply:GetMaxArmor())
    local maxarmor = ply:GetMaxArmor()

    local salary = "" .. ply:getDarkRPVar("salary") or "ERROR"
    local food = ply:getDarkRPVar("Energy") or 100
    local wanted = ply:getDarkRPVar("wanted") or 0

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

    local teamcolor = team.GetColor(ply:Team())
    local teamname = team.GetName(ply:Team())

    local spaceweight = 0
    local spaceheight = 0

    if OneHud.Config.HUD == "Simple" then
        if OneHud.Config.Icon then
            spaceweight = 34
        end
        for k, v in SortedPairs(OneHud.Config.Order, true) do
            if v == "Health" then
                surface.SetDrawColor(OneHud.Config.BackColor)
                surface.DrawRect(OneHud:RespX(40), OneHud:RespY(1080-80-spaceheight), OneHud:RespX(300+spaceweight), OneHud:RespY(40))
                if OneHud.Config.BackGroundBar then
                    surface.SetDrawColor(OneHud.Config.HealthBackColor)
                    surface.DrawRect(OneHud:RespX(46+spaceweight), OneHud:RespY(1080-80+6-spaceheight), OneHud:RespX(300-12), OneHud:RespY(40-12))
                end
                smHealth = Lerp(FrameTime() * 6, smHealth, health / ply:GetMaxHealth())
                surface.SetDrawColor(OneHud.Config.HealthColor)
                surface.DrawRect(OneHud:RespX(46+spaceweight), OneHud:RespY(1080-80+6-spaceheight), math.Clamp(smHealth * OneHud:RespX(288), 0, OneHud:RespX(288)), OneHud:RespY(40-12))
                if OneHud.Config.Text then
                    draw.SimpleTextOutlined(math.Round(smHealth * ply:GetMaxHealth()) .. " / " .. ply:GetMaxHealth(), "OneHUDFont", OneHud:RespX(190+spaceweight), OneHud:RespY(1080-60-spaceheight), OneHud.Config.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0, 0, 0, 255))
                end
                if OneHud.Config.Icon then
                    surface.SetMaterial(icons.health)
                    surface.SetDrawColor(OneHud.Config.HealthColor)
                    surface.DrawTexturedRect(OneHud:RespX(46), OneHud:RespY(1080-80+6-spaceheight), 28, 28)
                end
                spaceheight = spaceheight + 40 + OneHud.Config.HeightSpacing
            elseif v == "Money" then
                surface.SetDrawColor(OneHud.Config.BackColor)
                surface.DrawRect(OneHud:RespX(40), OneHud:RespY(1080-80-spaceheight), OneHud:RespX(300+spaceweight), OneHud:RespY(40))
                surface.SetDrawColor(OneHud.Config.TextBackColor)
                surface.DrawRect(OneHud:RespX(46+spaceweight), OneHud:RespY(1080-80+6-spaceheight), OneHud:RespX(300-12), OneHud:RespY(40-12))
                draw.SimpleTextOutlined(money, "OneHUDFont", OneHud:RespX(190+spaceweight), OneHud:RespY(1080-60-spaceheight), OneHud.Config.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0, 0, 0, 255))
                if OneHud.Config.Icon then
                    surface.SetMaterial(icons.wallet)
                    surface.SetDrawColor(156, 156, 156)
                    surface.DrawTexturedRect(OneHud:RespX(46), OneHud:RespY(1080-80+6-spaceheight), 28, 28)
                end
                spaceheight = spaceheight + 40 + OneHud.Config.HeightSpacing
            elseif v == "Team" then
                surface.SetDrawColor(OneHud.Config.BackColor)
                surface.DrawRect(OneHud:RespX(40), OneHud:RespY(1080-80-spaceheight), OneHud:RespX(300+spaceweight), OneHud:RespY(40))
                surface.SetDrawColor(OneHud.Config.TextBackColor)
                surface.DrawRect(OneHud:RespX(46+spaceweight), OneHud:RespY(1080-80+6-spaceheight), OneHud:RespX(300-12), OneHud:RespY(40-12))
                draw.SimpleTextOutlined(teamname, "OneHUDFont", OneHud:RespX(190+spaceweight), OneHud:RespY(1080-60-spaceheight), OneHud.Config.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0, 0, 0, 255))
                if OneHud.Config.Icon then
                    surface.SetMaterial(icons.team)
                    surface.SetDrawColor(156, 156, 156)
                    surface.DrawTexturedRect(OneHud:RespX(46), OneHud:RespY(1080-80+6-spaceheight), 28, 28)
                end
                spaceheight = spaceheight + 40 + OneHud.Config.HeightSpacing
            elseif v == "Food" then
                surface.SetDrawColor(OneHud.Config.BackColor)
                surface.DrawRect(OneHud:RespX(40), OneHud:RespY(1080-80-spaceheight), OneHud:RespX(300+spaceweight), OneHud:RespY(40))
                if OneHud.Config.BackGroundBar then
                    surface.SetDrawColor(OneHud.Config.FoodBackColor)
                    surface.DrawRect(OneHud:RespX(46+spaceweight), OneHud:RespY(1080-80+6-spaceheight), OneHud:RespX(300-12), OneHud:RespY(40-12))
                end
                smFood = Lerp(FrameTime() * 6, smFood, food / 100)
                surface.SetDrawColor(OneHud.Config.FoodColor)
                surface.DrawRect(OneHud:RespX(46+spaceweight), OneHud:RespY(1080-80+6-spaceheight), math.Clamp(smFood * OneHud:RespX(288), 0, OneHud:RespX(288)), OneHud:RespY(40-12))
                if OneHud.Config.Text then
                    draw.SimpleTextOutlined(math.Round(smFood * 100) .. " / 100", "OneHUDFont", OneHud:RespX(190+spaceweight), OneHud:RespY(1080-60-spaceheight), OneHud.Config.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0, 0, 0, 255))
                end
                if OneHud.Config.Icon then
                    surface.SetMaterial(icons.food)
                    surface.SetDrawColor(OneHud.Config.FoodColor)
                    surface.DrawTexturedRect(OneHud:RespX(46), OneHud:RespY(1080-80+6-spaceheight), 28, 28)
                end
                spaceheight = spaceheight + 40 + OneHud.Config.HeightSpacing
            elseif v == "Armor" then
                surface.SetDrawColor(OneHud.Config.BackColor)
                surface.DrawRect(OneHud:RespX(40), OneHud:RespY(1080-80-spaceheight), OneHud:RespX(300+spaceweight), OneHud:RespY(40))
                if OneHud.Config.BackGroundBar then
                    surface.SetDrawColor(OneHud.Config.ArmorBackColor)
                    surface.DrawRect(OneHud:RespX(46+spaceweight), OneHud:RespY(1080-80+6-spaceheight), OneHud:RespX(300-12), OneHud:RespY(40-12))
                end
                smArmor = Lerp(FrameTime() * 6, smArmor, armor / maxarmor)
                surface.SetDrawColor(OneHud.Config.ArmorColor)
                surface.DrawRect(OneHud:RespX(46+spaceweight), OneHud:RespY(1080-80+6-spaceheight), math.Clamp(smArmor * OneHud:RespX(288), 0, OneHud:RespX(288)), OneHud:RespY(40-12))
                if OneHud.Config.Text then
                    draw.SimpleTextOutlined(math.Round(smArmor * 100) .. " / 100", "OneHUDFont", OneHud:RespX(190+spaceweight), OneHud:RespY(1080-60-spaceheight), OneHud.Config.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0, 0, 0, 255))
                end
                if OneHud.Config.Icon then
                    surface.SetMaterial(icons.shield)
                    surface.SetDrawColor(OneHud.Config.ArmorColor)
                    surface.DrawTexturedRect(OneHud:RespX(46), OneHud:RespY(1080-80+6-spaceheight), 28, 28)
                end
                spaceheight = spaceheight + 40 + OneHud.Config.HeightSpacing
            elseif v == "Ammo" then
                surface.SetDrawColor(OneHud.Config.BackColor)
                surface.DrawRect(OneHud:RespX(1920-340), OneHud:RespY(1080-80), OneHud:RespX(300), OneHud:RespY(40))
                if OneHud.Config.BackGroundBar then
                    surface.SetDrawColor(OneHud.Config.ArmorBackColor)
                    surface.DrawRect(OneHud:RespX(1920-346), OneHud:RespY(1080-80), OneHud:RespX(300), OneHud:RespY(40-12))
                end
                smArmor = Lerp(FrameTime() * 6, smArmor, armor / maxarmor)
                surface.SetDrawColor(OneHud.Config.ArmorColor)
                surface.DrawRect(OneHud:RespX(1920-346), OneHud:RespY(1080-80), math.Clamp(smArmor * OneHud:RespX(288), 0, OneHud:RespX(288)), OneHud:RespY(40-12))
                draw.SimpleTextOutlined(ply:GetActiveWeapon():Clip1() .. " / " .. ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()), "OneHUDFont", OneHud:RespX(1920-346), OneHud:RespY(1080-80), OneHud.Config.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0, 0, 0, 255))
                if OneHud.Config.Icon then
                    surface.SetMaterial(icons.shield)
                    surface.SetDrawColor(OneHud.Config.ArmorColor)
                    surface.DrawTexturedRect(OneHud:RespX(46), OneHud:RespY(1080-80+6), 28, 28)
                end
            end
        end
    end
end)

hook.Add("HUDShouldDraw", "HideDefautHUD", function(name )
    local hideHUD = {
        ["CHudAmmo"] = true,
        ["CHudBattery"] = true,
        ["CHudHealth"] = true,
        ["CHudBattery"] = true,
        ["DarkRP_HUD"] = true,
        ["DarkRP_Hungermod"] = true,
        ["CHudSecondaryAmmo"] = true
    }
    if hideHUD[name] then
        return false
    end
end)