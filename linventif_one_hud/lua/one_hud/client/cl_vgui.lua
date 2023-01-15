concommand.Add("onehud", function(ply, cmd, args)
    local faded_black = Color(0, 0, 0, 200)
    local DermaPanel = vgui.Create("DFrame")
    DermaPanel:SetSize(500, 300)
    DermaPanel:Center()
    DermaPanel:SetTitle("")
    DermaPanel:SetDraggable(false)
    DermaPanel:MakePopup()
    DermaPanel.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, faded_black)
        draw.SimpleText("Derma Frame", "Font", 250, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)