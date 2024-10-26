local players = game:GetService("Players")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local player = players.LocalPlayer

local espEnabled = false
local sigmaModeEnabled = false
local guiVisible = true

local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function createESP(targetPlayer)
    if targetPlayer.Character and not targetPlayer.Character:FindFirstChildOfClass("Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.new(0, 0, 0)
        highlight.OutlineTransparency = 0
        highlight.Adornee = targetPlayer.Character
        highlight.Parent = targetPlayer.Character
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    for _, targetPlayer in pairs(players:GetPlayers()) do
        local highlight = targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Highlight")
        if highlight then
            highlight.Enabled = espEnabled
        elseif espEnabled then
            createESP(targetPlayer)
        end
    end
end

local function createPlatform()
    local platform = Instance.new("Part")
    platform.Name = "SigmaPlatform"
    platform.Size = Vector3.new(2048, 1, 2048)
    platform.Position = Vector3.new(-130.44313, 746.554749, -248.734924)
    platform.Transparency = 1
    platform.Anchored = true
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Parent = game.Workspace
end

local function toggleSigmaMode()
    sigmaModeEnabled = not sigmaModeEnabled
    if sigmaModeEnabled then
        createPlatform()
    else
        local platform = game.Workspace:FindFirstChild("SigmaPlatform")
        if platform then
            platform:Destroy()
        end
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "CopyHubGUI"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Visible = guiVisible
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "CopyHub"
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.TextSize = 20
titleLabel.Parent = frame

local separator1 = Instance.new("TextLabel")
separator1.Text = "--------------------"
separator1.Size = UDim2.new(1, 0, 0, 15)
separator1.Position = UDim2.new(0, 0, 0, 25)
separator1.BackgroundTransparency = 1
separator1.TextColor3 = Color3.fromRGB(255, 255, 255)
separator1.Font = Enum.Font.FredokaOne
separator1.TextSize = 18
separator1.Parent = frame

local espButton = Instance.new("TextButton")
espButton.Text = "ESP Off"
espButton.Size = UDim2.new(0.8, 0, 0, 30)
espButton.Position = UDim2.new(0.1, 0, 0.35, 0)
espButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.FredokaOne
espButton.TextSize = 18
espButton.Parent = frame

local espButtonCorner = Instance.new("UICorner")
espButtonCorner.CornerRadius = UDim.new(0, 8)
espButtonCorner.Parent = espButton

local sigmaButton = Instance.new("TextButton")
sigmaButton.Text = "Sigma Mode Off"
sigmaButton.Size = UDim2.new(0.8, 0, 0, 30)
sigmaButton.Position = UDim2.new(0.1, 0, 0.6, 0)
sigmaButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
sigmaButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sigmaButton.Font = Enum.Font.FredokaOne
sigmaButton.TextSize = 18
sigmaButton.Parent = frame

local sigmaButtonCorner = Instance.new("UICorner")
sigmaButtonCorner.CornerRadius = UDim.new(0, 8)
sigmaButtonCorner.Parent = sigmaButton

local separator2 = Instance.new("TextLabel")
separator2.Text = "--------------------"
separator2.Size = UDim2.new(1, 0, 0, 15)
separator2.Position = UDim2.new(0, 0, 0.75, 0)
separator2.BackgroundTransparency = 1
separator2.TextColor3 = Color3.fromRGB(255, 255, 255)
separator2.Font = Enum.Font.FredokaOne
separator2.TextSize = 18
separator2.Parent = frame

local footerLabel = Instance.new("TextLabel")
footerLabel.Text = "CopyHub"
footerLabel.Size = UDim2.new(1, 0, 0, 25)
footerLabel.Position = UDim2.new(0, 0, 0.85, 0)
footerLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
footerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
footerLabel.Font = Enum.Font.FredokaOne
footerLabel.TextSize = 20
footerLabel.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Text = "Open/Close"
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0.5, -50, 0.9, -15)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.FredokaOne
toggleButton.TextSize = 18
toggleButton.Parent = screenGui

local toggleButtonCorner = Instance.new("UICorner")
toggleButtonCorner.CornerRadius = UDim.new(0, 8)
toggleButtonCorner.Parent = toggleButton

espButton.MouseButton1Click:Connect(function()
    toggleESP()
    espButton.Text = espEnabled and "ESP On" or "ESP Off"
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

sigmaButton.MouseButton1Click:Connect(function()
    toggleSigmaMode()
    sigmaButton.Text = sigmaModeEnabled and "Sigma Mode On" or "Sigma Mode Off"
    sigmaButton.BackgroundColor3 = sigmaModeEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

local function openFrame()
    frame.Visible = true
    local openTween = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 150), Transparency = 0})
    openTween:Play()
    openTween.Completed:Wait()
end

local function closeFrame()
    local closeTween = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 0), Transparency = 1})
    closeTween:Play()
    closeTween.Completed:Wait()
    frame.Visible = false
end

toggleButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    if guiVisible then
        openFrame()
    else
        closeFrame()
    end
end)

players.PlayerAdded:Connect(function(targetPlayer)
    targetPlayer.CharacterAdded:Connect(function()
        if espEnabled then
            createESP(targetPlayer)
        end
    end)
end)

for _, targetPlayer in pairs(players:GetPlayers()) do
    if targetPlayer.Character and espEnabled then
        createESP(targetPlayer)
    end
end

runService.RenderStepped:Connect(function()
    if espEnabled then
        for _, targetPlayer in pairs(players:GetPlayers()) do
            if targetPlayer.Character then
                local highlight = targetPlayer.Character:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight.Enabled = espEnabled
                    highlight.Adornee = targetPlayer.Character
                end
            end
        end
    end
end)

player.CharacterAdded:Connect(function()
    frame.Visible = guiVisible
    if espEnabled then
        createESP(player)
    end
end)

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
