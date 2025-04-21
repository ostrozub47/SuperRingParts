local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- Sound Effects
local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- Play initial sound
playSound("2865227271")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperRingPartsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 550) -- Увеличил высоту для новой кнопки и поля
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -275)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Тёмный фон
MainFrame.Parent = ScreenGui

-- Make the GUI round
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "Super Ring Parts V6 by lukas"
Title.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый текст для читаемости
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Тёмно-серый фон
Title.Font = Enum.Font.Fondamento
Title.TextSize = 22
Title.Parent = MainFrame

-- Round the title
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 20)
TitleCorner.Parent = Title

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ToggleButton.Text = "Tornado Off"
ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Однотонный тёмно-серый
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый текст
ToggleButton.Font = Enum.Font.Fondamento
ToggleButton.TextSize = 18
ToggleButton.Parent = MainFrame

-- Round the toggle button
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

-- New: TextBox for selecting target player
local TargetPlayerTextBox = Instance.new("TextBox")
TargetPlayerTextBox.Size = UDim2.new(0.8, 0, 0, 35)
TargetPlayerTextBox.Position = UDim2.new(0.1, 0, 0.18, 0)
TargetPlayerTextBox.PlaceholderText = "Enter target player name"
TargetPlayerTextBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TargetPlayerTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetPlayerTextBox.Font = Enum.Font.Fondamento
TargetPlayerTextBox.TextSize = 18
TargetPlayerTextBox.Parent = MainFrame

local TargetPlayerTextBoxCorner = Instance.new("UICorner")
TargetPlayerTextBoxCorner.CornerRadius = UDim.new(0, 10)
TargetPlayerTextBoxCorner.Parent = TargetPlayerTextBox

-- New: Button to throw parts downward
local ThrowDownButton = Instance.new("TextButton")
ThrowDownButton.Size = UDim2.new(0.8, 0, 0, 40)
ThrowDownButton.Position = UDim2.new(0.1, 0, 0.26, 0)
ThrowDownButton.Text = "Throw Parts Down"
ThrowDownButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ThrowDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ThrowDownButton.Font = Enum.Font.Fondamento
ThrowDownButton.TextSize = 18
ThrowDownButton.Parent = MainFrame

local ThrowDownCorner = Instance.new("UICorner")
ThrowDownCorner.CornerRadius = UDim.new(0, 10)
ThrowDownCorner.Parent = ThrowDownButton

-- Configuration table
local config = {
    radius = 50,
    height = 100,
    rotationSpeed = 10,
    attractionStrength = 1000,
    targetPlayer = "" -- New: Store target player name
}

-- Save and load functions
local function saveConfig()
    local configStr = HttpService:JSONEncode(config)
    writefile("SuperRingPartsConfig.txt", configStr)
end

local function loadConfig()
    if isfile("SuperRingPartsConfig.txt") then
        local configStr = readfile("SuperRingPartsConfig.txt")
        config = HttpService:JSONDecode(configStr)
    end
end

loadConfig()

-- Function to create control buttons and textboxes
local function createControl(name, positionY, labelText, defaultValue, callback)
    local DecreaseButton = Instance.new("TextButton")
    DecreaseButton.Size = UDim2.new(0.2, 0, 0, 40)
    DecreaseButton.Position = UDim2.new(0.1, 0, positionY, 0)
    DecreaseButton.Text = "-"
    DecreaseButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Однотонный тёмно-серый
    DecreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DecreaseButton.Font = Enum.Font.Fondamento
    DecreaseButton.TextSize = 18
    DecreaseButton.Parent = MainFrame

    local IncreaseButton = Instance.new("TextButton")
    IncreaseButton.Size = UDim2.new(0.2, 0, 0, 40)
    IncreaseButton.Position = UDim2.new(0.7, 0, positionY, 0)
    IncreaseButton.Text = "+"
    IncreaseButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    IncreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    IncreaseButton.Font = Enum.Font.Fondamento
    IncreaseButton.TextSize = 18
    IncreaseButton.Parent = MainFrame

    local Display = Instance.new("TextLabel")
    Display.Size = UDim2.new(0.4, 0, 0, 40)
    Display.Position = UDim2.new(0.3, 0, positionY, 0)
    Display.Text = labelText .. ": " .. defaultValue
    Display.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Тёмно-серый фон
    Display.TextColor3 = Color3.fromRGB(255, 255, 255)
    Display.Font = Enum.Font.Fondamento
    Display.TextSize = 18
    Display.Parent = MainFrame

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.8, 0, 0, 35)
    TextBox.Position = UDim2.new(0.1, 0, positionY + 0.08, 0)
    TextBox.PlaceholderText = "Enter " .. labelText
    TextBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.Fondamento
    TextBox.TextSize = 18
    TextBox.Parent = MainFrame

    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 10)
    TextBoxCorner.Parent = TextBox

    DecreaseButton.MouseButton1Click:Connect(function()
        local value = tonumber(Display.Text:match("%d+"))
        value = math.max(0, value - 10)
        Display.Text = labelText .. ": " .. value
        callback(value)
        playSound("12221967")
        saveConfig()
    end)

    IncreaseButton.MouseButton1Click:Connect(function()
        local value = tonumber(Display.Text:match("%d+"))
        value = math.min(10000, value + 10)
        Display.Text = labelText .. ": " .. value
        callback(value)
        playSound("12221967")
        saveConfig()
    end)

    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newValue = tonumber(TextBox.Text)
            if newValue then
                newValue = math.clamp(newValue, 0, 10000)
                Display.Text = labelText .. ": " .. newValue
                TextBox.Text = ""
                callback(newValue)
                playSound("12221967")
                saveConfig()
            else
                TextBox.Text = ""
            end
        end
    end)
