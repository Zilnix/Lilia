﻿local MODULE = MODULE
net.Receive("ViewClaims", function()
    local tbl = net.ReadTable()
    local steamid = net.ReadString()
    if steamid and steamid ~= "" and steamid ~= " " then
        local v = tbl[steamid]
        print(v.name .. " - " .. v.claims .. " - last claim " .. string.NiceTime(os.time() - v.lastclaim) .. " ago")
    else
        for _, v in pairs(tbl) do
            print(v.name .. " - " .. v.claims)
        end
    end
end)

net.Receive("TicketSystem", function()
    local pl = net.ReadEntity()
    local msg = net.ReadString()
    local claimed = net.ReadEntity()
    if LocalPlayer():Team() == FACTION_STAFF or LocalPlayer():IsSuperAdmin() then MODULE:TicketFrame(pl, msg, claimed) end
end)

net.Receive("TicketSystemClaim", function()
    local pl = net.ReadEntity()
    local requester = net.ReadEntity()
    for _, v in pairs(TicketFrames) do
        if v.idiot == requester then
            local titl = v:GetChildren()[4]
            titl:SetText(titl:GetText() .. " - Claimed by " .. pl:Nick())
            if pl == LocalPlayer() then
                function v:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 230))
                    draw.RoundedBox(0, 2, 2, w - 4, 16, Color(38, 166, 91))
                end
            else
                function v:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 230))
                    draw.RoundedBox(0, 2, 2, w - 4, 16, Color(207, 0, 15))
                end
            end

            local bu = v:GetChildren()[11]
            bu.DoClick = function()
                if LocalPlayer() == pl then
                    net.Start("TicketSystemClose")
                    net.WriteEntity(requester)
                    net.SendToServer()
                else
                    v:Close()
                end
            end
        end
    end
end)

net.Receive("TicketSystemClose", function()
    local requester = net.ReadEntity()
    if not IsValid(requester) or not requester:IsPlayer() then return end
    for _, v in pairs(TicketFrames) do
        if v.idiot == requester then v:Remove() end
    end

    if timer.Exists("ticketsystem-" .. requester:SteamID64()) then timer.Remove("ticketsystem-" .. requester:SteamID64()) end
end)

net.Receive("TicketClientNotify", function()
    local text = net.ReadString()
    chat.AddText(Color(70, 0, 130), "You", Color(151, 211, 255), " to admins: ", Color(0, 255, 0), text)
end)