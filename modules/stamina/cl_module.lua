-------------------------------------------------------------------------------------------------------------------------~
local stmBlurAlpha = 0
local stmBlurAmount = 0

-- Called whenever the HUD should be drawn.
function MODULE:HUDPaintBackground()
    local frametime = RealFrameTime()
    if not lia.config.StaminaBlur then return end

    -- Account for blurring effects when the player stamina is depleted
    if LocalPlayer():getLocalVar("stm", 50) <= 5 then
        stmBlurAlpha = Lerp(frametime / 2, stmBlurAlpha, 255)
        stmBlurAmount = Lerp(frametime / 2, stmBlurAmount, 5)
        lia.util.drawBlurAt(0, 0, ScrW(), ScrH(), stmBlurAmount, 0.2, stmBlurAlpha)
    end
end

-------------------------------------------------------------------------------------------------------------------------~
if lia.bar then
    lia.bar.add(function()
        return LocalPlayer():getLocalVar("stm", 0) / lia.config.DefaultStamina
    end, Color(200, 200, 40), nil, "stm")
end