end

-- Adjusted positions to accommodate new elements
createControl("Radius", 0.34, "Radius", config.radius, function(value)
    config.radius = value
    saveConfig()
end)

createControl("Height", 0.50, "Height", config.height, function(value)
    config.height = value
    saveConfig()
end)

createControl("RotationSpeed", 0.66, "Rotation Speed", config.rotationSpeed, function(value)
    config.rotationSpeed = value
    saveConfig()
end)

createControl("AttractionStrength", 0.82, "Attraction Strength", config.attractionStrength, function(value)
    config.attractionStrength = value
    saveConfig()
end)

-- Minimize button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
MinimizeButton.Text = "-"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MinimizeButton.TextColor3 = Color3.fromRGB( AscendantColor3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.Fondamento
MinimizeButton.TextSize = 15
MinimizeButton.Parent = MainFrame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 15)
MinimizeCorner.Parent = MinimizeButton

-- Minimize functionality
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame:TweenSize(UDim2.new(0, 300, 0, 40), "Out", "Quad", 0.3, true)
        MinimizeButton.Text = "+"
        for _, child in pairs(MainFrame:GetChildren()) do
            if child:IsA("GuiObject") and child ~= Title and child ~= MinimizeButton then
                child.Visible = false
            end
        end
    else
        MainFrame:TweenSize(UDim2.new(0, 300, 0, 550), "Out", "Quad", 0.3, true)
        MinimizeButton.Text = "-"
        for _, child in pairs(MainFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Visible = true
            end
        end
    end
    playSound("12221967")
end)

-- Make GUI draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Ring Parts Claim
local Workspace = game:GetService("Workspace")

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
    }

    Network.RetainPart = function(Part)
        if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, Part)
            Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Part.CanCollide = false
        end
    end

    local function EnablePartControl()
        LocalPlayer.ReplicationFocus = Workspace
        RunService.Heartbeat:Connect(function()
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            for _, Part in pairs(Network.BaseParts) do
                if Part:IsDescendantOf(Workspace) then
                    Part.Velocity = Network.Velocity
                end
            end
        end)
    end

    EnablePartControl()
end

local function ForcePart(v)
    if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, x in next, v:GetChildren() do
            if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        if v:FindFirstChild("Attachment") then
            v:FindFirstChild("Attachment"):Destroy()
        end
        if v:FindFirstChild("AlignPosition") then
            v:FindFirstChild("AlignPosition"):Destroy()
        end
        if v:FindFirstChild("Torque") then
            v:FindFirstChild("Torque"):Destroy()
        end
        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(100000, 100000, 100000)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = 9999999999999999999999999999999
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 200
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end

-- Edits
local ringPartsEnabled = false

local function RetainPart(Part)
    if Part:IsA("BasePart") and not Part.Anchored and Part:IsDescendantOf(Workspace) then
        if Part.Parent == LocalPlayer.Character or Part:IsDescendantOf(LocalPlayer.Character) then
            return false
        end
        Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
        Part.CanCollide = false
        return true
    end
    return false
end

local parts = {}
local function addPart(part)
    if RetainPart(part) then
        if not table.find(parts, part) then
            table.insert(parts, part)
        end
    end
end

local function removePart(part)
    local index = table.find(parts, part)
    if index then
        table.remove(parts, index)
    end
end

for _, part in pairs(Workspace:GetDescendants()) do
    addPart(part)
end

Workspace.DescendantAdded:Connect(addPart)
Workspace.DescendantRemoving:Connect(removePart)

-- New: Function to get target player's HumanoidRootPart
local function getTargetRootPart()
    if config.targetPlayer ~= "" then
        local targetPlayer = Players:FindFirstChild(config.targetPlayer)
        if targetPlayer and targetPlayer.Character then
            return targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        end
    end
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- New: Handle target player selection
TargetPlayerTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local playerName = TargetPlayerTextBox.Text
        local player = Players:FindFirstChild(playerName)
        if player then
            config.targetPlayer = playerName
            TargetPlayerTextBox.Text = ""
            playSound("12221967")
            saveConfig()
        else
            TargetPlayerTextBox.Text = ""
            StarterGui:SetCore("SendNotification", {
                Title = "Error",
                Text = "Player not found!",
                Duration = 3
            })
        end
    end
end)

