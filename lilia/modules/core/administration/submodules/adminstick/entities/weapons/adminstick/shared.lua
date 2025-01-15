﻿SWEP.Author = "Samael"
SWEP.PrintName = "Admin Stick"
SWEP.Purpose = "Instructions: Press R when looking at someone to select them \nPress Shift R to select yourself \nLeft click to open menu \nRight click with selection to freeze."
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.IsAlwaysRaised = true
SWEP.Spawnable = true
SWEP.ViewModel = Model("models/weapons/v_stunstick.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
function SWEP:DrawWorldModel()
    if self:GetOwner():GetMoveType() == MOVETYPE_NOCLIP then return end
    self:DrawModel()
end

function SWEP:Initialize()
    self:SetHoldType("melee")
end