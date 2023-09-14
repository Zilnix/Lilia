----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.PlayerInteractionOptions = {
    ["Allow This Player To Recognize You"] = {
        Callback = function(client, target)
            local id = client:getChar():getID()
            if SERVER then
                if target:GetPos():DistToSqr(client:GetPos()) > 100000 then return end
                if target:getChar():recognize(id) then
                    netstream.Start(client, "rgnDone")
                    hook.Run("OnCharRecognized", client, id)
                    client:notifyLocalized("recognized")
                else
                    client:notifyLocalized("already_recognized")
                end
            end
        end,
        CanSee = function(client, target) return GM:IsValidTarget(target) and not client:getChar():doesRecognize(target:getChar()) end,
    },
    ["Give Money"] = {
        Callback = function(client, target)
            local function HandleInput(number)
                local amount = math.floor(number or 0)
                if not amount or not isnumber(amount) or amount <= 0 then
                    client:ChatPrint("Invalid Amount!")

                    return
                elseif not client:getChar():hasMoney(amount) then
                    client:ChatPrint("You lack the funds to use this!")

                    return
                end

                if SERVER then
                    target:getChar():giveMoney(amount)
                    client:getChar():takeMoney(amount)
                end

                target:notifyLocalized("moneyTaken", lia.currency.get(amount))
                client:notifyLocalized("moneyGiven", lia.currency.get(amount))
                client:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
            end

            if CLIENT then
                Derma_StringRequest(
                    "Input a Monetary Value",
                    "Input a money value to give",
                    "",
                    function(text)
                        local number = tonumber(text)
                        HandleInput(number)
                    end
                )
            end
        end,
        CanSee = function(client, target) return GM:IsValidTarget(target) and client:getChar():getMoney() > 0 end
    },
    ["Tie Player"] = {
        Callback = function(client, target)
            if SERVER then
                client:getChar():getInv():getFirstItemOfType("tie"):remove()
                client:EmitSound("physics/plastic/plastic_barrel_strain" .. math.random(1, 3) .. ".wav")
            end

            if target:Team() == FACTION_STAFF then
                target:notify("You were just attempted to be restrained by " .. client:Name() .. ".")
                client:notify("You can't tie a staff member!")

                return
            end

            client:setAction("@tying", 3)
            client:doStaredAction(
                target,
                function()
                    if SERVER then
                        target:setRestricted(true)
                        target:setNetVar("tying")
                        client:EmitSound("npc/barnacle/neck_snap1.wav", 100, 140)
                    end
                end,
                3,
                function()
                    client:setAction()
                    target:setAction()
                    if SERVER then
                        target:setNetVar("tying")
                    end
                end
            )

            if SERVER then
                target:setNetVar("tying", true)
                target:setAction("@beingTied", 3)
            end
        end,
        CanSee = function(client, target) return GM:IsValidTarget(target) and client:ConditionsMetForTying(target) end
    },
    ["Open Detailed Description"] = {
        Callback = function(client, target)
            if SERVER then
                net.Start("OpenDetailedDescriptions")
                net.WriteEntity(target)
                net.WriteString(target:getChar():getData("textDetDescData", nil) or "No detailed description found.")
                net.WriteString(target:getChar():getData("textDetDescDataURL", nil) or "No detailed description found.")
                net.Send(client)
            end
        end,
        CanSee = function(client, target) return GM:IsValidTarget(target) end
    },
    ["Set Detailed Description"] = {
        Callback = function(client, target)
            if SERVER then
                net.Start("SetDetailedDescriptions")
                net.WriteString(target:steamName())
                net.Send(client)
            end
        end,
        CanSee = function(client, target) return GM:IsValidTarget(target) end
    },
    ["(Un)Drag Player"] = {
        Callback = function(client, target)
            if target:IsDragged() then
                client:notify("Stopped Dragging Player!")
                SetDrag(nil, client)
                SetDrag(target, nil)
                target:setNetVar("dragged", false)
            else
                SetDrag(target, client)
                client:notify("Started Dragging Player!")
                target:setNetVar("dragged", true)
            end
        end,
        CanSee = function(client, target) return client:ConditionsMetForTyingExtras(target) end
    },
    ["(Un)Blind Player"] = {
        Callback = function(client, target)
            if not client:ConditionsMetForTyingExtras(target) then
                client:notify("Can't (Un)Blind This Player!!")

                return
            else
                if target:IsBlinded() then
                    target:ToggleBlinded()
                    client:notify("Unblinded Player!")
                else
                    target:ToggleBlinded()
                    client:notify("Blinded Player!")
                end
            end
        end,
        CanSee = function(client, target) return client:ConditionsMetForTyingExtras(target) end
    },
    ["(Un)Gag Player"] = {
        Callback = function(client, target)
            if target:IsGagged() then
                target:ToggleGagged()
                client:notify("Ungagged Player!")
            else
                target:ToggleGagged()
                client:notify("Gagged Player!")
            end
        end,
        CanSee = function(client, target) return client:ConditionsMetForTyingExtras(target) end
    },
    ["Force ID Out of Player"] = {
        Callback = function(client, target)
            netstream.Start(client, "OpenID", target)
        end,
        CanSee = function(client, target) return client:ConditionsMetForTyingExtras(target) and lia.module.list["id_system"] end
    },
    ["Show ID"] = {
        Callback = function(client, target)
            netstream.Start(target, "OpenID", client)
        end,
        CanSee = function(client, target) return client:getChar():getInv():hasItem("citizenid") and target:IsPlayer() and lia.module.list["id_system"] end
    },
    ["Request ID"] = {
        Callback = function(client, target)
            net.Start("liaRequestID")
            net.Send(target)
            client:notify("Request to view sent.")
            target.IDRequested = client
            client.IDRequested = target
            client.LastIDRequest = CurTime()
        end,
        CanSee = function(client, target) return IsValid(target) and target:IsPlayer() and not target:getNetVar("restricted") and lia.module.list["id_system"] and not target.IDRequested and not client.IDRequested end
    },
    ["Request ID"] = {
        Callback = function(client, target)
            if (client.LastSearchRequest or 0) > CurTime() - 30 then return "You can't send search requests this quickly!" end
            net.Start("liaRequestSearch")
            net.Send(target)
            client:notify("Request to search sent.")
            target.SearchRequested = client
            client.SearchRequested = target
            client.LastSearchRequest = CurTime()
        end,
        CanSee = function(client, target) return not target:getNetVar("restricted") and not target.SearchRequested and lia.module.list["id_system"] and not client.SearchRequested end
    },
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------