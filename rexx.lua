getgenv().jamkles = {
    ["Enabled"] = true,
    ["AimPart"] = "Head",
    ["Prediction"] = 0.12588,
    ["Smoothness"] = 0.07,
    ["ShakeValue"] = 0,
    ["AutoPred"] = true,
    ["Loaded"] = false,
    ["AutoReload"] = false,
    ["TTKO"] = false,
    ["AntiAimViewer"] = true,
    ["AutoReload"] = true,
    ["cframe"] = {
        ["enabled"] = false,
        ["speed"] = 2
    },
    ["TargetStrafe"] = {
        ["Enabled"] = false,
        ["StrafeSpeed"] = 10,
        ["StrafeRadius"] = 7,
        ["StrafeHeight"] = 3,
        ["RandomizerMode"] = false
    },
    ["targetaim"] = {
        ["Toggled"] = false,
        ["AutoShoot"] = false,
        ["enabled"] = true,
        ["targetPart"] = "UpperTorso",
        ["prediction"] = 0.12588
    },
    ["Triggerbot"] = {
        ["ClosestPart"] = {
            ["HitParts"] = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "RightFoot", "LeftFoot"}
        },
        ["FOV"] = {
            ["Enabled"] = true,
            ["Size"] = 13,
            ["Centered"] = false,
            ["Visible"] = true,
            ["Filled"] = false,
            ["Color"] = Color3.fromRGB(255, 0, 0)
        },
        ["Settings"] = {
            ["Prediction"] = 0.111,
            ["ClickDelay"] = 0.1,
            ["ActivationDelay"] = 2,
            ["IgnoreFriends"] = false,
            ["AutomaticallyFire"] = false
        },
        ["Resolver"] = {
            ["Enabled"] = true,
            ["Method"] = "RecalculateVelocity",
            ["Prediction Settings"] = {
                ["HitPart"] = "Head"
            },
            ["desync"] = {
                ["sky"] = false,
                ["invis"] = true,
                ["jump"] = false,
                ["network"] = false
            },
            ["Misc"] = {
                ["LowGfx"] = false
            },
            ["FPSunlocker"] = {
                ["Enabled"] = true,
                ["FPSCap"] = 999
            }
        }
    }
}

local Notification = Instance.new("ScreenGui")
local Holder = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

Notification.Name = "Notification"
Notification.Parent = game.CoreGui
Notification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Holder.Name = "Holder"
Holder.Parent = Notification
Holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Holder.BackgroundTransparency = 1.000
Holder.Position = UDim2.new(1, -10, 0, 10)  -- Top right corner with slight padding
Holder.AnchorPoint = Vector2.new(1, 0)
Holder.Size = UDim2.new(0, 243, 0, 240)

UIListLayout.Parent = Holder
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

function jam_notify(text, time)
    local Template = Instance.new("Frame")
    local ColorBar = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")

    Template.Name = text
    Template.Parent = Holder
    Template.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Set frame to black
    Template.BorderSizePixel = 0  -- Remove the border
    Template.Size = UDim2.new(1, 0, 0, 22)  -- Fixed size
    Template.Transparency = 1

    ColorBar.Name = "ColorBar"
    ColorBar.Parent = Template
    ColorBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Set color bar to black
    ColorBar.BorderSizePixel = 0
    ColorBar.Size = UDim2.new(0, 2, 0, 22)
    ColorBar.Transparency = 1

    TextLabel.Parent = Template
    TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderSizePixel = 0  -- Remove the border
    TextLabel.Position = UDim2.new(0, 8, 0, 0)
    TextLabel.Size = UDim2.new(1, -10, 0, 22)
    TextLabel.Font = Enum.Font.Code
    TextLabel.Text = text .. " [" .. time .. "s]"  -- Add countdown timer
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Set text to white
    TextLabel.TextSize = 12.000  -- Smaller text size
    TextLabel.TextStrokeTransparency = 0.000
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Transparency = 1

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeInGoal = {Transparency = 0}

    -- Frame starts offscreen and animates from the right
    local sizeTween = TweenService:Create(Template, tweenInfo, fadeInGoal)
    local colorBarTween = TweenService:Create(ColorBar, tweenInfo, fadeInGoal)
    local textTween = TweenService:Create(TextLabel, tweenInfo, fadeInGoal)

    sizeTween:Play()
    colorBarTween:Play()
    textTween:Play()

    local elapsed = 0
    local updateConnection

    updateConnection = RunService.RenderStepped:Connect(function(dt)
        elapsed = elapsed + dt
        local remainingTime = math.max(0, time - elapsed)
        TextLabel.Text = text .. " [" .. string.format("%.1f", remainingTime) .. "s]"
        if remainingTime <= 0 then
            updateConnection:Disconnect()
            local fadeOutGoal = {Transparency = 1}
            TweenService:Create(Template, tweenInfo, fadeOutGoal):Play()
            TweenService:Create(ColorBar, tweenInfo, fadeOutGoal):Play()
            TweenService:Create(TextLabel, tweenInfo, fadeOutGoal):Play()
            delay(0.51, function()
                Template:Destroy()
            end)
        end
    end)
