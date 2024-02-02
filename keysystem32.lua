local Camera = game:GetService("Workspace").CurrentCamera
local CharcaterMiddle = game:GetService("Workspace").Ignore.LocalCharacter.Middle


for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
if v:FindFirstChild("Hitbox") then
v.Hitbox.Transparency = 0.74
end
end
--[[
local originalTerrainDecoration = gethiddenproperty(game.Workspace.Terrain, "Decoration")
local originalGlobalShadows = gethiddenproperty(game:GetService("Lighting"), "GlobalShadows")

-- Hook para modificar la propiedad "Decoration" del terreno
local terrainHook = hookmetamethod(game, "__newindex", newcclosure(function(...)
    local self, k, v = ...
    if not checkcaller() and self == game.Workspace.Terrain and k == "Decoration" then
        return true
    end
    return terrainHook(...)
end))

-- Hook para modificar la propiedad "GlobalShadows" de Lighting
local shadowsHook = hookmetamethod(game, "__newindex", newcclosure(function(...)
    local self, k, v = ...
    if not checkcaller() and self == game:GetService("Lighting") and k == "GlobalShadows" then
        return true
    end
    return shadowsHook(...)
end))

sethiddenproperty(game.Workspace.Terrain, "Decoration", false)
sethiddenproperty(game:GetService("Lighting"), "GlobalShadows", false)
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
        return Vector3.new(0.6530659198760986, 2.220424175262451, 1.4367451667785645)
    end
    return antihitbox2(...)
end))
local antixray
antixray = hookmetamethod(game, "__index", newcclosure(function(...)
local self, k = ...
if not checkcaller() and k == "Hitbox" and self.Name == "Transparency" then
	return 1
end
return antixray(...)
end))
    local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
    local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()
   _G.blatant = false
   _G.legit = true

    wait(1)
    if _G.blatant == true then
    Notification:Notify(
    {Title = "Hitbox Extender Added  blatant [✅]", Description = "Ruslan Baby (LOADED) 🔥"},
    {OutlineColor = Color3.fromRGB(80, 80, 80),Time = 5, Type = "default"}
    )
   end


while _G.blatant == true do
    local randNumHead = math.random(1, 100)
    local randNumTorso = math.random(1, 100)
    local xdHead, xdTorso

    if randNumHead <= 50 then
        xdHead = 5.35
    elseif randNumHead <= 80 then
        xdHead = 6
    elseif randNumHead <= 90 then
        xdHead = 6.6
    elseif randNumHead <= 95 then
        xdHead = 7.2
    else
        xdHead = 7.3
    end

    if randNumTorso <= 20 then
        xdTorso = 5.9
    elseif randNumTorso <= 50 then
        xdTorso = 6.4
    elseif randNumTorso <= 70 then
        xdTorso = 6.6
    elseif randNumTorso <= 88 then
        xdTorso = 7.15
    else
        xdTorso = 7.4
    end

    local HitboxExpanderHead = { HitBX = xdHead, HitBY = xdHead, HitBZ = xdHead }
    local HitboxExpanderTorso = { HitBX = xdTorso, HitBY = xdTorso, HitBZ = xdTorso }

    for _, i in pairs(workspace:GetChildren()) do
        if i:IsA("Model") and i:FindFirstChild("HumanoidRootPart") then
            if i:FindFirstChild("Head") then
                i.Head.Size = Vector3.new(xdHead, xdHead, xdHead)
                i.Head.CanCollide = false
                i.Head.Color = Color3.fromRGB(144, 66, 245)
                i.Head.Material = "ForceField"
                i.Head.Transparency = 0.88
            end
            if i:FindFirstChild("Torso") then
                i.Torso.Size = Vector3.new(xdTorso, xdTorso, xdTorso)
                i.Torso.CanCollide = false
                i.Torso.Color = Color3.fromRGB(66, 144, 245)
                i.Torso.Material = "ForceField"
                i.Torso.Transparency = 0.66
            end
        end
    end

    wait(0.5)
end


    if _G.legit == true then
    Notification:Notify(
    {Title = "Hitbox Extender Added legit [✅]", Description = "Ruslan Baby (LOADED) 🔥"},
    {OutlineColor = Color3.fromRGB(80, 80, 80),Time = 5, Type = "default"}
    )
   end


while _G.legit == true do
    local randNumHead = math.random(1, 100)
    local randNumTorso = math.random(1, 100)
    local xdHead, xdTorso

    if randNumHead <= 50 then
        xdHead = 2.7
    elseif randNumHead <= 80 then
        xdHead = 2.9
    elseif randNumHead <= 90 then
        xdHead = 3
    elseif randNumHead <= 95 then
        xdHead = 3.2
    else
        xdHead = 3.4
    end

    if randNumTorso <= 20 then
        xdTorso = 5.45
    elseif randNumTorso <= 50 then
        xdTorso = 5.66
    elseif randNumTorso <= 70 then
        xdTorso = 5.8
    elseif randNumTorso <= 88 then
        xdTorso = 6
    else
        xdTorso = 6.3
    end

    local HitboxExpanderHead = { HitBX = xdHead, HitBY = xdHead, HitBZ = xdHead }
    local HitboxExpanderTorso = { HitBX = xdTorso, HitBY = xdTorso, HitBZ = xdTorso }

    for _, i in pairs(workspace:GetChildren()) do
        if i:IsA("Model") and i:FindFirstChild("HumanoidRootPart") then
            if i:FindFirstChild("Head") then
                i.Head.Size = Vector3.new(xdHead, xdHead, xdHead)
                i.Head.CanCollide = false
                i.Head.Color = Color3.fromRGB(144, 66, 245)
                i.Head.Material = "ForceField"
                i.Head.Transparency = 0.88
            end
            if i:FindFirstChild("Torso") then
                i.Torso.Size = Vector3.new(xdTorso, xdTorso, xdTorso)
                i.Torso.CanCollide = false
                i.Torso.Color = Color3.fromRGB(66, 144, 245)
                i.Torso.Material = "ForceField"
                i.Torso.Transparency = 0.66
            end
        end
    end

    wait(0.5)
end

    game.ReplicatedStorage.Player.Head.Size = Vector3.new(HitboxExpanderHead.HitBX, HitboxExpanderHead.HitBY, HitboxExpanderHead.HitBZ)
    game.ReplicatedStorage.Player.Torso.Size = Vector3.new(HitboxExpanderTorso.HitBX, HitboxExpanderTorso.HitBY, HitboxExpanderTorso.HitBZ)

    wait(0.5)
end
