getgenv().Extort = {
    ['Target Part'] = "HumanoidRootPart",
    ['Prediction'] = {
        ['Amount'] = 0.148672,
    },
    ['Offset'] = {
        ['Jump'] = -1.5
    },
    ['Auto Prediction'] = false,
    ['Features'] = {
        ['Look At'] = true,
        ['Auto Air'] = true
    },
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local NotificationHolder = loadstring(game:HttpGet("https://rentry.co/senopos/raw", true))()
local Notification = loadstring(game:HttpGet("https://rentry.co/senopos2/raw", true))()

local ExtortGUI = Instance.new("ScreenGui")
local LockButton = Instance.new("ImageButton")
local ButtonCorner = Instance.new("UICorner")
local Target = nil
local Locking = false
local PlayerData = {}

ExtortGUI.Name = "ExtortGUI"
ExtortGUI.Parent = game.CoreGui
ExtortGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ExtortGUI.ResetOnSpawn = false

LockButton.Name = "LockButton"
LockButton.Parent = ExtortGUI
LockButton.Active = true
LockButton.Draggable = true
LockButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LockButton.BackgroundTransparency = 0.350
LockButton.Size = UDim2.new(0, 90, 0, 90)
LockButton.Image = "rbxassetid://134820707156642"
LockButton.Position = UDim2.new(0.5, -25, 0.5, -25)

ButtonCorner.CornerRadius = UDim.new(0.2, 0)
ButtonCorner.Parent = LockButton

Script = {}

local Arguments = loadstring(game:HttpGet("https://raw.githubusercontent.com/xaxaxaxaxaxaxaxaxaxaxaxax/Primordial/refs/heads/main/Arguments.lua"))()

Script.GetEvent = function()
    local RemoteNames = {"MainEvent", "Bullets", "Remote", "MAINEVENT"}
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if table.find(RemoteNames, remote.Name) and remote:IsA("RemoteEvent") then
            return remote
        end
    end
    return nil
end

Script.GetArguments = function()
    return Arguments[game.PlaceId] or "UpdateMousePos"
end

local Remote = Script.GetEvent()
local Argument = Script.GetArguments()

Script.FindClosestPlayer = function()
    local ClosestPlayer
    local ShortestDistance = math.huge
    local ScreenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health ~= 0 and Player.Character:FindFirstChild("HumanoidRootPart") then
            local Position = Camera:WorldToViewportPoint(Player.Character.PrimaryPart.Position)
            local Distance = (Vector2.new(Position.X, Position.Y) - ScreenCenter).magnitude
            if Distance < ShortestDistance then
                ClosestPlayer = Player
                ShortestDistance = Distance
            end
        end
    end
    return ClosestPlayer
end

Script.CalculateVelocity = function(player)
    if not player or not player.Character then return Vector3.new(0, 0, 0) end
    local primary_part = player.Character:FindFirstChild("HumanoidRootPart")
    if not primary_part then return Vector3.new(0, 0, 0) end
    
    if not PlayerData[player] then
        PlayerData[player] = {
            PreviousPosition = primary_part.Position,
            Velocity = Vector3.new(0, 0, 0)
        }
    end
    
    local current_position = primary_part.Position
    local previous_position = PlayerData[player].PreviousPosition
    local displacement = current_position - previous_position
    local delta_time = RunService.Heartbeat:Wait()
    local velocity = displacement / delta_time
    
    PlayerData[player].Velocity = velocity
    PlayerData[player].PreviousPosition = current_position
    
    return velocity
end

Script.LookAt = function(Target)
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if RootPart and getgenv().Extort['Features']['Look At'] then
        if Target and Target.Character and Target.Character:FindFirstChild(getgenv().Extort['Target Part']) then
            local TargetPart = Target.Character[getgenv().Extort['Target Part']]
            local TargetPos = TargetPart.Position
            local TargetVel = Script.CalculateVelocity(Target)
            local PredictedPos = TargetPos
            
            if getgenv().Extort['Auto Prediction'] then
                local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                getgenv().Extort['Prediction']['Amount'] = 0.1 + (ping / 2500) * 0.88
            end
            
            PredictedPos = TargetPos + (TargetVel * getgenv().Extort['Prediction']['Amount'])
            
            if TargetVel.Y > 15 then
                PredictedPos = PredictedPos + Vector3.new(0, getgenv().Extort['Offset']['Jump'], 0)
            end
            
            local LocalPos = RootPart.Position
            local AimDirection = (PredictedPos - LocalPos).Unit
            AimDirection = Vector3.new(AimDirection.X, 0, AimDirection.Z).Unit
            RootPart.CFrame = CFrame.new(LocalPos, LocalPos + AimDirection)
        end
    end
end

Script.AutoAir = function(Target)
    if getgenv().Extort['Features']['Auto Air'] and Target and Target.Character then
        local TargetRootPart = Target.Character:FindFirstChild("HumanoidRootPart")
        if TargetRootPart then
            local TargetVel = Script.CalculateVelocity(Target)
            if TargetVel.Y > 15 then
                local Character = LocalPlayer.Character
                if Character then
                    local Tool = Character:FindFirstChildOfClass("Tool")
                    if Tool then
                        Tool:Activate()
                    end
                end
            end
        end
    end
end

Script.GetGun = function(player)
    if not player.Character then return end
    local tool = player.Character:FindFirstChildOfClass("Tool")
    if not tool then return end
    local info = {}
    for _, obj in pairs(tool:GetDescendants()) do
        if obj.Name:lower():find("ammo") and not obj.Name:lower():find("max") and (obj:IsA("IntValue") or obj:IsA("NumberValue")) then
            info.ammo = obj
            info.tool = tool
            return info
        end
    end
end

Script.OnToolActivated = function()
    if Locking and Target and Target.Character then
        local part = Target.Character:FindFirstChild(getgenv().Extort['Target Part'])
        if part then
            local position = part.Position + (PlayerData[Target].Velocity * getgenv().Extort['Prediction']['Amount'])
            Remote:FireServer(Argument, position)
        end
    end
end

Script.SetupConnections = function()
    LocalPlayer.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            child.Activated:Connect(Script.OnToolActivated)
        end
    end)
end

Script.SetupConnections()
LocalPlayer.CharacterAdded:Connect(Script.SetupConnections)

RunService.Heartbeat:Connect(function()
    if Locking and Target then
        Script.LookAt(Target)
        Script.AutoAir(Target)
    end
end)

LockButton.MouseButton1Click:Connect(function()
    if Locking then
        LockButton.Image = "rbxassetid://134820707156642"
        Locking = false
        Target = nil
        Notification:Notify(
            {Title = "Extort.lua", Description = "Extort.lua Lock Disabled"},
            {OutlineColor = Color3.fromRGB(0, 255, 0), Time = 2, Type = "default"}
        )
    else
        Target = Script.FindClosestPlayer()
        if Target then
            Locking = true
            LockButton.Image = "rbxassetid://78342062013795"
            Notification:Notify(
                {
                    Title = "Extort.lua",
                    Description = "Extort.lua Target Locked: " .. tostring(Target.Character.Humanoid.DisplayName)
                },
                {
                    OutlineColor = Color3.fromRGB(0, 255, 0),
                    Time = 2,
                    Type = "default"
                }
            )
        end
    end
end)
