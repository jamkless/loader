getgenv().jamkles = {
    ["StartUP"] = {UnlockFPS = true, Notifications = true},
    ["SilentAim"] = {
        Enabled = true,
        UseKeybind = true,
        Keybind = "T",
        HitPart = "HumanoidRootPart",
        AimMode = "ClosestPoint"
    },
    ["FOV"] = {
        ["SilentAim"] = {
            Visible = true,
            Size = 50,
            Color = Color3.fromRGB(255, 255, 255),
            Filled = true,
            Transparency = 0,
            Position = "Center"
        }
    },
    ["Safety"] = {AntiGroundShots = true, AntiAimViewer = true},
    ["Checks"] = {["SilentAim"] = {WallCheck = true, KnockedCheck = true, AliveCheck = true}},
    ["AutoSettings"] = {LowGFX = false, MuteBoomboxes = false}
}




local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
repeat
    task.wait()
until game:IsLoaded() and (Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait())
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Viewport = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
local SilentTarget = nil
local Connection = {nil, nil}
local AimPoint = nil
local CurrentGame, DHGames, RemoteEvent
local DHGames = {
    [1008451066] = {Name = "Da Hood", MouseArguments = "UpdateMousePosI", Functions = {GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end, CheckKnocked = function(Player)
                if (Player) and Player.Character:FindFirstChild("BodyEffects") then
                    return Player.Character.BodyEffects["K.O"].Value
                end
                return false
            end}},
    [1958807588] = {Name = "Hood Modded", MouseArguments = "MousePos", Functions = {GetRemote = function()
                return game:GetService("ReplicatedStorage").Bullets
            end}},
    [3895585994] = {Name = "Hood Trainer", MouseArguments = "UpdateMousePos", Functions = {GetRemote = function()
                return game:GetService("ReplicatedStorage").MainRemote
            end}},
    ["Universal"] = {Name = "Universal", MouseArguments = "UpdateMousePos", Functions = {GetRemote = function()
                return game:GetService("ReplicatedStorage").MainEvent
            end}}
}
do
    if DHGames[game.GameId] then
        CurrentGame = DHGames[game.GameId]
    else
        CurrentGame = DHGames["Universal"]
    end
    RemoteEvent = CurrentGame.Functions.GetRemote()
    if jamkles.AutoSettings.LowGFX then
        for Index, Value in pairs(workspace:GetDescendants()) do
            if
                Value.ClassName == "Part" or Value.ClassName == "SpawnLocation" or Value.ClassName == "WedgePart" or
                    Value.ClassName == "Terrain" or
                    Value.ClassName == "MeshPart"
             then
                Value.Material = "Plastic"
            end
        end
    end
    if jamkles.AutoSettings.MuteBoomboxes then
        local Sound = {}
        local LoopBreak = {}
        for _, v in pairs(SoundService:GetDescendants()) do
            if v:IsA("Sound") then
                v:Stop()
                v.Playing = false
                v.TimePosition = 0
                v.Volume = 0
                table.insert(Sound, v)
            end
        end
        SoundService.DescendantAdded:Connect(
            function(Sounds)
                if not table.find(Sound, Sounds) and Sounds:IsA("Sound") then
                    Sounds.Playing = false
                    Sounds:Stop()
                    Sounds.TimePosition = 0
                    Sounds.Volume = 0
                end
            end
        )
    end
