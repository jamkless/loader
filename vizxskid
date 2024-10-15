--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--// Variables
getgenv().Settings = {
    prediction = 0.1567, -- customize it nigger
    PredictionHorizontal = 0.15867, -- customize
    PredictionVertical = 0.15867, -- customize
    CamlockEnabled = false -- don't touch or else😡
}

local LocalPlayer = Players.LocalPlayer
local enemy = nil

--// UI Elements
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 180, 0, 50)
ToggleButton.Text = "Vix off❌"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleButton.BorderSizePixel = 0
ToggleButton.Font = Enum.Font.FredokaOne
ToggleButton.TextSize = 24
ToggleButton.Position = UDim2.new(0, 10, 0, 10) -- Positioned in the top left corner
ToggleButton.Parent = ScreenGui

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 15)
ButtonCorner.Parent = ToggleButton

local function DisplayNotification(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "🎃 Vix 🎃",
        Text = text,
        Duration = 5,
        Icon = "rbxassetid://2541869220"
    })
end

local function FindNearestEnemy()
    local ClosestDistance, ClosestPlayer = math.huge, nil
    local Camera = workspace.CurrentCamera

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character:FindFirstChild("HumanoidRootPart") and Character.Humanoid.Health > 0 then
                local Position, IsVisibleOnViewport = Camera:WorldToViewportPoint(Character.HumanoidRootPart.Position)
                if IsVisibleOnViewport then
                    local Distance = (Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Character.HumanoidRootPart
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end

    return ClosestPlayer
end

local function ToggleCamlock()
    getgenv().Settings.CamlockEnabled = not getgenv().Settings.CamlockEnabled
    local displayName = "No Target"

    if getgenv().Settings.CamlockEnabled then
        enemy = FindNearestEnemy()
        if enemy then
            local targetPlayer = Players:GetPlayerFromCharacter(enemy.Parent)
            if targetPlayer then
                displayName = targetPlayer.DisplayName
                DisplayNotification("Camlock Enabled: " .. displayName)
            end
        else
            DisplayNotification("Camlock Enabled: No Target")
        end
    else
        enemy = nil
        DisplayNotification("Camlock Disabled")
    end

    ToggleButton.Text = getgenv().Settings.CamlockEnabled and "Nightmare.Ez on🔥" or "Nightmare.Ez off❌"
end

ToggleButton.MouseButton1Click:Connect(function()
    ToggleCamlock()
    TweenService:Create(
        ToggleButton,
        TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        {Size = UDim2.new(0, 185, 0, 55)}
    ):Play()

    wait(0.1)
    TweenService:Create(
        ToggleButton,
        TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        {Size = UDim2.new(0, 180, 0, 50)}
    ):Play()
end)

local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

RunService.Heartbeat:Connect(function()
    if getgenv().Settings.CamlockEnabled and enemy then
        local camera = workspace.CurrentCamera
        camera.CFrame = CFrame.new(camera.CFrame.p, enemy.Position + Vector3.new(getgenv().Settings.PredictionHorizontal, getgenv().Settings.PredictionVertical, 0))
    end
end)

-- made by V4mp -- this is the script maker 
-- the chill owner:3 -- vix🔥 

-- pls don't skid pls bro
