-- Mobile Camera Speed Slider GUI (smooth, joystick-safe)
-- Works with Delta / most executors

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

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local tstroke = Instance.new("UIStroke", toggleBtn)
tstroke.Color = Color3.fromRGB(80, 180, 255)
tstroke.Thickness = 2
tstroke.Transparency = 0.3

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

Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
local pstroke = Instance.new("UIStroke", panel)
pstroke.Color = Color3.fromRGB(80, 180, 255)
pstroke.Thickness = 2
pstroke.Transparency = 0.3

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

-- Value
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
Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

-- Fill
local fill = Instance.new("Frame")
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
fill.BorderSizePixel = 0
fill.Parent = track
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

-- Knob
local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 22, 0, 22)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(0, 0, 0.5, 0)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.BorderSizePixel = 0
knob.Parent = track
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
local kstroke = Instance.new("UIStroke", knob)
kstroke.Color = Color3.fromRGB(80, 180, 255)
kstroke.Thickness = 2

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
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)

toggleBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- ============================================================
-- CAMERA SPEED LOGIC
-- ============================================================
local MIN_MULT = 1.0
local MAX_MULT = 5.0
local currentMult = 1.0
local BASE_SENS = 0.0035

local function applySensitivity(mult)
    currentMult = mult
    valueLabel.Text = string.format("%.1fx", mult)
    local t = (mult - MIN_MULT) / (MAX_MULT - MIN_MULT)
    fill.Size = UDim2.new(t, 0, 1, 0)
    knob.Position = UDim2.new(t, 0, 0.5, 0)
end

applySensitivity(1.0)

-- Camera state
local targetYaw, targetPitch = 0, 0
local currentYaw, currentPitch = 0, 0
local initialized = false

local function syncFromCamera()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local look = cam.CFrame.LookVector
    targetYaw = math.atan2(-look.X, -look.Z)
    targetPitch = math.asin(math.clamp(look.Y, -1, 1))
    currentYaw = targetYaw
    currentPitch = targetPitch
    initialized = true
end

if workspace.CurrentCamera then
    syncFromCamera()
else
    workspace:GetPropertyChangedSignal("CurrentCamera"):Wait()
    syncFromCamera()
end

-- ============================================================
-- TOUCH CLASSIFICATION (joystick-safe)
-- ============================================================
local cameraTouches = {}
local touchInfo = {}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        local cam = workspace.CurrentCamera
        local isRightHalf = cam and input.Position.X > cam.ViewportSize.X * 0.5

        touchInfo[input] = {
            startPos = input.Position,
            isCamera = isRightHalf,
            driftRight = 0,
        }

        if isRightHalf then
            cameraTouches[input] = true
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    -- Update touch classification
    if input.UserInputType == Enum.UserInputType.Touch then
        local info = touchInfo[input]
        if info then
            local dx = input.Position.X - info.startPos.X
            if dx > info.driftRight then info.driftRight = dx end

            -- Left-side touch that drifts far right = camera
            if not info.isCamera and info.driftRight > 40 then
                info.isCamera = true
                cameraTouches[input] = true
            end
        end
    end

    -- Apply camera rotation for classified camera touches
    if not initialized then return end
    if currentMult <= 1.01 then return end

    local delta = input.Delta
    if delta.Magnitude < 0.1 then return end

    local isCameraInput = false
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        isCameraInput = true
    elseif input.UserInputType == Enum.UserInputType.Touch then
        isCameraInput = cameraTouches[input] == true
    end

    if not isCameraInput then return end

    local sens = BASE_SENS * currentMult
    targetYaw = targetYaw - delta.X * sens
    targetPitch = math.clamp(targetPitch - delta.Y * sens, -math.rad(85), math.rad(85))
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        cameraTouches[input] = nil
        touchInfo[input] = nil
    end
end)

-- Smooth camera update each frame
RunService:BindToRenderStep("CamSpeedBoost", Enum.RenderPriority.Camera.Value + 1, function(dt)
    if not initialized then return end

    local cam = workspace.CurrentCamera
    if not cam then return end

    if currentMult <= 1.01 then
        -- Release camera, keep state synced
        local look = cam.CFrame.LookVector
        targetYaw = math.atan2(-look.X, -look.Z)
        targetPitch = math.asin(math.clamp(look.Y, -1, 1))
        currentYaw = targetYaw
        currentPitch = targetPitch
        return
    end

    local alpha = math.clamp(dt * 20, 0, 1)
    currentYaw = currentYaw + (targetYaw - currentYaw) * alpha
    currentPitch = currentPitch + (targetPitch - currentPitch) * alpha

    local pos = cam.CFrame.Position
    cam.CFrame = CFrame.new(pos)
        * CFrame.Angles(0, currentYaw, 0)
        * CFrame.Angles(currentPitch, 0, 0)
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
    syncFromCamera()
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

print("[CamSpeed] Loaded - joystick-safe smooth mode")