end
do
    local SilentAimFOVCircle = Drawing.new("Circle")
    SilentAimFOVCircle.Visible = jamkles.FOV.SilentAim.Visible
    SilentAimFOVCircle.Radius = jamkles.FOV.SilentAim.Size
    SilentAimFOVCircle.Color = jamkles.FOV.SilentAim.Color
    SilentAimFOVCircle.Filled = jamkles.FOV.SilentAim.Filled
    SilentAimFOVCircle.Transparency = jamkles.FOV.SilentAim.Transparency
    SilentAimFOVCircle.Position = Viewport
    function UpdateFOV()
        SilentAimFOVCircle.Visible = jamkles.FOV.SilentAim.Visible
        SilentAimFOVCircle.Radius = jamkles.FOV.SilentAim.Size
        SilentAimFOVCircle.Color = jamkles.FOV.SilentAim.Color
        SilentAimFOVCircle.Filled = jamkles.FOV.SilentAim.Filled
        SilentAimFOVCircle.Transparency = jamkles.FOV.SilentAim.Transparency
        if jamkles.FOV.SilentAim.Position == "Center" then
            SilentAimFOVCircle.Position = Viewport
        else
            SilentAimFOVCircle.Position = UserInputService:GetMouseLocation()
        end
    end
    function RayCast(Part, Origin, Ignore, Distance)
        local Ignore = Ignore or {}
        local Distance = Distance or 2000
        local Cast = Ray.new(Origin, (Part.Position - Origin).Unit * Distance)
        local Hit = Workspace:FindPartOnRayWithIgnoreList(Cast, Ignore)
        if Hit and Hit:IsDescendantOf(Part.Parent) then
            return true, Hit
        else
            return false, Hit
        end
        return false, nil
    end
    function GetTarget()
        local Target, Closest = nil, math.huge
        local MousePosition = UserInputService:GetMouseLocation()
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player == LocalPlayer then
            end
            local Character = Player and Player.Character
            local Humanoid = Character and Player.Character:FindFirstChild("Humanoid")
            local RootPart = Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if not (Character and Humanoid and RootPart) then
            end
            if not jamkles.SilentAim.Enabled then
            end
            if
                jamkles.Checks.SilentAim.KnockedCheck and CurrentGame == 1008451066 and
                    Player.Character:FindFirstChild("BodyEffects") and
                    Player.Character.BodyEffects["K.O"].Value or
                    Player.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
             then
            end
            if
                jamkles.Checks.SilentAim.WallCheck and
                    not RayCast(RootPart, Camera.CFrame.Position, {LocalPlayer.Character})
             then
            end
            if jamkles.Checks.SilentAim.AliveCheck and not (Humanoid.Health > 0) then
            end
            local Position, OnScreen = Camera:WorldToScreenPoint(RootPart.Position)
            local Distance
            if jamkles.FOV.SilentAim.Position == "Center" then
                Distance = (Vector2.new(Position.X, Position.Y) - Viewport).Magnitude
            else
                Distance =
                    (Vector2.new(Position.X, Position.Y) - Vector2.new(MousePosition.X, MousePosition.Y)).Magnitude
            end
            if not (Distance <= SilentAimFOVCircle.Radius) then
            end
            if (Distance < Closest) and OnScreen then
                Target = Player
                Closest = Distance
            end
        end
        SilentTarget = Target
    end
    function GetClosestPart(Character)
        local ClosestPart, ClosestDistance = nil, math.huge
        local Parts = Character:GetChildren()
        local MousePosition = UserInputService:GetMouseLocation()
        for _, Part in ipairs(Parts) do
            if Part:IsA("BasePart") then
                local Position, OnScreen = Camera:WorldToScreenPoint(Part.Position)
                local Distance =
                    (Vector2.new(Position.X, Position.Y) - Vector2.new(MousePosition.X, MousePosition.Y)).Magnitude
                if Distance < ClosestDistance then
                    ClosestPart = Part
                    ClosestDistance = Distance
                end
            end
        end
        return ClosestPart
    end
    function CalculateAimPoint()
        if SilentTarget and SilentTarget.Character then
            local HitPart
            if jamkles.SilentAim.AimMode == "ClosestPart" then
                HitPart = GetClosestPart(SilentTarget.Character)
            else
                HitPart = SilentTarget.Character[jamkles.SilentAim.HitPart]
            end
            local function GetPrediction()
                local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
                local split = string.split(pingvalue, "(")
                local ping = tonumber(split[1])
                if ping < 40 then
                    getgenv().Prediction = 0.1256
                elseif ping < 50 then
                    getgenv().Prediction = 0.1225
                elseif ping < 60 then
                    getgenv().Prediction = 0.1229
                elseif ping < 70 then
                    getgenv().Prediction = 0.1230
                elseif ping < 80 then
                    getgenv().Prediction = 0.128
                elseif ping < 90 then
                    getgenv().Prediction = 0.130
                elseif ping < 105 then
                    getgenv().Prediction = 0.133
                elseif ping < 110 then
                    getgenv().Prediction = 0.140
                elseif ping < 125 then
                    getgenv().Prediction = 0.149
                elseif ping < 130 then
                    getgenv().Prediction = 0.151
                end
                return getgenv().Prediction
            end
            local prediction = GetPrediction()
            if jamkles.Safety.AntiGroundShots then
                AimPoint =
                    HitPart.Position +
                    Vector3.new(HitPart.Velocity.X, (HitPart.Velocity.Y * 0.5), HitPart.Velocity.Z) * prediction
            else
                AimPoint = HitPart.Position + HitPart.Velocity * prediction
            end
        end
    end
end
do
    RunService.PreRender:Connect(
        function()
            GetTarget()
            UpdateFOV()
            CalculateAimPoint()
        end
    )
end
do
    UserInputService.InputBegan:Connect(
        function(Input, gpe)
            if gpe then
                return
            end
            if not jamkles.SilentAim.UseKeybind then
                return
            end
            if Input.KeyCode == Enum.KeyCode[jamkles.SilentAim.Keybind:upper()] then
                jamkles.SilentAim.Enabled = not jamkles.SilentAim.Enabled
                if jamkles.StartUP.Notifications then
                    game.StarterGui:SetCore(
                        "SendNotification",
                        {Title = "Silent", Text = tostring(jamkles.SilentAim.Enabled), Duration = 5}
                    )
                end
            end
        end
    )
end
do
    LocalPlayer.CharacterAdded:Connect(
        function(Character)
            Character.ChildAdded:Connect(
                function(child)
                    if child:IsA("Tool") then
                        if Connection[1] == nil then
                            Connection[1] = child
                        end
                        if Connection[1] ~= child and Connection[2] ~= nil then
                            Connection[2]:Disconnect()
                            Connection[1] = child
                        end
                        Connection[2] =
                            child.Activated:Connect(
                            function()
                                if SilentTarget and jamkles.Safety.AntiAimViewer then
                                    RemoteEvent:FireServer(CurrentGame.MouseArguments, AimPoint)
                                end
                            end
                        )
                    end
                end
            )
        end
    )
    LocalPlayer.Character.ChildAdded:Connect(
        function(child)
            if child:IsA("Tool") then
                if Connection[1] == nil then
                    Connection[1] = child
                end
                if Connection[1] ~= child and Connection[2] ~= nil then
                    Connection[2]:Disconnect()
                    Connection[1] = child
                end
                Connection[2] =
                    child.Activated:Connect(
                    function()
                        if SilentTarget and jamkles.Safety.AntiAimViewer then
                            RemoteEvent:FireServer(CurrentGame.MouseArguments, AimPoint)
                        end
                    end
                )
            end
        end
    )
end


