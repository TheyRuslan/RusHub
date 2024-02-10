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
        Boxes = false,
        BoxesColor = Color3.fromRGB(144, 66, 245),
        Sleeping = false,
        SleepingColor = Color3.fromRGB(255, 255, 255),
        Distances = false,
        DistanceColor = Color3.fromRGB(255, 255, 255),
        Armour = false,
        ArmourColor = Color3.fromRGB(255, 255, 255),
        Tool = false,
        ToolColor = Color3.fromRGB(255, 255, 255),
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
    Connections = {},
    Players = {}
}

local Fonts = {
    ["UI"] = 0,
    ["System"] = 1,
    ["Plex"] = 2,
    ["Monospace"] = 3
}

local cache = {}

-- Función para limpiar el cache
local MAX_CACHE_SIZE = 100

local function ClearCache()
    while #cache > MAX_CACHE_SIZE do
        table.remove(cache, 1)
    end
end

-- Llamar a la función de limpieza de cache periódicamente
local CLEAN_INTERVAL = 60  -- Limpiar el cache cada 60 segundos

local function PeriodicCacheCleanup()
    while true do
        wait(CLEAN_INTERVAL)
        ClearCache()
    end
end

-- Iniciar la función de limpieza de cache en un hilo aparte
spawn(PeriodicCacheCleanup)

-- Functions
function Functions:IsSleeping(Model)
    if Model and Model:FindFirstChild("AnimationController") and Model.AnimationController:FindFirstChild("Animator") then
        for i, v in pairs(Model.AnimationController.Animator:GetPlayingAnimationTracks()) do
            if v.Animation.AnimationId == "rbxassetid://13280887764" then
                return true
            else
                return false
            end
        end
    end
end

function Functions:Draw(Type, Properties)
    if not Type and not Properties then
        return
    end
    local drawing = Drawing.new(Type)
    for i, v in pairs(Properties) do
        drawing[i] = v
    end
    table.insert(Esp.Drawings, drawing)
    return drawing
end

function Esp:CreateEsp(PlayerTable)
    if not PlayerTable then
        return
    end
    local drawings = {}
    drawings.Box = Functions:Draw("Square", {Transparency = 0.35, Color = Esp.Settings.BoxesColor, Visible = false, Visible = false})
    drawings.Sleeping = Functions:Draw("Text", {Text = "Nil", Font = Esp.Settings.TextFont, Size = Esp.Settings.TextSize, Center = true, Outline = Esp.Settings.TextOutline, Color = Esp.Settings.SleepingColor, ZIndex = 2, Visible = false})
    drawings.Distance = Functions:Draw("Text", {Text = "Nil", Font = Esp.Settings.TextFont, Size = Esp.Settings.TextSize, Center = true, Outline = Esp.Settings.TextOutline, Color = Esp.Settings.SleepingColor, ZIndex = 2, Visible = false})
    drawings.Armour = Functions:Draw("Text", {Text = "None", Font = Esp.Settings.TextFont, Size = Esp.Settings.TextSize, Center = false, Outline = Esp.Settings.TextOutline, Color = Esp.Settings.ArmourColor, ZIndex = 2, Visible = false})
    drawings.ViewAngle = Functions:Draw("Line", {Thickness = Esp.Settings.ViewAngleThickness, Transparency = Esp.Settings.ViewAngleTransparrency, Color = Esp.Settings.ViewAngleColor, ZIndex = 2, Visible = false})
    drawings.PlayerTable = PlayerTable
    Esp.Players[PlayerTable.model] = drawings
end

function Esp:RemoveEsp(PlayerTable)
    if not PlayerTable and PlayerTable.model ~= nil then
        return
    end
    esp = Esp.Players[PlayerTable.model]
    if not esp then
        return
    end
    for i, v in pairs(esp) do
        if not type(v) == "table" then
            v:Remove()
        end
    end
    Esp.Players[PlayerTable.model] = nil
end