end

local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextButton = Instance.new("TextButton")
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0
    Frame.Position = UDim2.new(1, -120, 0, 0)
    Frame.Size = UDim2.new(0, 100, 0, 50)

    TextButton.Parent = Frame

    TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.BackgroundTransparency = 1.000
    TextButton.Size = UDim2.new(1, 0, 1, 0)
    TextButton.Font = Enum.Font.SourceSans
    TextButton.Text = "rex.lua toggle"
    TextButton.TextColor3 = Color3.fromRGB(71, 153, 173)
    TextButton.TextScaled = true
    TextButton.TextSize = 30
    TextButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.TextStrokeTransparency = 0.000
    TextButton.TextWrapped = true
    TextButton.MouseButton1Down:Connect(
        function()
            Library:Toggle()
        end
    )

    UITextSizeConstraint.Parent = TextButton
    UITextSizeConstraint.MaxTextSize = 30

    local player = game.Players.LocalPlayer

   
    local function onCharacterAdded(character)
        ScreenGui.Parent = player.PlayerGui
    end

    local function connectCharacterAdded()
        player.CharacterAdded:Connect(onCharacterAdded)
    end

   
    connectCharacterAdded()

   
    player.CharacterRemoving:Connect(
        function()
            ScreenGui.Parent = nil
        end
    )


local repo = 'https://raw.githubusercontent.com/LionTheGreatRealFrFr/MobileLinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()




local Window =
        Library:CreateWindow(
        {
            Title = "Rex.cc",
            Center = true,
            AutoShow = true
        }
    )

    local Tabs = {
        Main = Window:AddTab("Legit"),
        Rage = Window:AddTab("HvH"),
        Visuals = Window:AddTab("Visuals"),
        ["UI Settings"] = Window:AddTab("UI Settings")
    }



local Tool = Tabs.Main:AddLeftGroupbox("tool")

local Cam = Tabs.Main:AddLeftGroupbox("Camlock")

local Res = Tabs.Main:AddLeftGroupbox("Resolver")

local Tar = Tabs.Main:AddRightGroupbox("target aim")

local Tri = Tabs.Main:AddRightGroupbox("trigger bot")

local cframe = Tabs.Rage: AddRightGroupbox("Speed")

local TargetStrafe = Tabs.Rage: AddLeftGroupbox("Target strafe")

local Fov = Tabs.Visuals: AddLeftGroupbox("Fov")



Cam:AddToggle(
        "Enable Camlock",
        {
            Text = "Enable camlock",
            Default = true,
            Tooltip = "Enable",
            Callback = function(state)
             jamkles.Enabled = state
            end 
        }
    )

Cam:AddToggle(
        "Enable ttko",
        {
            Text = "Enable ttko",
            Default = false,
            Tooltip = "Enable",
            Callback = function(state)
               jamkles.TTKO = state
            end
        }
    ) 

Cam:AddToggle(
        "Enable autopred",
        {
            Text = "Enable autopred",
            Default = false,
            Tooltip = "Enable",
            Callback = function(state)
               jamkles.AutoPred = state
            end
        }
    ) 



Cam:AddInput(
        "Prediction",
        {
            Default = "Prediction",
            Numeric = false,
            Finished = false,
            Text = "Prediction",
            Tooltip = "Change Prediction For Target",
            Placeholder = "0.1398",
            Callback = function(value)
                jamkles.Prediction = value
            end
        }
    )
    

