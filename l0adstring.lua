wait(1)
local Camera = game:GetService("Workspace").CurrentCamera
local CharcaterMiddle = game:GetService("Workspace").Ignore.LocalCharacter.Middle
--[[

local originalTerrainDecoration = gethiddenproperty(game.Workspace.Terrain, "Decoration")
local originalGlobalShadows = gethiddenproperty(game:GetService("Lighting"), "GlobalShadows")

-- Hook para modificar la propiedad "Decoration" del terreno
local terrainHook = hookmetamethod(game, "__newindex", newcclosure(function(...)
    local self, k, v = ...
    if not checkcaller() and self == game.Workspace.Terrain and k == "Decoration" then
        return false
    end
    return terrainHook(...)
end))

-- Hook para modificar la propiedad "GlobalShadows" de Lighting
local shadowsHook = hookmetamethod(game, "__newindex", newcclosure(function(...)
    local self, k, v = ...
    if not checkcaller() and self == game:GetService("Lighting") and k == "GlobalShadows" then
        return false
    end
    return shadowsHook(...)
end))

local originalEqualizerSoundEffect = game:GetService("SoundService").PlayerHitHeadshot.EqualizerSoundEffect
local originalSoundId = game:GetService("SoundService").PlayerHitHeadshot.SoundId

-- Hook para modificar el sonido EqualizerSoundEffect
local soundHook = hookmetamethod(game, "__newindex", newcclosure(function(...)
    local self, k, v = ...
    if not checkcaller() and self == originalEqualizerSoundEffect and k == "HighGain" then
        return -1.5
    end
    return soundHook(...)
end))

-- Hook para modificar el SoundId
local soundIdHook = hookmetamethod(game, "__newindex", newcclosure(function(...)
    local self, k, v = ...
    if not checkcaller() and self == originalSoundId and k == "SoundId" then
        return "rbxassetid://8726881116"
    end
    return soundIdHook(...)
end))

local antihideprop

antihideprop = hookmetamethod(game.Workspace.Terrain, "__newindex", newcclosure(function(...)
    local self, k, v = ...
    if not checkcaller() and k == "Decoration" then
        print("Modificación bloqueada. Manteniendo el valor en true.")
        return true  -- Mantén el valor como true
    end
    return antihideprop(...)
end))


local antihideshadows

antihideshadows = hookmetamethod(game:GetService("Lighting"), "__newindex", newcclosure(function(...)
    local self, k, v = ...
    if not checkcaller() and k == "GlobalShadows" then
        print("Modificación bloqueada. Manteniendo el valor en true.")
        return true  -- Mantén el valor como true
    end
    return antihideshadows(...)
end))

local antiSoundChanges

antiSoundChanges = hookmetamethod(game:GetService("SoundService").PlayerHitHeadshot, "__newindex", newcclosure(function(...)
    local self, k, v = ...
    
    if not checkcaller() and (k == "EqualizerSoundEffect" or k == "SoundId") then
        print("Modificación bloqueada. Manteniendo los valores originales.")
        return true  -- Mantén el valor original
    end
    
    return antiSoundChanges(...)
end))


local defaultBrightness = game:GetService("Lighting").Brightness

local hookBrightness = hookmetamethod(game, "__newindex", newcclosure(function(...)
    local self, property, value = ...
    if self:IsA("Lighting") and property == "Brightness" then
        warn("¡Alguien está jugando con el brillo!")
        return hookBrightness(self, property, defaultBrightness) -- Establecer el brillo actual como predeterminado
    end
    return hookBrightness(...)
end))

game:GetService("SoundService").PlayerHitHeadshot.EqualizerSoundEffect.HighGain = -1.5
game:GetService("SoundService").PlayerHitHeadshot.SoundId = "rbxassetid://8726881116"

sethiddenproperty(game.Workspace.Terrain, "Decoration", false)
sethiddenproperty(game:GetService("Lighting"), "GlobalShadows", false)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dustin21335/Full-bright/main/fullbright.lua"))()
]]
local antihitbox
antihitbox = hookmetamethod(game, "__newindex", newcclosure(function(...)
    local self, k = ...
    if not checkcaller() and k == "Size" and self.Name == "Head" then
        return Vector3.new(1.672248125076294, 0.835624098777771, 0.835624098777771)
    end
    return antihitbox(...)
end))

local antihitbox2
antihitbox2 = hookmetamethod(game, "__index", newcclosure(function(...)
    local self, k = ...
    if not checkcaller() and k == "Size" and self.Name == "Torso" then
        return 0.6530659198760986, 2.220424175262451, 1.4367451667785645
    end
    return antihitbox2(...)
end))

_G.ruslan = true

while _G.ruslan do
    local randNumHead = math.random(1, 100)
    local randNumTorso = math.random(1, 100)
    local xdHead, xdTorso

    if randNumHead <= 50 then
        xdHead = 4.7
    elseif randNumHead <= 80 then
        xdHead = 5.8
    elseif randNumHead <= 90 then
        xdHead = 6
    elseif randNumHead <= 95 then
        xdHead = 6.8
    else
        xdHead = 6
    end

    if randNumTorso <= 20 then
        xdTorso = 5.3
    elseif randNumTorso <= 50 then
        xdTorso = 5.8
    elseif randNumTorso <= 70 then
        xdTorso = 6
    elseif randNumTorso <= 88 then
        xdTorso = 6.5
    else
        xdTorso = 7
    end

    local HitboxExpanderHead = { HitBX = xdHead, HitBY = xdHead, HitBZ = xdHead }
    local HitboxExpanderTorso = { HitBX = xdTorso, HitBY = xdTorso, HitBZ = xdTorso }

    for _, i in pairs(workspace:GetChildren()) do
        if i:FindFirstChild("HumanoidRootPart") then
            if i:FindFirstChild("Head") then
                i.Head.Size = Vector3.new(HitboxExpanderHead.HitBX, HitboxExpanderHead.HitBY, HitboxExpanderHead.HitBZ)
                i.Head.CanCollide = false
                i.Head.Color = Color3.fromRGB(144, 66, 245)
                i.Head.Material = "ForceField"
                i.Head.Transparency = 0.9
            end
            if i:FindFirstChild("Torso") then
                i.Torso.Size = Vector3.new(HitboxExpanderTorso.HitBX, HitboxExpanderTorso.HitBY, HitboxExpanderTorso.HitBZ)
                i.Torso.CanCollide = false
                i.Torso.Color = Color3.fromRGB(66, 144, 245)
                i.Torso.Material = "ForceField"
                i.Torso.Transparency = 0.4
            end
        end
    end

    game.ReplicatedStorage.Player.Head.Size = Vector3.new(HitboxExpanderHead.HitBX, HitboxExpanderHead.HitBY, HitboxExpanderHead.HitBZ)
    game.ReplicatedStorage.Player.Torso.Size = Vector3.new(HitboxExpanderTorso.HitBX, HitboxExpanderTorso.HitBY, HitboxExpanderTorso.HitBZ)

    wait(0.5)
end