function Esp:UpdateEsp()
    for i,v in pairs(Esp.Players) do
        local Character = i
        local Position,OnScreen = Camera:WorldToViewportPoint(Character:GetPivot().Position);
        local scale = 1 / (Position.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100;
        local w,h = math.floor(32 * scale), math.floor(60 * scale);
        local x,y = math.floor(Position.X), math.floor(Position.Y);
        local Distance = (CharcaterMiddle:GetPivot().Position-Character:GetPivot().Position).Magnitude
        local BoxPosX,BoxPosY = math.floor(x - w * 0.5),math.floor(y - h * 0.5)
        local offsetCFrame = CFrame.new(0, 0, -4)
        local sleeping = Functions:IsSleeping(Character)
        if Character and Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("Head") then
            local TeamTag = Character.Head.Teamtag.Enabled
            if OnScreen == true and Esp.Settings.Boxes == true and Distance <= Esp.Settings.RenderDistance then
                if Esp.Settings.TeamCheck == true and TeamTag == false then
                    v.Box.Visible = true
                elseif Esp.Settings.TeamCheck == true and TeamTag == true then
                    v.Box.Visible = false
                else
                    v.Box.Visible = true
                end
                if Esp.Settings.TargetSleepers == true and sleeping == true then
                    v.Box.Visible = false
                end
                v.Box.Position = Vector2.new(BoxPosX, BoxPosY)
                v.Box.Size = Vector2.new(w, h)
                v.Box.Color = Esp.Settings.BoxesColor
            else
                v.Box.Visible = false
            end
            if OnScreen == true and Esp.Settings.ViewAngle == true and Distance <= Esp.Settings.RenderDistance then
                if Esp.Settings.TeamCheck == true and TeamTag == false then
                    v.ViewAngle.Visible = true
                elseif Esp.Settings.TeamCheck == true and TeamTag == true then
                    v.ViewAngle.Visible = false
                else
                    v.ViewAngle.Visible = true
                end
                if Esp.Settings.TargetSleepers == true and sleeping == true then
                    v.ViewAngle.Visible = false
                end
                v.ViewAngle.Color = Esp.Settings.ViewAngleColor
                v.ViewAngle.Thickness = Esp.Settings.ViewAngleThickness
                v.Transparency = Esp.Settings.ViewAngleTransparrency
                local headpos = Camera:WorldToViewportPoint(Character.Head.Position)
                local offsetCFrame = CFrame.new(0, 0, -4)
                v.ViewAngle.From = Vector2.new(headpos.X, headpos.Y)
                local value = math.clamp(1 / Distance * 100, 0.1, 1)
                local dir = Character.Head.CFrame:ToWorldSpace(offsetCFrame)
                offsetCFrame = offsetCFrame * CFrame.new(0, 0, 0.4)
                local dirpos = Camera:WorldToViewportPoint(Vector3.new(dir.X, dir.Y, dir.Z))
                if OnScreen == true then
                    v.ViewAngle.To = Vector2.new(dirpos.X, dirpos.Y)
                    offsetCFrame = CFrame.new(0, 0, -4)
                end
            else
                v.ViewAngle.Visible = false
            end
        else
            v.Box.Visible = false
            v.Armour.Visible = false
            v.Distance.Visible = false
            v.ViewAngle.Visible = false
            v.Sleeping.Visible = false
        end
    end
end

local PlayerUpdater = game:GetService("RunService").RenderStepped
local PlayerConnection = PlayerUpdater:Connect(function()
    Esp:UpdateEsp()
end)

for i, v in pairs(workspace:GetChildren()) do
    if v:FindFirstChild("HumanoidRootPart") then
        table.insert(cache, v)
        Esp:CreateEsp({model = v})
    end
end

game:GetService("Workspace").ChildAdded:Connect(function(child)
    if child:FindFirstChild("HumanoidRootPart") and not table.find(cache, child) then
        table.insert(cache, child)
        Esp:CreateEsp({model = child})
    end
end)

local UserInputService = game:GetService("UserInputService")

local function ExpandHitbox()
    local HitboxExpanderHead = { HitBX = 6.4, HitBY = 6.4, HitBZ = 6.4 }
    local HitboxExpanderTorso = { HitBX = 7, HitBY = 7, HitBZ = 7 }

    for _, i in pairs(workspace:GetChildren()) do
        if i:FindFirstChild("HumanoidRootPart") then
            if not Functions:IsSleeping(i) then  -- Verifica si el personaje no está dormido
                if i:FindFirstChild("Head") then
                    i.Head.Size = Vector3.new(HitboxExpanderHead.HitBX, HitboxExpanderHead.HitBY, HitboxExpanderHead.HitBZ)
                    i.Head.CanCollide = false
                    i.Head.Color = Color3.fromRGB(144, 66, 245)
                    i.Head.Material = "ForceField"
                    i.Head.Transparency = 0.88
                end
                if i:FindFirstChild("Torso") then
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
