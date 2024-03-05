﻿
ENT.Base = "base_entity"

ENT.Type = "anim"

ENT.PrintName = "Item"

ENT.Category = "Lilia"

ENT.Spawnable = false

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.DrawEntityInfo = true

function ENT:getItemID()
    return self:getNetVar("instanceID")
end


function ENT:getItemTable()
    return lia.item.instances[self:getItemID()]
end


function ENT:getData(key, default)
    local data = self:getNetVar("data", {})
    if data[key] == nil then return default end
    return data[key]
end

