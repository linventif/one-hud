

local function RespW(x)
    return x/1920*ScrW()
end

local function RespH(y)
    return y/1080*ScrH()
end

local defaut_pos = {
    ["w"] = 600,
    ["h"] = -40
}
local size = {
    ["w"] = 450,
    ["h"] = 40
}

local type_name = {
    [0] = "generic",
    [1] = "error",
    [2] = "undo",
    [3] = "hint",
    [4] = "cleanup",
    [5] = "generic"
}

local notif_pos = {}

function notification.AddLegacy(text, type_notif, time)
    local space, id = 0, 0
    if #notif_pos > 0 then
        for k, v in pairs(notif_pos) do
            if v == false then
                notif_pos[k] = true
                id = k
                break
            end
        end
        if id == 0 then
            table.insert(notif_pos, true)
            id = #notif_pos
        end
    else
        table.insert(notif_pos, true)
        id = 1
    end
    space = id*50
    local frame = vgui.Create("DPanel")
    frame:SetSize(RespW(size["w"]), RespH(size["h"]))
    frame:SetPos(ScrW() + RespH(defaut_pos["h"]), RespH(defaut_pos["w"] - space))
    frame.Paint = function(self, w, h)
        draw.RoundedBox(OneHud.Config.RoundValue, 0, 0, w, h, OneHud.Config.Color["background"])
        draw.RoundedBox(OneHud.Config.RoundValue - 2, 5, 5, w-10-34, h-10, OneHud.Config.Color["text_background"])
        draw.SimpleText(text, "LinvFontRobo20", RespW(size["w"])/2, RespH(size["h"]/2), FriendsSys.Config.Color["text"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        surface.SetMaterial(OneHud.Materials[type_name[type_notif] or "generic"])
        surface.SetDrawColor(OneHud.Config.Color["notif"][type_name[type_notif]] or OneHud.Config.Color["notif"]["generic"])
        surface.DrawTexturedRect(w-33, 7, RespW(26), RespH(26))
    end
    frame:MoveTo(ScrW()-RespW(size["w"]) + RespH(defaut_pos["h"]), RespH(defaut_pos["w"] - space), 0.5, 0, 1)
    timer.Simple(time, function()
        frame:MoveTo(ScrW() + RespH(defaut_pos["h"]), RespH(defaut_pos["w"] - space), 0.5, 0, 1)
        timer.Simple(0.5, function()
            frame:Remove()
            notif_pos[id] = false
        end)
    end)
end

concommand.Add("one_hud_notif", function(ply, cmd, args)
    for i = 1, 5 do
        timer.Simple(i, function()
            notification.AddLegacy("test", i, 2)
        end)
    end
end)