-- New: Function to throw parts downward
ThrowDownButton.MouseButton1Click:Connect(function()
    for _, part in pairs(parts) do
        if part.Parent and not part.Anchored then
            part.Velocity = Vector3.new(0, -5000, 0) -- Extremely high downward force
        end
    end
    playSound("12221967")
end)

RunService.Heartbeat:Connect(function()
    if not ringPartsEnabled then return end
    
    local targetRootPart = getTargetRootPart()
    if targetRootPart then
        local tornadoCenter = targetRootPart.Position
        for _, part in pairs(parts) do
            if part.Parent and not part.Anchored then
                local pos = part.Position
                local distance = (Vector3.new(pos.X, tornadoCenter.Y, pos.Z) - tornadoCenter).Magnitude
                local angle = math.atan2(pos.Z - tornadoCenter.Z, pos.X - tornadoCenter.X)
                local newAngle = angle + math.rad(config.rotationSpeed)
                local targetPos = Vector3.new(
                    tornadoCenter.X + math.cos(newAngle) * math.min(config.radius, distance),
                    tornadoCenter.Y + (config.height * (math.abs(math.sin((pos.Y - tornadoCenter.Y) / config.height)))),
                    tornadoCenter.Z + math.sin(newAngle) * math.min(config.radius, distance)
                )
                local directionToTarget = (targetPos - part.Position).unit
                part.Velocity = directionToTarget * config.attractionStrength
            end
        end
    end
end)

-- Button functionality
ToggleButton.MouseButton1Click:Connect(function()
    ringPartsEnabled = not ringPartsEnabled
    ToggleButton.Text = ringPartsEnabled and "Tornado On" or "Tornado Off"
    ToggleButton.BackgroundColor3 = ringPartsEnabled and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(70, 70, 70) -- Slightly lighter when active
    playSound("12221967")
end)

-- Get player thumbnail
local userId = Players:GetUserIdFromNameAsync("Robloxlukasgames")
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

StarterGui:SetCore("SendNotification", {
    Title = "Hey",
    Text = "Enjoy the Script!",
    Icon = content,
    Duration = 5
})

StarterGui:SetCore("SendNotification", {
    Title = "TIPS",
    Text = "Click Textbox To edit Any of them",
    Icon = content,
    Duration = 5
})

StarterGui:SetCore("SendNotification", {
    Title = "Credits",
    Text = "On scriptblox!",
    Icon = content,
    Duration = 5
})

-- Additional buttons (Fly GUI, No Fall Damage, etc.) with updated style
local function createUtilityButton(name, positionX, text)
    local button = Instance.new("TextButton")
    button.Parent = MainFrame
    button.Name = name
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.BackgroundTransparency = 0
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(50, 50, 50)
    button.Position = UDim2.new(positionX, 0, 1, 0)
    button.Size = UDim2.new(0.08, 0, 0.1, 0)
    button.Font = Enum.Font.Legacy
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.TextSize = 18
    button.TextScaled = true
    button.TextWrapped = true
    button.Visible = true
    button.Active = true
    return button
end

-- Fly GUI
createUtilityButton("Fly gui", 1, "Fly Gui").MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://pastebin.com/raw/YSL3xKYU'))()
end)

-- No Fall Damage
createUtilityButton("no fall damage", 0.9, "No fall Damage").MouseButton1Click:Connect(function()
    local runsvc = game:GetService("RunService")
    local heartbeat = runsvc.Heartbeat
    local rstepped = runsvc.RenderStepped
    local lp = game.Players.LocalPlayer
    local novel = Vector3.zero
    local function nofalldamage(chr)
        local root = chr:WaitForChild("HumanoidRootPart")
        if root then
            local con
            con = heartbeat:Connect(function()
                if not root.Parent then
                    con:Disconnect()
                end
                local oldvel = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = novel
                rstepped:Wait()
                root.AssemblyLinearVelocity = oldvel
            end)
        end
    end
    nofalldamage(lp.Character)
    lp.CharacterAdded:Connect(nofalldamage)
end)

-- Noclip
createUtilityButton("noclip", 0.8, "Noclip").MouseButton1Click:Connect(function()
    local Noclip = nil
    local Clip = nil
    function noclip()
        Clip = false
        local function Nocl()
            if Clip == false and game.Players.LocalPlayer.Character ~= nil then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA('BasePart') and v.CanCollide and v.Name ~= floatName then
                        v.CanCollide = false
                    end
                end
            end
            wait(0.21)
        end
        Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
    end
    function clip()
        if Noclip then Noclip:Disconnect() end
        Clip = true
    end
    noclip()
end)

-- Infinite Jump
createUtilityButton("Inf jump", 0.7, "Inf jump").MouseButton1Click:Connect(function()
    local InfiniteJumpEnabled = true
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if InfiniteJumpEnabled then
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
        end
    end)
end)

-- Infinite Yield
createUtilityButton("Inf yield", 0.6, "Inf yield").MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

-- Nameless Admin
createUtilityButton("nameless admin", 0.5, "NAMELESS").MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Nameless-Admin-FE-11243"))()
end)

-- FPS
createUtilityButton("FPS", 0.4, "FPS").MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://pastebin.com/raw/ySHJdZpb", true))()
end)