Cam:AddInput(
        "Smoothness",
        {
            Default = "smoothness",
            Numeric = false,
            Finished = false,
            Text = "smoothness",
            Tooltip = "Change smoothing For Target",
            Placeholder = "0.9",
            Callback = function(value)
                jamkles.Smoothness = value
            end
        }
    )

Cam:AddInput(
        "Shake",
        {
            Default = "Shake",
            Numeric = false,
            Finished = false,
            Text = "shake ",
            Tooltip = "Change shake For Target",
            Placeholder = "0",
            Callback = function(value)
                jamkles.ShakeValue = value
            end
        }
    )

Cam:AddDropdown(
        "Hitpart",
        {
            Values = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg",  "LeftUpperLeg", "RightLowerLeg", "RightFoot",  "RightUpperLeg"},
            Default = 1,
            Multi = false,
            Text = "Hitpart",
            Tooltip = "Choose the hit part",
            Callback = function(value)
                jamkles.AimPart = value
            end
        }
    )

Tar:AddToggle(
        "Enable TargetAim",
        {
            Text = "Enable targetaim",
            Default = true,
            Tooltip = "Enable",
            Callback = function(state)
               targetaim.enabled = state
            end
        }
    )
    
Tar:AddToggle(
        "AutoShoot",
        {
            Text = "AutoShoot",
            Default = false,
            Tooltip = "Enable",
            Callback = function(state)
            targetaim.AutoShoot = state
            end
        }
    )

Tar:AddInput(
        "Prediction",
        {
            Default = "Prediction",
            Numeric = false,
            Finished = false,
            Text = "Prediction",
            Tooltip = "Change Prediction For Target",
            Placeholder = "0.1355",
            Callback = function(value)
                targetaim.prediction = value
            end
        }
    )
    

Tar:AddToggle(
        "Enable autopred",
        {
            Text = "Enable autopred",
            Default = false,
            Tooltip = "Enable",
            Callback = function(state)
               targetaim.AutoPred = state
            end
        }
    ) 

Tar:AddDropdown(
        "Hitpart",
        {
            Values = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg",  "LeftUpperLeg", "RightLowerLeg", "RightFoot",  "RightUpperLeg"},
            Default = 1,
            Multi = false,
            Text = "Hitpart",
            Tooltip = "Choose the hit part",
            Callback = function(value)
                targetaim.targetPart = value
            end
        }
    )
Tar:AddToggle(
        "Enable AutoReload",
        {
            Text = "Enable AutoReload",
            Default = false,
            Tooltip = "Enable",
            Callback = function(state)
               jamkles.AutoReload = state
            end
        }
    ) 


Res:AddToggle(
        "Enable Resolver",
        {
            Text = "Enable resolver",
            Default = true,
            Tooltip = "Enable",
            Callback = function(state)
             jamkles.Resolver.Enabled = state
            end 
        }
    )

Res:AddDropdown(
        "Resolver",
        {
            Values = {"RecalculateVelocity"},
            Default = 1,
            Multi = false,
            Text = "Resolver Mode",
            Tooltip = "Choose the resolving method",
            Callback = function(value)
                jamkles.Resolver.Method = value
            end
        }
    )


Tri:AddToggle(
        "Enable TriggerBot",
        {
            Text = "Enable TriggerBot",
            Default = false,
            Tooltip = "Enable",
            Callback = function(state)
               jamkles.Triggerbot.Settings["Automatically Fire"] = state
            end
        }
    )

Tri:AddInput(
        "Click delay",
        {
            Default = "click delay",
            Numeric = false,
            Finished = false,
            Text = "click delay",
            Tooltip = "Change delay For Clicks",
            Placeholder = "0.1",
            Callback = function(value)
                jamkles.Triggerbot.Settings["Click Delay"] = value
            end
        }
    )

Tri:AddInput(
        "activation delay",
        {
            Default = "activation delay",
            Numeric = false,
            Finished = false,
            Text = "click delay",
            Tooltip = "Change delay For Clicks",
            Placeholder = "3",
            Callback = function(value)
                jamkles.Triggerbot.Settings["Activation Delay"] = value
            end
        }
    )




