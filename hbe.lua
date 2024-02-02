wait(1)
local Camera = game:GetService("Workspace").CurrentCamera
local CharcaterMiddle = game:GetService("Workspace").Ignore.LocalCharacter.Middle



--// Tables
local Functions = {}
local Esp = {Settings={
    Boxes=false,BoxesColor=Color3.fromRGB(144, 66, 245),
    Sleeping=false,SleepingColor=Color3.fromRGB(255,255,255),
    Distances=false,DistanceColor=Color3.fromRGB(255,255,255),
    Armour=false,ArmourColor=Color3.fromRGB(255,255,255),
    Tool=false,ToolColor=Color3.fromRGB(255,255,255),
    ViewAngle=true,ViewAngleColor=Color3.fromRGB(144, 66, 245),ViewAngleThickness=1,ViewAngleTransparrency=1,
    TextFont=2,TextOutline=true,TextSize=13,RenderDistance=1000,TeamCheck=false,TargetSleepers=true,MinTextSize=11
},Drawings={},Connections={},Players={}}
local Fonts = {["UI"]=0,["System"]=1,["Plex"]=2,["Monospace"]=3}
local cache = {}

--// Functions
function Functions:IsSleeping(Model)
    if Model and Model:FindFirstChild("AnimationController") and Model.AnimationController:FindFirstChild("Animator") then
		for i,v in pairs(Model.AnimationController.Animator:GetPlayingAnimationTracks()) do
            if v.Animation.AnimationId == "rbxassetid://13280887764" then return true
            else return false
            end
        end
    end
end
function Functions:Draw(Type,Propities)
    if not Type and not Propities then return end
    local drawing = Drawing.new(Type)
    for i,v in pairs(Propities) do drawing[i] = v end
    table.insert(Esp.Drawings,drawing)
    return drawing
end
function Esp:CreateEsp(PlayerTable)
    if not PlayerTable then return end
    local drawings = {}
    drawings.Box = Functions:Draw("Square",{Transparency=0.35,Color=Esp.Settings.BoxesColor,Visible=false,Visible=false});
    drawings.Sleeping = Functions:Draw("Text",{Text = "Nil",Font=Esp.Settings.TextFont,Size=Esp.Settings.TextSize,Center=true,Outline=Esp.Settings.TextOutline,Color = Esp.Settings.SleepingColor,ZIndex = 2,Visible=false})
    drawings.Distance = Functions:Draw("Text",{Text = "Nil",Font=Esp.Settings.TextFont,Size=Esp.Settings.TextSize,Center=true,Outline=Esp.Settings.TextOutline,Color = Esp.Settings.SleepingColor,ZIndex = 2,Visible=false})
    drawings.Armour = Functions:Draw("Text",{Text = "None",Font=Esp.Settings.TextFont,Size=Esp.Settings.TextSize,Center=false,Outline=Esp.Settings.TextOutline,Color = Esp.Settings.ArmourColor,ZIndex = 2,Visible=false})
    drawings.ViewAngle = Functions:Draw("Line",{Thickness=Esp.Settings.ViewAngleThickness,Transparency=Esp.Settings.ViewAngleTransparrency,Color=Esp.Settings.ViewAngleColor,ZIndex=2,Visible=false})
    drawings.PlayerTable = PlayerTable
    Esp.Players[PlayerTable.model] = drawings
end
function Esp:RemoveEsp(PlayerTable)
    if not PlayerTable and PlayerTable.model ~= nil then return end
    esp = Esp.Players[PlayerTable.model];
    if not esp then return end
    for i, v in pairs(esp) do
        if not type(v) == "table" then v:Remove(); end
    end
    Esp.Players[PlayerTable.model] = nil;
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
                v.Box.Position = Vector2.new(BoxPosX,BoxPosY);v.Box.Size = Vector2.new(w,h)
                v.Box.Color = Esp.Settings.BoxesColor
            else
                v.Box.Visible = false
            end
            if OnScreen == true and Esp.Settings.ViewAngle == true and Distance <= Esp.Settings.RenderDistance then
                if Esp.Settings.TeamCheck == true and TeamTag == false then v.ViewAngle.Visible = true elseif Esp.Settings.TeamCheck == true and TeamTag == true then v.ViewAngle.Visible = false else v.ViewAngle.Visible = true end
                if Esp.Settings.TargetSleepers == true and sleeping == true then v.ViewAngle.Visible = false end
                v.ViewAngle.Color = Esp.Settings.ViewAngleColor;v.ViewAngle.Thickness=Esp.Settings.ViewAngleThickness;v.Transparency=Esp.Settings.ViewAngleTransparrency;
                local headpos = Camera:WorldToViewportPoint(Character.Head.Position)
                local offsetCFrame = CFrame.new(0, 0, -4)
                v.ViewAngle.From = Vector2.new(headpos.X, headpos.Y)
                local value = math.clamp(1/Distance*100, 0.1, 1)
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
            v.Box.Visible=false;v.Armour.Visible=false;v.Distance.Visible=false;v.ViewAngle.Visible=false;v.Sleeping.Visible=false;
        end
    end
end
local PlayerUpdater = game:GetService("RunService").RenderStepped
local PlayerConnection = PlayerUpdater:Connect(function()
    Esp:UpdateEsp()
end)
for i,v in pairs(workspace:GetChildren()) do
	if v:FindFirstChild("HumanoidRootPart") then
        table.insert(cache,v)
        Esp:CreateEsp({model=v})
	end
end
game:GetService("Workspace").ChildAdded:Connect(function(child)
    if child:FindFirstChild("HumanoidRootPart") and not table.find(cache,child) then
        table.insert(cache,child)
        Esp:CreateEsp({model=child})
    end
end)

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
        if i:IsA("Model") and i:FindFirstChild("HumanoidRootPart") and not Functions:IsSleeping(i) then
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
        if i:IsA("Model") and i:FindFirstChild("HumanoidRootPart") and not Functions:IsSleeping(i) then
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
