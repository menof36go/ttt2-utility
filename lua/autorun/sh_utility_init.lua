if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("scripts/sh_addonutil.lua")
end

include("scripts/sh_addonutil.lua")

if CLIENT then
    SetupAddons()

    hook.Remove("HUDPaint", "example_hook")

    --[[timer.Simple(8, function()
        local ourMat = GetMapIconAsMaterial("ttt_towers_a3") or  Material("models/wireframe") -- Calling Material() every frame is quite expensive
        print("Our mat", ourMat:IsError())
        PrintTable(ourMat:GetKeyValues())
        
        hook.Add("HUDPaint", "testImage", function()
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( ourMat	) -- If you use Material, cache it!
            surface.DrawTexturedRect( 5, 5, 128, 128 )
        end)
    end)]]
end

UTILITYADDON = true