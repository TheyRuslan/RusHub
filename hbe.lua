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

local Functions = {}
local Esp = {
    Settings = {
        Tool = false,
        ToolColor = Color3.fromRGB(255, 255, 255),
        Sleeping = false,
        SleepingColor = Color3.fromRGB(255, 255, 255),
        Armour = false,
        ArmourColor = Color3.fromRGB(255, 255, 255),
        ViewAngle = true,
        ViewAngleColor = Color3.fromRGB(144, 66, 245),
        ViewAngleThickness = 1,
        ViewAngleTransparency = 1,
        TextFont = 2,
        TextOutline = true,
        TextSize = 13,
        RenderDistance = 700,
        TeamCheck = true,
        TargetSleepers = true,
        MinTextSize = 11
    },
    Drawings = {},
    Players = {}
}

local cache = {}

-- Función para limpiar el cache
local MAX_CACHE_SIZE = 100
local CLEAN_INTERVAL = 60  -- Limpiar el cache cada 60 segundos

local function ClearCache()
    while #cache > MAX_CACHE_SIZE do
        table.remove(cache, 1)
    end
end

-- Llamar a la función de limpieza de cache periódicamente
spawn(function()
    while true do
        wait(CLEAN_INTERVAL)
        ClearCache()
    end
end)

-- Functions
function Functions:IsSleeping(Model)
    if Model and Model:FindFirstChild("AnimationController") then
        for _, v in pairs(Model.AnimationController:GetDescendants()) do
            if v:IsA("AnimationTrack") and v.Animation.AnimationId == "rbxassetid://13280887764" then
                return true
            end
        end
    end
    return false
end

function Esp:CreateEsp(Player)
    local ViewAngle = Drawing.new("Line")
    ViewAngle.Thickness = Esp.Settings.ViewAngleThickness
    ViewAngle.Transparency = Esp.Settings.ViewAngleTransparency
    ViewAngle.Visible = false
    ViewAngle.Color = Esp.Settings.ViewAngleColor
    self.Drawings[Player] = { ViewAngle = ViewAngle }
end

function Esp:RemoveEsp(Player)
    local drawings = self.Drawings[Player]
    if not drawings then return end
    for _, drawing in pairs(drawings) do
        if type(drawing) == "table" then
            drawing:Remove()
        end
    end
    self.Drawings[Player] = nil
end

function Esp:UpdateEsp()
    for Player, drawings in pairs(self.Drawings) do
        local Character = Player.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("Head") then
            local Position, OnScreen = Camera:WorldToViewportPoint(Character.Head.Position)
            local Distance = (CharcaterMiddle:GetPivot().Position - Character:GetPivot().Position).Magnitude
            local sleeping = Functions:IsSleeping(Character)
            if OnScreen and Esp.Settings.ViewAngle and Distance <= Esp.Settings.RenderDistance then
                drawings.ViewAngle.Visible = true
                local headPos = Camera:WorldToViewportPoint(Character.Head.Position)
                local dir = Character.Head.CFrame:ToWorldSpace(CFrame.new(0, 0, -4))
                local dirPos = Camera:WorldToViewportPoint(dir.Position)
                drawings.ViewAngle.From = Vector2.new(headPos.X, headPos.Y)
                drawings.ViewAngle.To = Vector2.new(dirPos.X, dirPos.Y)
            else
                drawings.ViewAngle.Visible = false
            end
        else
            self:RemoveEsp(Player)
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    Esp:UpdateEsp()
end)

game:GetService("Workspace").ChildAdded:Connect(function(child)
    if child:IsA("Model") and child:FindFirstChild("HumanoidRootPart") then
        table.insert(cache, child)
        Esp:CreateEsp(child)
    end
end)

for _, child in ipairs(game:GetService("Workspace"):GetChildren()) do
    if child:IsA("Model") and child:FindFirstChild("HumanoidRootPart") then
        table.insert(cache, child)
        Esp:CreateEsp(child)
    end
end


local UserInputService = game:GetService("UserInputService")

local function ExpandHitbox()
    local HitboxExpanderHead = { HitBX = 6.4, HitBY = 6.4, HitBZ = 6.4 }
    local HitboxExpanderTorso = { HitBX = 7, HitBY = 7, HitBZ = 7 }

    for _, i in pairs(workspace:GetChildren()) do
        if i:FindFirstChild("HumanoidRootPart") then
            if not Functions:IsSleeping(i) then  -- Verifica si el personaje no está dormido
                if i:FindFirstChild("Head") then
                    if i.Head.Size ~= Vector3.new(HitboxExpanderHead.HitBX, HitboxExpanderHead.HitBY, HitboxExpanderHead.HitBZ) then
                        i.Head.Size = Vector3.new(HitboxExpanderHead.HitBX, HitboxExpanderHead.HitBY, HitboxExpanderHead.HitBZ)
                        i.Head.CanCollide = false
                        i.Head.Color = Color3.fromRGB(144, 66, 245)
                        i.Head.Material = "ForceField"
                    end
                    if i.Head.Transparency ~= 0.88 then
                        i.Head.Transparency = 0.88
                    end
                end
                if i:FindFirstChild("Torso") then
                    if i.Torso.Size ~= Vector3.new(HitboxExpanderTorso.HitBX, HitboxExpanderTorso.HitBY, HitboxExpanderTorso.HitBZ) then
                        i.Torso.Size = Vector3.new(HitboxExpanderTorso.HitBX, HitboxExpanderTorso.HitBY, HitboxExpanderTorso.HitBZ)
                        i.Torso.CanCollide = false
                        i.Torso.Color = Color3.fromRGB(66, 144, 245)
                        i.Torso.Material = "ForceField"
                    end
                    if i.Torso.Transparency ~= 0.66 then
                        i.Torso.Transparency = 0.66
                    end
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

