-- Mobile Camera Speed Slider GUI
-- Works with Delta / most executors. Paste and execute.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- GUI SETUP
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CamSpeed_" .. math.random(1, 999999)
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Protect if executor supports it
pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(screenGui) end
    if protect_gui then protect_gui(screenGui) end
end)

screenGui.Parent = playerGui

-- ============================================================
-- TOGGLE BUTTON (floating)
-- ============================================================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
toggleBtn.BackgroundTransparency = 0.1
toggleBtn.Text = "⚙"
toggleBtn.TextColor3 = Color3.fromRGB(80, 180, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Active = true
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(80, 180, 255)
toggleStroke.Thickness = 2
toggleStroke.Transparency = 0.3
toggleStroke.Parent = toggleBtn

-- ============================================================
-- MAIN PANEL
-- ============================================================
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 260, 0, 150)
panel.Position = UDim2.new(0.5, -130, 0, 60)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
panel.BackgroundTransparency = 0.1
panel.BorderSizePixel = 0
panel.Active = true
panel.Visible = false -- hidden until toggle pressed
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 10)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(80, 180, 255)
panelStroke.Thickness = 2
panelStroke.Transparency = 0.3
panelStroke.Parent = panel

-- Title
local title = Instance.new("TextLabel")
title.Text = "Camera Speed"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 4)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = panel

-- Value label
local valueLabel = Instance.new("TextLabel")
valueLabel.Text = "1.0x"
valueLabel.Size = UDim2.new(1, 0, 0, 24)
valueLabel.Position = UDim2.new(0, 0, 0, 34)
valueLabel.BackgroundTransparency = 1
valueLabel.TextColor3 = Color3.fromRGB(80, 180, 255)
valueLabel.TextScaled = true
valueLabel.Font = Enum.Font.GothamBold
valueLabel.Parent = panel

-- Slider track
local track = Instance.new("Frame")
track.Name = "Track"
track.Size = UDim2.new(1, -40, 0, 10)
track.Position = UDim2.new(0, 20, 0, 78)
track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
track.BorderSizePixel = 0
track.Parent = panel

local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = track

-- Fill
local fill = Instance.new("Frame")
fill.Name = "Fill"
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
fill.BorderSizePixel = 0
fill.Parent = track

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = fill

-- Knob
local knob = Instance.new("Frame")
knob.Name = "Knob"
knob.Size = UDim2.new(0, 22, 0, 22)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(0, 0, 0.5, 0)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.BorderSizePixel = 0
knob.Parent = track

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = knob

local knobStroke = Instance.new("UIStroke")
knobStroke.Color = Color3.fromRGB(80, 180, 255)
knobStroke.Thickness = 2
knobStroke.Parent = knob

-- Range labels
local minLabel = Instance.new("TextLabel")
minLabel.Text = "1x"
minLabel.Size = UDim2.new(0, 40, 0, 20)
minLabel.Position = UDim2.new(0, 10, 0, 100)
minLabel.BackgroundTransparency = 1
minLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
minLabel.TextScaled = true
minLabel.Font = Enum.Font.Gotham
minLabel.Parent = panel

local maxLabel = Instance.new("TextLabel")
maxLabel.Text = "10x"
maxLabel.Size = UDim2.new(0, 40, 0, 20)
maxLabel.Position = UDim2.new(1, -50, 0, 100)
maxLabel.BackgroundTransparency = 1
maxLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
maxLabel.TextScaled = true
maxLabel.Font = Enum.Font.Gotham
maxLabel.Parent = panel

-- Reset button
local resetBtn = Instance.new("TextButton")
resetBtn.Text = "Reset"
resetBtn.Size = UDim2.new(0, 80, 0, 26)
resetBtn.Position = UDim2.new(0.5, -40, 1, -34)
resetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
resetBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
resetBtn.TextScaled = true
resetBtn.Font = Enum.Font.GothamBold
resetBtn.BorderSizePixel = 0
resetBtn.Parent = panel

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = resetBtn

-- ============================================================
-- TOGGLE LOGIC
-- ============================================================
toggleBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- ============================================================
-- CAMERA BOOST LOGIC
-- ============================================================
local camera = workspace.CurrentCamera
local MIN_MULT = 1.0
local MAX_MULT = 10.0
local currentMult = 1.0

-- Try the UserSettings method first (cleaner)
local UserSettingsOK = pcall(function()
    local US = UserSettings()
    local GS = US.GameSettings
    -- store originals
    _G.__origTouch = GS.TouchCameraSensitivity
    _G.__origMouse = GS.MouseSensitivity
    _G.__origGamepad = GS.GamepadCameraSensitivity
end)

local function applySensitivity(mult)
    currentMult = mult
    valueLabel.Text = string.format("%.1fx", mult)

    -- Update slider UI
    local t = (mult - MIN_MULT) / (MAX_MULT - MIN_MULT)
    fill.Size = UDim2.new(t, 0, 1, 0)
    knob.Position = UDim2.new(t, 0, 0.5, 0)

    -- Apply via UserSettings if available
    if UserSettingsOK then
        pcall(function()
            local GS = UserSettings().GameSettings
            GS.TouchCameraSensitivity = (_G.__origTouch or 1) * mult
            GS.MouseSensitivity = (_G.__origMouse or 1) * mult
            GS.GamepadCameraSensitivity = (_G.__origGamepad or 1) * mult
        end)
    end
end

applySensitivity(1.0)

-- ============================================================
-- SLIDER INPUT
-- ============================================================
local dragging = false

local function updateFromInput(input)
    local trackPos = track.AbsolutePosition
    local trackSize = track.AbsoluteSize
    local relX = input.Position.X - trackPos.X
    local t = math.clamp(relX / trackSize.X, 0, 1)
    local mult = MIN_MULT + t * (MAX_MULT - MIN_MULT)
    applySensitivity(mult)
end

local function sliderBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateFromInput(input)
    end
end

track.InputBegan:Connect(sliderBegan)
knob.InputBegan:Connect(sliderBegan)
fill.InputBegan:Connect(sliderBegan)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        updateFromInput(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

resetBtn.MouseButton1Click:Connect(function()
    applySensitivity(1.0)
end)

-- ============================================================
-- PANEL DRAGGING
-- ============================================================
local draggingPanel = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingPanel = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingPanel and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingPanel = false
    end
end)

print("[CamSpeed] Loaded. Tap the ⚙ button to open.")