TargetStrafe:AddToggle(
        "Target Strafe",
        {
            Text = "Target Strafe",
            Default = false,
            Tooltip = "Enable",
            Callback = function(state)
                jamkles.TargetStrafe.Enabled = state
            end
        }
    )

TargetStrafe:AddToggle(
        "Target Strafe randomiser",
        {
            Text = "Target Strafe randomiser",
            Default = false,
            Tooltip = "Enable",
            Callback = function(state)
                jamkles.TargetStrafe.RandomizerMode = state
            end
        }
    )



TargetStrafe:AddSlider(
    "Target speed",
    {
        Text = "How fast you spin around target",
        Default = 0,
        Min = 0,
        Max = 50,
        Rounding = 1,
        Compact = false,
        Callback = function(Value)
            jamkles.TargetStrafe.StrafeSpeed = Value
        end
    }
)

TargetStrafe:AddSlider(
    "Target radius",
    {
        Text = "How far you are around target",
        Default = 0,
        Min = 0,
        Max = 50,
        Rounding = 1,
        Compact = false,
        Callback = function(Value)
            jamkles.TargetStrafe.StrafeRadius = Value
        end
    }
)

TargetStrafe:AddSlider(
    "Target height",
    {
        Text = "How heigh you are from the target",
        Default = 0,
        Min = 0,
        Max = 50,
        Rounding = 1,
        Compact = false,
        Callback = function(Value)
            jamkles.TargetStrafe.StrafeHeight = Value
        end
    }
)




cframe:AddToggle(
        "Enable cframe",
        {
            Text = "Enable cframe",
            Default = false,
            Tooltip = "Enable",
            Callback = function(state)
               jamkles.cframe.enabled = state
            end
        }
    )

cframe:AddSlider(
    "cframe speed",
    {
        Text = "How fast you run around ",
        Default = 0,
        Min = 0,
        Max = 50,
        Rounding = 1,
        Compact = false,
        Callback = function(Value)
            jamkles.cframe.Speed = Value
        end
    }
)



Tool:AddButton(
    "Create tool",
    function()
       spawnTool()
    end
)

Tool:AddButton(
    "Create Button",
    function()
       spawnButton()
    end
)

Tool:AddButton(
    "Controller (dpad up)",
    function()
       setupController()
    end
)



local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('rexlua')
SaveManager:SetFolder('rex/configs')

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()









local player = game.Players.LocalPlayer

local userInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local GS = game:GetService("GuiService")


local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = WS.CurrentCamera
local GetGuiInset = GS.GetGuiInset

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera


getgenv().jamkles = {
    ["Enabled"] = true,
    ["AimPart"] = "Head",
    ["Prediction"] = 0.12588,
    ["Smoothness"] = 1,
    ["ShakeValue"] = 0,
    ["AutoPred"] = true,
    ["Loaded"] = false,
    ["TTKO"] = false,
    ["Mode"] = "Controller",
    ["cframe"] = {
        ["enabled"] = false,
        ["speed"] = 2,
        ["TargetStrafe"] = {
            ["Enabled"] = false,
            ["StrafeSpeed"] = 10,
            ["StrafeRadius"] = 7,
            ["StrafeHeight"] = 3,
            ["RandomizerMode"] = true
        }
    }
}

getgenv().Fov = {
    ["FOVSize"] = 90,
    ["FOVColor"] = Color3.fromRGB(255, 0, 0),
    ["FOVVisible"] = true,
    ["FOVShape"] = "Circle"
}

getgenv().targetaim= {
    ["enabled"] = true,
    ["targetPart"] = "UpperTorso",
    ["prediction"] = 0.12588
}

getgenv().desync = {
    ["sky"] = false,
    ["invis"] = true,
    ["jump"] = false,
    ["network"] = false
}

getgenv().Misc = {
    ["LowGfx"] = false,
}

getgenv().FPSunlocker = {
    ["Enabled"] = true,
    ["FPSCap"] = 999
}

