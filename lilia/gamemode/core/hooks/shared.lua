﻿local GM = GM or GAMEMODE
local string = string
function GM:Move(client, moveData)
    local character = client:getChar()
    if not character then return end
    if client:GetMoveType() == MOVETYPE_WALK and moveData:KeyDown(IN_WALK) then
        local mf, ms = 0, 0
        local speed = client:GetWalkSpeed()
        local ratio = lia.config.WalkRatio
        if moveData:KeyDown(IN_FORWARD) then
            mf = ratio
        elseif moveData:KeyDown(IN_BACK) then
            mf = -ratio
        end

        if moveData:KeyDown(IN_MOVELEFT) then
            ms = -ratio
        elseif moveData:KeyDown(IN_MOVERIGHT) then
            ms = ratio
        end

        moveData:SetForwardSpeed(mf * speed)
        moveData:SetSideSpeed(ms * speed)
    end
end

function GM:LiliaLoaded()
    local namecache = {}
    for _, MODULE in pairs(lia.module.list) do
        local authorID = (tonumber(MODULE.author) and tostring(MODULE.author)) or (string.match(MODULE.author, "STEAM_") and util.SteamIDTo64(MODULE.author)) or "Unknown"
        if authorID then
            if namecache[authorID] ~= nil then
                MODULE.author = namecache[authorID]
            else
                steamworks.RequestPlayerInfo(authorID, function(newName)
                    namecache[authorID] = newName
                    MODULE.author = newName or MODULE.author
                end)
            end
        end
    end

    lia.module.namecache = namecache
end

function GM:InitPostEntity()
    if SERVER then
        lia.faction.formatModelData()
        timer.Simple(2, function() lia.entityDataLoaded = true end)
        lia.db.waitForTablesToLoad():next(function()
            hook.Run("LoadData")
            hook.Run("PostLoadData")
        end)
    else
        lia.joinTime = RealTime() - 0.9716
        if system.IsWindows() and not system.HasFocus() then system.FlashWindow() end
    end
end

function GM:OnCharVarChanged(character, varName, oldVar, newVar)
    if lia.char.varHooks[varName] then
        for _, v in pairs(lia.char.varHooks[varName]) do
            v(character, oldVar, newVar)
        end
    end
end

local function registerFunctions(scope)
    local GamemodeFunctions = {
        server = {
            {
                name = "PlayerSpray",
                returnValue = true
            },
            {
                name = "PlayerDeathSound",
                returnValue = true
            },
            {
                name = "CanPlayerSuicide",
                returnValue = false
            },
            {
                name = "AllowPlayerPickup",
                returnValue = false
            },
            {
                name = "CharacterLoaded",
                args = {"id"},
                replacement = "CharLoaded"
            },
            {
                name = "PreCharacterDelete",
                args = {"id"},
                replacement = "PreCharDelete"
            },
            {
                name = "OnCharacterDelete",
                args = {"client", "id"},
                replacement = "OnCharDelete"
            },
            {
                name = "onCharCreated",
                args = {"client", "character", "data"},
                replacement = "OnCharCreated"
            },
            {
                name = "onTransferred",
                args = {"client"},
                replacement = "OnTransferred"
            },
            {
                name = "CharacterPreSave",
                args = {"character"},
                replacement = "CharPreSave"
            }
        },
        client = {
            {
                name = "HUDDrawTargetID",
                returnValue = false
            },
            {
                name = "HUDDrawPickupHistory",
                returnValue = false
            },
            {
                name = "HUDAmmoPickedUp",
                returnValue = false
            },
            {
                name = "DrawDeathNotice",
                returnValue = false
            },
            {
                name = "CanDisplayCharacterInfo",
                args = {"client", "id"},
                replacement = "CanDisplayCharInfo"
            },
            {
                name = "KickedFromCharacter",
                args = {"id", "isCurrentChar"},
                replacement = "KickedFromChar"
            },
            {
                name = "CharacterListLoaded",
                args = {"newCharList"},
                replacement = "CharListLoaded"
            },
            {
                name = "CharacterListUpdated",
                args = {"oldCharList", "newCharList"},
                replacement = "CharListUpdated"
            }
        },
        shared = {
            {
                name = "CharacterMaxStamina",
                args = {"character"},
                replacement = "CharMaxStamina"
            },
            {
                name = "GetMaxPlayerCharacter",
                args = {"client"},
                replacement = "GetMaxPlayerChar"
            },
            {
                name = "CanPlayerCreateCharacter",
                args = {"client"},
                replacement = "CanPlayerCreateChar"
            }
        }
    }

    for _, funcData in ipairs(GamemodeFunctions[scope]) do
        if funcData.returnValue ~= nil then
            GM[funcData.name] = function() return funcData.returnValue end
        elseif funcData.replacement then
            GM[funcData.name] = function(...)
                local args = {...}
                LiliaDeprecated(funcData.name, function() hook.Run(funcData.replacement, unpack(args)) end)
            end
        end
    end
end

if SERVER then registerFunctions("server") end
if CLIENT then registerFunctions("client") end
registerFunctions("shared")