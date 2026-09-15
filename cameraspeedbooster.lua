-- Mobile Camera Speed Slider GUI (Direct Camera Method)
-- Works even when UserSettings is blocked

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

pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(screenGui) end
    if protect_gui then protect_gui(screenGui) end
end)

screenGui.Parent = playerGui

-- Toggle button
local toggleBtn = Instance.new("TextButton")
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

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(1, 0)
tc.Parent = toggleBtn

local ts = Instance.new("UIStroke")
ts.Color = Color3.fromRGB(80, 180, 255)
ts.Thickness = 2
ts.Transparency = 0.3
ts.Parent = toggleBtn

-- Panel
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 260, 0, 150)
panel.Position = UDim2.new(0.5, -130, 0, 60)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
panel.BackgroundTransparency = 0.1
panel.BorderSizePixel = 0
panel.Active = true
panel.Visible = false
panel.Parent = screenGui

local pc = Instance.new("UICorner")
pc.CornerRadius = UDim.new(0, 10)
pc.Parent = panel

local ps = Instance.new("UIStroke")
ps.Color = Color3.fromRGB(80, 180, 255)
ps.Thickness = 2
ps.Transparency = 0.3
ps.Parent = panel

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

-- Track
local track = Instance.new("Frame")
track.Size = UDim2.new(1, -40, 0, 10)
track.Position = UDim2.new(0, 20, 0, 78)
track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
track.BorderSizePixel = 0
track.Parent = panel

local trc = Instance.new("UICorner")
trc.CornerRadius = UDim.new(1, 0)
trc.Parent = track

-- Fill
local fill = Instance.new("Frame")
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
fill.BorderSizePixel = 0
fill.Parent = track

local fc = Instance.new("UICorner")
fc.CornerRadius = UDim.new(1, 0)
fc.Parent = fill

-- Knob
local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 22, 0, 22)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(0, 0, 0.5, 0)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.BorderSizePixel = 0
knob.Parent = track

local kc = Instance.new("UICorner")
kc.CornerRadius = UDim.new(1, 0)
kc.Parent = knob

local ks = Instance.new("UIStroke")
ks.Color = Color3.fromRGB(80, 180, 255)
ks.Thickness = 2
ks.Parent = knob

-- Range labels
local minL = Instance.new("TextLabel")
minL.Text = "1x"
minL.Size = UDim2.new(0, 40, 0, 20)
minL.Position = UDim2.new(0, 10, 0, 100)
minL.BackgroundTransparency = 1
minL.TextColor3 = Color3.fromRGB(180, 180, 180)
minL.TextScaled = true
minL.Font = Enum.Font.Gotham
minL.Parent = panel

local maxL = Instance.new("TextLabel")
maxL.Text = "5x"
maxL.Size = UDim2.new(0, 40, 0, 20)
maxL.Position = UDim2.new(1, -50, 0, 100)
maxL.BackgroundTransparency = 1
maxL.TextColor3 = Color3.fromRGB(180, 180, 180)
maxL.TextScaled = true
maxL.Font = Enum.Font.Gotham
maxL.Parent = panel

-- Reset
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

local rc = Instance.new("UICorner")
rc.CornerRadius = UDim.new(0, 6)
rc.Parent = resetBtn

-- Toggle
toggleBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- ============================================================
-- CAMERA BOOST - DIRECT ROTATION
-- ============================================================
local MIN_MULT = 1.0
local MAX_MULT = 5.0
local currentMult = 1.0

local function applySensitivity(mult)
    currentMult = mult
    valueLabel.Text = string.format("%.1fx", mult)
    local t = (mult - MIN_MULT) / (MAX_MULT - MIN_MULT)
    fill.Size = UDim2.new(t, 0, 1, 0)
    knob.Position = UDim2.new(t, 0, 0.5, 0)
end

applySensitivity(1.0)

-- Hook camera rotation directly
-- We listen for the raw mouse/touch delta and multiply the camera rotation
local cam = workspace.CurrentCamera

UserInputService.InputChanged:Connect(function(input)
    if currentMult <= 1.01 then return end

    local isMouse = input.UserInputType == Enum.UserInputType.MouseMovement
    local isTouch = input.UserInputType == Enum.UserInputType.Touch

    if isMouse or isTouch then
        local delta = input.Delta
        if delta.Magnitude < 0.5 then return end

        -- Extra rotation on top of what the game already applies
        -- Wait a frame so the game's own rotation happens first
        RunService.RenderStepped:Wait()

        local cam = workspace.CurrentCamera
        if cam then
            local extra = (currentMult - 1.0)
            local rotY = math.rad(-delta.X * extra * 0.25)
            local rotX = math.rad(-delta.Y * extra * 0.25)

            local cf = cam.CFrame
            cf = cf * CFrame.Angles(0, rotY, 0)
            cf = cf * CFrame.Angles(rotX, 0, 0)
            cam.CFrame = cf
        end
    end
end)

-- ============================================================
-- SLIDER INPUT
-- ============================================================
local dragging = false

local function updateFromInput(input)
    local tp = track.AbsolutePosition
    local tsz = track.AbsoluteSize
    local relX = input.Position.X - tp.X
    local t = math.clamp(relX / tsz.X, 0, 1)
    applySensitivity(MIN_MULT + t * (MAX_MULT - MIN_MULT))
end

local function began(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateFromInput(input)
    end
end

track.InputBegan:Connect(began)
knob.InputBegan:Connect(began)
fill.InputBegan:Connect(began)

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

-- Panel drag
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

print("[CamSpeed] Loaded - direct rotation mode")