getgenv().Triggerbot = {
    ["ClosestPart"] = {
        ["HitParts"] = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "RightFoot", "LeftFoot"}
    },
    ["FOV"] = {
        ["Enabled"] = true,
        ["Size"] = 13,
        ["Centered FOV"] = true,
        ["Visible"] = false,
        ["Filled"] = false,
        ["Color"] = Color3.fromRGB(255, 0, 0)
    },
    ["Settings"] = {
        ["Prediction"] = 0.111,
        ["Click Delay"] = 0.1,
        ["Activation Delay"] = 2,
        ["IgnoreFriends"] = false,
        ["Automatically Fire"] = false,
    }
}

local function createFOVCircle()
    local circle = Drawing.new("Circle")
    circle.Radius = Triggerbot.FOV.Size
    circle.Thickness = 1
    circle.Filled = Triggerbot.FOV.Filled
    circle.Color = Triggerbot.FOV.Color
    circle.Visible = Triggerbot.FOV.Visible
    return circle
end

local FOVCircle = createFOVCircle()

local function updateFOVCircle()
    if Triggerbot.FOV.Enabled and FOVCircle then
        if Triggerbot.FOV["Centered FOV"] then
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        else
            local mousePos = UserInputService:GetMouseLocation()
            FOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
        end
    end
end

local function isTargetValid(player)
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        if humanoid.Health > 0 then
            return true
        end
    end
    return false
end

local function getMouseTarget()
    local mousePos =
        Triggerbot.FOV["Centered FOV"] and Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or
        UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local closestDistance = Triggerbot.FOV.Size

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isTargetValid(player) then
            for _, hitPartName in ipairs(Triggerbot.ClosestPart.HitParts) do
                local hitPart = player.Character and player.Character:FindFirstChild(hitPartName)
                if hitPart then
                    local partPos = Camera:WorldToViewportPoint(hitPart.Position)
                    local distance = (Vector2.new(partPos.X, partPos.Y) - mousePos).Magnitude

                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function fireAtTarget(target)
    if target and Triggerbot.Settings["Automatically Fire"] then
        for _, hitPartName in ipairs(Triggerbot.ClosestPart.HitParts) do
            local hitPart = target.Character and target.Character:FindFirstChild(hitPartName)
            if hitPart then
                local Tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if Tool and Tool:FindFirstChild("Handle") then
                    Tool:Activate()
                    wait(Triggerbot.Settings["Click Delay"])
                    Tool:Deactivate()
                end
            end
        end
    end
end

local activationDelay = Triggerbot.Settings["Activation Delay"]

RunService.RenderStepped:Connect(
    function()
        updateFOVCircle()

        if activationDelay > 0 then
            activationDelay = activationDelay - RunService.RenderStepped:Wait()
            return
        end

        if Triggerbot.FOV["Centered FOV"] then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end

        local target = getMouseTarget()
        if target then
            fireAtTarget(target)
        end
    end
)



local userInputService = game:GetService("UserInputService")

local AimlockState = true
local Locked = false
local Victim
local target

if jamkles.Loaded then
    notify("Already Loaded")
    return
end

