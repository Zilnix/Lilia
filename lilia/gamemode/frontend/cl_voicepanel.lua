﻿--------------------------------------------------------------------------------------------------------------------------
local PANEL = {}
VoicePanels = {}
--------------------------------------------------------------------------------------------------------------------------
function PANEL:Init()
    local hi = vgui.Create("DLabel", self)
    hi:SetFont("liaIconsMedium")
    hi:Dock(LEFT)
    hi:DockMargin(8, 0, 8, 0)
    hi:SetTextColor(color_white)
    hi:SetText("i")
    hi:SetWide(30)
    self.LabelName = vgui.Create("DLabel", self)
    self.LabelName:SetFont("liaMediumFont")
    self.LabelName:Dock(FILL)
    self.LabelName:DockMargin(0, 0, 0, 0)
    self.LabelName:SetTextColor(color_white)
    self.Color = color_transparent
    self:SetSize(280, 32 + 8)
    self:DockPadding(4, 4, 4, 4)
    self:DockMargin(2, 2, 2, 2)
    self:Dock(BOTTOM)
end

--------------------------------------------------------------------------------------------------------------------------
function PANEL:Setup(client)
    self.client = client
    self.name = hook.Run("ShouldAllowScoreboardOverride", client, "name") and hook.Run("GetDisplayedName", client, nil) or client:getChar():getName()
    self.LabelName:SetText(self.name)
    self:InvalidateLayout()
end

--------------------------------------------------------------------------------------------------------------------------
function PANEL:Paint(w, h)
    if not IsValid(self.client) then return end
    lia.util.drawBlur(self, 1, 2)
    surface.SetDrawColor(0, 0, 0, 50 + self.client:VoiceVolume() * 50)
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(255, 255, 255, 50 + self.client:VoiceVolume() * 120)
    surface.DrawOutlinedRect(0, 0, w, h)
end

--------------------------------------------------------------------------------------------------------------------------
function PANEL:Think()
    if IsValid(self.client) then
        self.LabelName:SetText(self.name)
    end

    if self.fadeAnim then
        self.fadeAnim:Run()
    end
end

--------------------------------------------------------------------------------------------------------------------------
function PANEL:FadeOut(anim, delta, data)
    if anim.Finished then
        if IsValid(VoicePanels[self.client]) then
            VoicePanels[self.client]:Remove()
            VoicePanels[self.client] = nil

            return
        end

        return
    end

    self:SetAlpha(255 - (255 * (delta * 2)))
end

--------------------------------------------------------------------------------------------------------------------------
vgui.Register("VoicePanel", PANEL, "DPanel")
--------------------------------------------------------------------------------------------------------------------------
function GM:PlayerStartVoice(client)
    if not IsValid(g_VoicePanelList) or not lia.config.AllowVoice then return end
    hook.Run("PlayerEndVoice", client)
    if IsValid(VoicePanels[client]) then
        if VoicePanels[client].fadeAnim then
            VoicePanels[client].fadeAnim:Stop()
            VoicePanels[client].fadeAnim = nil
        end

        VoicePanels[client]:SetAlpha(255)

        return
    end

    if not IsValid(client) then return end
    local pnl = g_VoicePanelList:Add("VoicePanel")
    pnl:Setup(client)
    VoicePanels[client] = pnl
end

--------------------------------------------------------------------------------------------------------------------------
function GM:PlayerEndVoice(client)
    if IsValid(VoicePanels[client]) then
        if VoicePanels[client].fadeAnim then return end
        VoicePanels[client].fadeAnim = Derma_Anim("FadeOut", VoicePanels[client], VoicePanels[client].FadeOut)
        VoicePanels[client].fadeAnim:Start(2)
    end
end

--------------------------------------------------------------------------------------------------------------------------
timer.Create(
    "VoiceClean",
    2,
    0,
    function()
        for k, v in pairs(VoicePanels) do
            if not IsValid(k) then
                hook.Run("PlayerEndVoice", k)
            end
        end
    end
)
--------------------------------------------------------------------------------------------------------------------------