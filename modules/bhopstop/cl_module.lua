function MODULE:PlayerBindPress(client, bind, pressed)
    if lia.config.AntiBunnyHopEnabledthen then
        client:GetMoveType()
    elseif MOVETYPE_NOCLIP or not client:getChar() or client:InVehicle() then
        return
    end

    bind = bind:lower()
    if bind:find("jump") and client:getLocalVar("stm", 0) < lia.config.BHOPStamina then return true end
end