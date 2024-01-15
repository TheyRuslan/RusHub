wait(1)
local Camera = game:GetService("Workspace").CurrentCamera
local CharcaterMiddle = game:GetService("Workspace").Ignore.LocalCharacter.Middle
--[[
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

_G.ruslan = true  -- Global variable to control loop execution

while _G.ruslan do
    local randNumHead = math.random(1, 100)
    local randNumTorso = math.random(1, 100)
    local xdHead, xdTorso

    -- Head probabilities
    if randNumHead <= 50 then
        xdHead = 3.5
    elseif randNumHead <= 80 then
        xdHead = 4.3
    elseif randNumHead <= 90 then
        xdHead = 5
    elseif randNumHead <= 95 then
        xdHead = 5.5
    else
        xdHead = 6
    end

    -- Torso probabilities
    if randNumTorso <= 20 then
        xdTorso = 5
    elseif randNumTorso <= 50 then
        xdTorso = 5.4
    elseif randNumTorso <= 70 then
        xdTorso = 6
    elseif randNumTorso <= 88 then
        xdTorso = 7
    else
        xdTorso = 6
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
            end
            if i:FindFirstChild("Torso") then
                i.Torso.Size = Vector3.new(HitboxExpanderTorso.HitBX, HitboxExpanderTorso.HitBY, HitboxExpanderTorso.HitBZ)
                i.Torso.CanCollide = false
                i.Torso.Color = Color3.fromRGB(66, 144, 245)
                i.Torso.Material = "ForceField"
            end
        end
    end

    game.ReplicatedStorage.Player.Head.Size = Vector3.new(HitboxExpanderHead.HitBX, HitboxExpanderHead.HitBY, HitboxExpanderHead.HitBZ)
    game.ReplicatedStorage.Player.Torso.Size = Vector3.new(HitboxExpanderTorso.HitBX, HitboxExpanderTorso.HitBY, HitboxExpanderTorso.HitBZ)

    wait(0.65)
end
print("yo")
