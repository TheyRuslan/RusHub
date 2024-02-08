local Camera = game:GetService("Workspace").CurrentCamera
local CharcaterMiddle = game:GetService("Workspace").Ignore.LocalCharacter.Middle

local Esp = {
    Settings = {
        ViewAngle = true,
        ViewAngleColor = Color3.fromRGB(144, 66, 245),
        ViewAngleThickness = 1,
        ViewAngleTransparency = 1,
        RenderDistance = 700
    },
    Drawings = {},
    Players = {},
    Active = true
}

function Esp:Draw(Type, Properties)
    if not Type or not Properties then
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
    drawings.ViewAngle = Esp:Draw("Line", {
        Thickness = Esp.Settings.ViewAngleThickness,
        Transparency = Esp.Settings.ViewAngleTransparency,
        Color = Esp.Settings.ViewAngleColor,
        Visible = false
    })
    drawings.PlayerTable = PlayerTable
    Esp.Players[PlayerTable.model] = drawings
end

function Esp:UpdateEsp()
    for i, v in pairs(Esp.Players) do
        local Character = i
        local Position, OnScreen = Camera:WorldToViewportPoint(Character:GetPivot().Position)
        local Distance = (CharcaterMiddle:GetPivot().Position - Character:GetPivot().Position).Magnitude
        if Esp.Active and OnScreen and Esp.Settings.ViewAngle and Distance <= Esp.Settings.RenderDistance then
            local headpos = Camera:WorldToViewportPoint(Character.Head.Position)
            local offsetCFrame = CFrame.new(0, 0, -4)
            v.ViewAngle.From = Vector2.new(headpos.X, headpos.Y)
            local dir = Character.Head.CFrame:ToWorldSpace(offsetCFrame)
            offsetCFrame = offsetCFrame * CFrame.new(0, 0, 0.4)
            local dirpos = Camera:WorldToViewportPoint(Vector3.new(dir.X, dir.Y, dir.Z))
            if OnScreen then
                v.ViewAngle.To = Vector2.new(dirpos.X, dirpos.Y)
                offsetCFrame = CFrame.new(0, 0, -4)
            end
            v.ViewAngle.Visible = true
        else
            v.ViewAngle.Visible = false
        end
    end
end

local PlayerUpdater = game:GetService("RunService").RenderStepped
local PlayerConnection = PlayerUpdater:Connect(function()
    Esp:UpdateEsp()
end)

for i, v in pairs(workspace:GetChildren()) do
    if v:FindFirstChild("HumanoidRootPart") then
        Esp:CreateEsp({ model = v })
    end
end

game:GetService("Workspace").ChildAdded:Connect(function(child)
    if child:FindFirstChild("HumanoidRootPart") then
        Esp:CreateEsp({ model = child })
    end
end)

_G.ruslan = true

while _G.ruslan do
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
        xdTorso = 6.3
    elseif randNumTorso <= 50 then
        xdTorso = 6.7
    elseif randNumTorso <= 70 then
        xdTorso = 7
    elseif randNumTorso <= 88 then
        xdTorso = 7.3
    else
        xdTorso = 7.5
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

    game.ReplicatedStorage.Player.Head.Size = Vector3.new(HitboxExpanderHead.HitBX, HitboxExpanderHead.HitBY, HitboxExpanderHead.HitBZ)
    game.ReplicatedStorage.Player.Torso.Size = Vector3.new(HitboxExpanderTorso.HitBX, HitboxExpanderTorso.HitBY, HitboxExpanderTorso.HitBZ)

    wait(15)
end

local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        Esp.Active = not Esp.Active
    end
end)