jamkles.Loaded = true

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestScore = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild(jamkles.AimPart) and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local part = plr.Character[jamkles.AimPart]
            local relativePos = part.Position - Camera.CFrame.Position
            local playerDistance = relativePos.Magnitude
            local screenPosition, onScreen = Camera:WorldToViewportPoint(part.Position)

            if onScreen then
                local angle = math.deg(math.acos(Camera.CFrame.LookVector:Dot(relativePos.Unit)))
                local mouseDistance = (Vector2.new(screenPosition.X, screenPosition.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                local angleFactor = angle / 90
                local distanceFactor = playerDistance / 1000 

                local score = mouseDistance * 0.3 + angleFactor * 0.5 + distanceFactor * 0.2

                local ray = Ray.new(Camera.CFrame.Position, relativePos.Unit * playerDistance)
                local hitPart = WS:FindPartOnRayWithIgnoreList(ray, {player.Character})

                if (not hitPart or hitPart:IsDescendantOf(plr.Character)) and score < shortestScore then
                    closestPlayer = plr
                    shortestScore = score
                end
            end
        end
    end

    return closestPlayer
end



local function ToggleLock()
    if AimlockState then
        Locked = not Locked
        if Locked then
            Victim = GetClosestPlayer()
            target = Victim
            if Victim then
                if jamkles.Enabled then
                    jam_notify("Camlock: Locked onto " .. tostring(Victim.Name), 5)
                end
                if targetaim.enabled then
                    jam_notify("Target Lock: Locked onto " .. tostring(target.Name), 5)
                end
            else
                if jamkles.Enabled then
                    jam_notify("Camlock: No target found", 5)
                end
                if targetaim.enabled then
                    jam_notify("Target Lock: No target found", 5)
                end
            end
        else
            Victim = nil
            target = nil
            if jamkles.Enabled then
                jam_notify("Camlock: Unlocked!", 5)
            end
            if targetaim.enabled then
                jam_notify("Target Lock: Unlocked!", 5)
            end
        end
    else
        if not jamkles.Enabled then
            jam_notify("Camlock not enabled", 5)
        end
    end
end

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local userInputService = game:GetService("UserInputService")

-- Function for the "Tool" mode
function spawnTool()
    local Tool = Instance.new("Tool")
    Tool.RequiresHandle = false
    Tool.Name = "Lock Tool"
    Tool.Parent = player.Backpack

    local function onCharacterAdded()
        Tool.Parent = player.Backpack
    end

    player.CharacterAdded:Connect(onCharacterAdded)

    player.CharacterRemoving:Connect(function()
        Tool.Parent = player.Backpack
    end)

    Tool.Activated:Connect(function()
        ToggleLock()
    end)
end

-- Function for the "Button" mode
function spawnButton()
    local function setupGui()
        local screenGui = playerGui:FindFirstChild("LockScreenGui")

        if not screenGui then
            screenGui = Instance.new("ScreenGui")
            screenGui.Name = "LockScreenGui"
            screenGui.Parent = playerGui
        end

        local button = screenGui:FindFirstChild("LockButton")

        if not button then
            button = Instance.new("TextButton")
            button.Name = "LockButton"
            button.Size = UDim2.new(0, 100, 0, 50)
            button.Position = UDim2.new(0.5, -100, 0.8, -25)
            button.Text = "aimlock"
            button.TextSize = 30
            button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Parent = screenGui
            button.Active = true
            button.Draggable = true

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 25)
            UICorner.Parent = button

            button.MouseButton1Click:Connect(function()
                ToggleLock()
            end)
        end
    end

    setupGui()

    player.CharacterAdded:Connect(function()
        setupGui()
    end)
end

-- Function for the "Controller" mode
function setupController()
    userInputService.InputBegan:Connect(function(input, processed)
        if not processed then
            if input.KeyCode == Enum.KeyCode.DPadUp then
                ToggleLock()
            end
        end
    end)
end


RS.RenderStepped:Connect(function()
    if AimlockState and Victim and Victim.Character and Victim.Character:FindFirstChild(jamkles.AimPart) then
        local aimPart = Victim.Character[jamkles.AimPart]
        local targetPosition = aimPart.Position + aimPart.Velocity * jamkles.Prediction
        local lookPosition = CFrame.new(Camera.CFrame.p, targetPosition)
        Camera.CFrame = Camera.CFrame:Lerp(lookPosition, jamkles.Smoothness)

        if jamkles.cframe.TargetStrafe.Enabled then
            local lp = player.Character
            local targpos = Victim.Character.HumanoidRootPart.Position
            local strafeOffset
            
            if jamkles.cframe.TargetStrafe.RandomizerMode then
               
                strafeOffset = Vector3.new(
                    math.random(-jamkles.cframe.TargetStrafe.StrafeRadius, jamkles.cframe.TargetStrafe.StrafeRadius),
                    math.random(0, jamkles.cframe.TargetStrafe.StrafeHeight),
                    math.random(-jamkles.cframe.TargetStrafe.StrafeRadius, jamkles.cframe.TargetStrafe.StrafeRadius)
                )
            else
               
                strafeOffset = Vector3.new(
                    math.cos(tick() * jamkles.cframe.TargetStrafe.StrafeSpeed) * jamkles.cframe.TargetStrafe.StrafeRadius,
                    jamkles.cframe.TargetStrafe.StrafeHeight,
                    math.sin(tick() * jamkles.cframe.TargetStrafe.StrafeSpeed) * jamkles.cframe.TargetStrafe.StrafeRadius
                )
            end

           
            local strafePosition = targpos + strafeOffset
            strafePosition = Vector3.new(strafePosition.X, math.max(strafePosition.Y, targpos.Y), strafePosition.Z)
            
            lp:SetPrimaryPartCFrame(CFrame.new(strafePosition))
            player.Character.HumanoidRootPart.CFrame = CFrame.new(
                player.Character.HumanoidRootPart.CFrame.Position,
                Vector3.new(targpos.X, player.Character.HumanoidRootPart.CFrame.Position.Y, targpos.Z)
            )
        end
    end
end)

spawn(function()
    RS.Heartbeat:Connect(function()
        if jamkles.Enabled and jamkles.cframe.enabled then
            player.Character.HumanoidRootPart.CFrame =
                player.Character.HumanoidRootPart.CFrame + player.Character.Humanoid.MoveDirection * jamkles.cframe.speed
        end
    end)
end)

for _, con in pairs(getconnections(Camera.Changed)) do
    con:Disable()
end
for _, con in pairs(getconnections(Camera:GetPropertyChangedSignal("CFrame"))) do
    con:Disable()
end

local mt = getrawmetatable(game)
local oldNameCall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(Self, ...)
    local args = {...}
    local methodName = getnamecallmethod()
    if not checkcaller() and methodName == "FireServer" and targetaim.enabled then
        for i, Argument in ipairs(args) do
            if typeof(Argument) == "Vector3" and target and target.Character then
                args[i] = target.Character[targetaim.targetPart].Position + (target.Character[targetaim.targetPart].Velocity * targetaim.prediction)
                return oldNameCall(Self, unpack(args))
            end
        end
    end
    return oldNameCall(Self, ...)
end)

