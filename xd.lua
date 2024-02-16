-- Trident [Ruslan]

local Camera = game:GetService("Workspace").CurrentCamera
local CharcaterMiddle = game:GetService("Workspace").Ignore.LocalCharacter.Middle

local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

Notification:Notify(
    {Title = "Hitbox Extender Added [✅]", Description = "Ruslan Baby (LOADED) 🔥"},
    {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = "default"}
)

local antihitbox, antihitbox2

antihitbox = hookmetamethod(game, "__newindex", newcclosure(function(...)
    local self, k = ...
    if not checkcaller() and k == "Size" and self.Name == "Head" then
        return Vector3.new(1.672248125076294, 0.835624098777771, 0.835624098777771)
    end
    return antihitbox(...)
end))

antihitbox2 = hookmetamethod(game, "__index", newcclosure(function(...)
    local self, k = ...
    if not checkcaller() and k == "Size" and self.Name == "Torso" then
        return Vector3.new(0.6530659198760986, 2.220424175262451, 1.4367451667785645)
    end
    return antihitbox2(...)
end))

local UserInputService = game:GetService("UserInputService")

local function ExpandHitbox()
    local HitboxExpanderHead = { HitBX = 6.4, HitBY = 6.4, HitBZ = 6.4 }
    local HitboxExpanderTorso = { HitBX = 7, HitBY = 7, HitBZ = 7 }

    for _, i in pairs(workspace:GetChildren()) do
        if i:FindFirstChild("HumanoidRootPart") then
            if i:FindFirstChild("Head") then
                if i.Head.Size ~= Vector3.new(HitboxExpanderHead.HitBX, HitboxExpanderHead.HitBY, HitboxExpanderHead.HitBZ) then
                    i.Head.Size = Vector3.new(HitboxExpanderHead.HitBX, HitboxExpanderHead.HitBY, HitboxExpanderHead.HitBZ)
                    i.Head.CanCollide = false
                    i.Head.Color = Color3.fromRGB(144, 66, 245)
                    i.Head.Material = "ForceField"
                end
            end
            if i:FindFirstChild("Torso") then
                if i.Torso.Size ~= Vector3.new(HitboxExpanderTorso.HitBX, HitboxExpanderTorso.HitBY, HitboxExpanderTorso.HitBZ) then
                    i.Torso.Size = Vector3.new(HitboxExpanderTorso.HitBX, HitboxExpanderTorso.HitBY, HitboxExpanderTorso.HitBZ)
                    i.Torso.CanCollide = false
                    i.Torso.Color = Color3.fromRGB(66, 144, 245)
                    i.Torso.Material = "ForceField"
                    i.Torso.Transparency = 0.66
                end
            end
        end
    end
end

-- Detectar la pulsación de la tecla P
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.P then
        ExpandHitbox() -- Llamar a la función para expandir el hitbox
        Notification:Notify(
        {Title = "Hitbox Extended [✅]", Description = "x1 🔥"},
        {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = "default"}
       )
    end
end)
