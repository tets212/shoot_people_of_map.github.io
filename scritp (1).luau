local player = game.Players.LocalPlayer
local targets = {}

local function updateTargets()
    targets = {}
    for _, npc in ipairs(game.Workspace.NPCs:GetChildren()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
            table.insert(targets, npc.Name)
        end
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 400)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 13)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 5
uiStroke.Transparency = 0.7
uiStroke.Color = Color3.fromRGB(0, 0, 0)
uiStroke.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -60, 0, 10)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.FredokaOne
closeButton.Parent = mainFrame

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0, 8)
closeButtonCorner.Parent = closeButton

local TweenService = game:GetService("TweenService")

local function closeGui()
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 400)})
    tween:Play()
    tween.Completed:Wait()
    screenGui.Enabled = false
end

closeButton.MouseButton1Click:Connect(closeGui)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -80)
scrollingFrame.Position = UDim2.new(0, 10, 0, 70)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 4, 0)
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.Parent = mainFrame

local function updateScrollingFrame()
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end

    updateTargets()

    for i, npcName in ipairs(targets) do
        local teleporting = false
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 0, 50)
        label.Position = UDim2.new(0, 0, 0, (i-1) * 60)
        label.Text = "Auto " .. npcName
        label.TextScaled = true
        label.TextColor3 = Color3.fromRGB(255, 204, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.FredokaOne
        label.Parent = scrollingFrame

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.2, 0, 0, 50)
        button.Position = UDim2.new(0.75, 0, 0, (i-1) * 60)
        button.Text = "Off"
        button.TextScaled = true
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundTransparency = 0.5
        button.Font = Enum.Font.FredokaOne
        button.Parent = scrollingFrame

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button
        
        local function toggleTeleport()
            teleporting = not teleporting
            if teleporting then
                button.Text = "On"
                button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                while teleporting do
                    local targetNPC = game.Workspace.ClientNPCs:FindFirstChild(npcName)
                    local character = player.Character
                    if targetNPC and targetNPC.PrimaryPart and character then
                        character:MoveTo(targetNPC.PrimaryPart.Position)
                    end
                    wait(1)
                end
            else
                button.Text = "Off"
                button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        end

        button.MouseButton1Click:Connect(toggleTeleport)
    end
end

local guiOpen = false

local function toggleGui()
    guiOpen = not guiOpen
    if guiOpen then
        screenGui.Enabled = true
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 400, 0, 400)})
        tween:Play()
        updateScrollingFrame()
    else
        closeGui()
    end
end

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.LeftShift then
        toggleGui()
    end
end)

while true do
    updateScrollingFrame()
    wait(2) -- Alle 2 Sekunden aktualisieren
end