setreadonly(mt, true)

while task.wait() do
    if jamkles.TTKO and Victim and Victim.Character and Victim.Character:FindFirstChild("Humanoid") then
        if Victim.Character.Humanoid.Health <= 2 then
            local chatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if chatEvents and chatEvents:FindFirstChild("SayMessageRequest") then
                local sayMessageRequest = chatEvents.SayMessageRequest
                if sayMessageRequest and sayMessageRequest:IsA("RemoteEvent") then
                    sayMessageRequest:FireServer("get tapped by rexlua😂", "All")
                    wait(0.6)
                    sayMessageRequest:FireServer("ur a trash and a larp", "All")
                elseif sayMessageRequest and sayMessageRequest:IsA("RemoteFunction") then
                    sayMessageRequest:InvokeServer("get tapped by rexlua😂", "All")
                    wait(0.6)
                    sayMessageRequest:InvokeServer("ur a trash and a larp", "All")
                end
            end
        end
    end
end

while task.wait() do
    if jamkles.Enabled and jamkles.AutoPred then
        local pingValue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local ping = tonumber((pingValue:match("%d+")))
        if ping then
            if ping > 225 then
                jamkles.Prediction = 0.166547
            elseif ping > 215 then
                jamkles.Prediction = 0.15692
            elseif ping > 205 then
                jamkles.Prediction = 0.165732
            elseif ping > 190 then
                jamkles.Prediction = 0.1690
            elseif ping > 185 then
                jamkles.Prediction = 0.1235666
            elseif ping > 180 then
                jamkles.Prediction = 0.16779123
            elseif ping > 175 then
                jamkles.Prediction = 0.165455312399999
            elseif ping > 170 then
                jamkles.Prediction = 0.16
            elseif ping > 165 then
                jamkles.Prediction = 0.15
            elseif ping > 160 then
                jamkles.Prediction = 0.1223333
            elseif ping > 155 then
                jamkles.Prediction = 0.125333
            elseif ping > 150 then
                jamkles.Prediction = 0.1652131
            elseif ping > 145 then
                jamkles.Prediction = 0.129934
            elseif ping > 140 then
                jamkles.Prediction = 0.1659921
            elseif ping > 135 then
                jamkles.Prediction = 0.1659921
            elseif ping > 130 then
                jamkles.Prediction = 0.12399
            elseif ping > 125 then
                jamkles.Prediction = 0.15465
            elseif ping > 110 then
                jamkles.Prediction = 0.142199
            elseif ping > 105 then
                jamkles.Prediction = 0.141199
            elseif ping > 100 then
                jamkles.Prediction = 0.134143
            elseif ping > 90 then
                jamkles.Prediction = 0.1433333333392
            elseif ping > 80 then
                jamkles.Prediction = 0.143214443
            elseif ping > 70 then
                jamkles.Prediction = 0.14899911
            elseif ping > 60 then
                jamkles.Prediction = 0.148325
            elseif ping > 50 then
                jamkles.Prediction = 0.128643
            elseif ping > 40 then
                jamkles.Prediction = 0.12766
            elseif ping > 30 then
                jamkles.Prediction = 0.124123
            elseif ping > 20 then
                jamkles.Prediction = 0.12435
            elseif ping > 10 then
                jamkles.Prediction = 0.1234555
            elseif ping < 10 then
                jamkles.Prediction = 0.1332
            else
                jamkles.Prediction = 0.1342
            end
        end
      end
    end
  
        



