local UserInputService = game:GetService("UserInputService")

local function ExpandHitbox()
    local HitboxExpanderHead = { HitBX = 6.4, HitBY = 6.4, HitBZ = 6.4 }
    local HitboxExpanderTorso = { HitBX = 7, HitBY = 7, HitBZ = 7 }

    for _, i in ipairs(workspace:GetChildren()) do
        if i:FindFirstChild("HumanoidRootPart") and not Functions:IsSleeping(i) then
            local head = i:FindFirstChild("Head")
            local torso = i:FindFirstChild("Torso")

            if head then
                head.Size = Vector3.new(HitboxExpanderHead.HitBX, HitboxExpanderHead.HitBY, HitboxExpanderHead.HitBZ)
                head.CanCollide = false
                head.Color = Color3.fromRGB(144, 66, 245)
                head.Material = "ForceField"
                head.Transparency = 0.88
            end

            if torso then
                torso.Size = Vector3.new(HitboxExpanderTorso.HitBX, HitboxExpanderTorso.HitBY, HitboxExpanderTorso.HitBZ)
                torso.CanCollide = false
                torso.Color = Color3.fromRGB(66, 144, 245)
                torso.Material = "ForceField"
                torso.Transparency = 0.66
            end
        end
    end
end

local function OnInputBegan(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.P then
        ExpandHitbox() -- Llamar a la función para expandir el hitbox
        Notification:Notify(
        {Title = "Hitbox Extended [✅]", Description = "x1 🔥"},
        {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = "default"}
       )
    end
end

UserInputService.InputBegan:Connect(OnInputBegan)
