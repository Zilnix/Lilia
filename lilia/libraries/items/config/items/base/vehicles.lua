﻿
ITEM.name = "Vehicles Base"

ITEM.model = ""

ITEM.desc = ""

ITEM.category = "Vehicles"

ITEM.vehicleid = ""

ITEM.functions.Place = {
    onRun = function(itemTable)
        local client = itemTable.player
        local data = {}
        data.start = client:GetShootPos()
        data.endpos = data.start + client:GetAimVector() * 96
        data.filter = client
        local entity = ents.Create(itemTable.vehicleid)
        entity:SetPos(data.endpos)
        entity:Spawn()
    end
}