if desync.sky == true then
    getgenv().JamklesSky = true 
    getgenv().SkyAmount = 90

    game:GetService("RunService").Heartbeat:Connect(function()
        if getgenv().JamklesSky then 
            local vel = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, getgenv().SkyAmount, 0) 
            game:GetService("RunService").RenderStepped:Wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = vel
        end
    end)
end

if desync.jump == true then
    getgenv().jumpanti = true
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if getgenv().jumpanti then    
            local CurrentVelocity = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(1000, 1000, 1000)
            game:GetService("RunService").RenderStepped:Wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = CurrentVelocity
        end
    end)
end

if desync.jump == true then

-- Maximum Roblox velocity (128^2 or 16384)
local velMax = (128 ^ 2)

local timeRelease, timeChoke = 0.015, 0.105

local Property, Wait = sethiddenproperty, task.wait
local Radian, Random, Ceil = math.rad, math.random, math.ceil
local Angle = CFrame.Angles
local Vector = Vector3.new
local Service = game.GetService

local Run = Service(game, 'RunService')
local Stats = Service(game, 'Stats')
local Players = Service(game, 'Players')
local LocalPlayer = Players.LocalPlayer
local statPing = Stats.PerformanceStats.Ping
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")
local Mouse = LocalPlayer:GetMouse()

local runRen, runBeat = Run.RenderStepped, Run.Heartbeat
local runRenWait, runRenCon = runRen.Wait, runRen.Connect
local runBeatCon = runBeat.Connect

local function Ping()
    return statPing:GetValue()
end

local function Sleep()
    Property(Root, 'NetworkIsSleeping', true)
end

local function FireGun()
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Shoot") then
        local ShootEvent = tool.Shoot
        ShootEvent:FireServer(Mouse.Hit.Position)
    end
end

local function Init()
    if not Root then return end

    local rootVel = Root.Velocity
    local rootCFrame = Root.CFrame

   
    local rootAng = Random(-180, 180)
    local rootOffset do
        local X = Random(-velMax, velMax)
        local Y = Random(0, velMax)
        local Z = Random(-velMax, velMax)
        rootOffset = Vector(X, -Y, Z)
    end

    Root.CFrame = Angle(0, Radian(rootAng), 0)
    Root.Velocity = rootOffset

   
    FireGun()


    runRenWait(runRen)
    Root.CFrame = rootCFrame
    Root.Velocity = rootVel
end

runBeatCon(runBeat, Init)

-- Main loop for choking replication
while Wait(timeRelease) do
    -- Stable replication packets
    local chokeClient, chokeServer = runBeatCon(runBeat, Sleep), runRenCon(runRen, Sleep)

    Wait(Ceil(Ping()) / 1000)

    chokeClient:Disconnect()
    chokeServer:Disconnect()

end
end

if desync.network == true then
local RunService = game:GetService("RunService")

local function onHeartbeat()
    setfflag("S2PhysicsSenderRate", 1)
end

RunService.Heartbeat:Connect(onHeartbeat)
end

if Misc.LowGfx == true then
game:GetService("CorePackages").Packages:Destroy()
end

if FPSunlocker.Enabled then
    setfpscap(FPSunlocker.FPSCap)
end



