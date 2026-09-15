-- Camera Sensitivity Slider GUI (Delta Executor Version)
-- Paste into Delta Executor and execute

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Get a safe GUI container (gethui works in most executors, fallback to PlayerGui)
local function getGuiParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    return player:WaitForChild("PlayerGui")
end

-- Get UserSettings safely
local UserSettings = UserSettings()
local GameSettings = UserSettings.GameSettings

-- ============================================================
-- STORE ORIGINAL VALUES
-- ============================================================
local baseTouch = GameSettings.TouchCameraSensitivity
local baseMouse = GameSettings.MouseSensitivity
local baseGamepad = GameSettings.GamepadCameraSensitivity

-- ============================================================
-- GUI
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CameraSensitivityGUI_" and .. tostring(math.random(1, 1e6))
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Try to protect from detection (some executors support this)
pcall(function()
    if syn syn.protect_gui then
        syn.protect_gui(screenGui)
    elseif protect_gui then
        protect_gui(screenGui)
    end
end)

screenGui.Parent = getGuiParent()

-- Main panel
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 260, 0, 120)
panel.Position = UDim2.new(0.5, -130, 0, 20)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
panel.BackgroundTransparency = 0.15
panel.BorderSizePixel = 0
panel.Active = true
panel.Draggable = false
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
title.Name = "Title"
title.Text = "Camera Sensitivity"
title.Size = UDim2.new(1, 0, 0, 28)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = panel

-- Value label
local valueLabel = Instance.new("TextLabel")
valueLabel.Name = "ValueLabel"
valueLabel.Text = "3.0x"
valueLabel.Size = UDim2.new(1, 0, 0, 22)
valueLabel.Position = UDim2.new(0, 0, 0, 28)
valueLabel.BackgroundTransparency = 1
valueLabel.TextColor3 = Color3.fromRGB(80, 180, 255)
valueLabel.TextScaled = true
valueLabel.Font = Enum.Font.GothamBold
valueLabel.Parent = panel

-- Slider track
local track = Instance.new("Frame")
track.Name = "Track"
track.Size = UDim2.new(1, -40, 0, 8)
track.Position = UDim2.new(0, 20, 0, 65)
track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
track.BorderSizePixel = 0
track.Parent = panel

local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = track

-- Fill bar
local fill = Instance.new("Frame")
fill.Name = "Fill"
fill.Size = UDim2.new(0.4, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
fill.BorderSizePixel = 0
fill.Parent = track

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = fill

-- Slider knob
local knob = Instance.new("Frame")
knob.Name = "Knob"
knob.Size = UDim2.new(0, 22, 0, 22)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(0.4, 0, 0.5, 0)
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
minLabel.Position = UDim2.new(0, 5, 0, 82)
minLabel.BackgroundTransparency = 1
minLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
minLabel.TextScaled = true
minLabel.Font = Enum.Font.Gotham
minLabel.Parent = panel

local maxLabel = Instance.new("TextLabel")
maxLabel.Text = "8x"
maxLabel.Size = UDim2.new(0, 40, 0, 20)
maxLabel.Position = UDim2.new(1, -45, 0, 82)
maxLabel.BackgroundTransparency = 1
maxLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
maxLabel.TextScaled = true
maxLabel.Font = Enum.Font.Gotham
maxLabel.Parent = panel

-- ============================================================
-- TOGGLE BUTTON (Delta convenience - press to hide/show panel)
-- ============================================================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
toggleBtn.BackgroundTransparency = 0.15
toggleBtn.Text = "⚙"
toggleBtn.TextColor3 = Color3.fromRGB(80, 180, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(80, 180, 255)
toggleStroke.Thickness = 2
toggleStroke.Transparency = 0.3
toggleStroke.Parent = toggleBtn

toggleBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- ============================================================
-- SLIDER LOGIC
-- ============================================================
local MIN_MULT = 1.0
local MAX_MULT = 8.0
local currentMult = 3.0

local function applyMultiplier(mult)
    pcall(function()
        GameSettings.TouchCameraSensitivity = baseTouch * mult
        GameSettings.MouseSensitivity = baseMouse * mult
        GameSettings.GamepadCameraSensitivity = baseGamepad * mult
    end)

    valueLabel.Text = string.format("%.1fx", mult)

    local t = (mult - MIN_MULT) / (MAX_MULT - MIN_MULT)
    fill.Size = UDim2.new(t, 0, 1, 0)
    knob.Position = UDim2.new(t, 0, 0.5, 0)
end

applyMultiplier(currentMult)

local dragging = false

local function updateFromInput(input)
    local trackAbsolutePos = track.AbsolutePosition
    local trackAbsoluteSize = track.AbsoluteSize

    local relativeX = input.Position.X - trackAbsolutePos.X
    local t = math.clamp(relativeX / trackAbsoluteSize.X, 0, 1)
    local mult = MIN_MULT + t * (MAX_MULT - MIN_MULT)

    currentMult = mult
    applyMultiplier(mult)
end

-- Make slider interactive (works on both track and knob for easier grabbing)
local function sliderInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateFromInput(input)
    end
end

track.InputBegan:Connect(sliderInputBegan)
knob.InputBegan:Connect(sliderInputBegan)

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

-- ============================================================
-- PANEL DRAGGING
-- ============================================================
local draggingPanel = false
local dragStart, startPos

panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        -- Don't drag if touching the slider track/knob
        local touchY = input.Position.Y
        local trackTop = track.AbsolutePosition.Y - 12
        local trackBottom = track.AbsolutePosition.Y + track.AbsoluteSize.Y + 12
        if touchY >= trackTop and touchY <= trackBottom then
            return
        end
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
