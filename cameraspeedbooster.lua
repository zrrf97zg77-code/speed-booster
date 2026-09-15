local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- GUI
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

local title = Instance.new("TextLabel")
title.Text = "Camera Speed"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 4)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = panel

local valueLabel = Instance.new("TextLabel")
valueLabel.Text = "1.0x"
valueLabel.Size = UDim2.new(1, 0, 0, 24)
valueLabel.Position = UDim2.new(0, 0, 0, 34)
valueLabel.BackgroundTransparency = 1
valueLabel.TextColor3 = Color3.fromRGB(80, 180, 255)
valueLabel.TextScaled = true
valueLabel.Font = Enum.Font.GothamBold
valueLabel.Parent = panel

local track = Instance.new("Frame")
track.Size = UDim2.new(1, -40, 0, 10)
track.Position = UDim2.new(0, 20, 0, 78)
track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
track.BorderSizePixel = 0
track.Parent = panel
Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
fill.BorderSizePixel = 0
fill.Parent = track
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

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
-- CAMERA BOOST — "follow the game's camera" method
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

-- We track the game's camera direction each frame, and when it changes,
-- we apply ADDITIONAL rotation on top. This never touches movement because
-- we don't look at touch input at all — only at what the game's camera did.
local lastLook = nil
local wasDraggingCamera = false

RunService:BindToRenderStep("CamSpeedBoost", Enum.RenderPriority.Camera.Value + 1, function(dt)
    local cam = workspace.CurrentCamera
    if not cam then return end

    local look = cam.CFrame.LookVector

    if not lastLook then
        lastLook = look
        return
    end

    if currentMult <= 1.01 then
        lastLook = look
        return
    end

    -- Compute yaw/pitch the game applied this frame
    local lastYaw = math.atan2(-lastLook.X, -lastLook.Z)
    local lastPitch = math.asin(math.clamp(lastLook.Y, -1, 1))
    local nowYaw = math.atan2(-look.X, -look.Z)
    local nowPitch = math.asin(math.clamp(look.Y, -1, 1))

    local dYaw = nowYaw - lastYaw
    local dPitch = nowPitch - lastPitch

    -- Wrap yaw delta
    if dYaw > math.pi then dYaw = dYaw - 2 * math.pi end
    if dYaw < -math.pi then dYaw = dYaw + 2 * math.pi end

    local moved = math.abs(dYaw) + math.abs(dPitch)

    -- Only amplify if the game's camera actually moved this frame
    if moved > 0.0005 and moved < 0.5 then
        local extra = currentMult - 1.0
        local extraYaw = dYaw * extra
        local extraPitch = dPitch * extra

        local pos = cam.CFrame.Position
        local cf = CFrame.new(pos) * CFrame.Angles(0, nowYaw + extraYaw, 0) * CFrame.Angles(math.clamp(nowPitch + extraPitch, -math.rad(85), math.rad(85)), 0, 0)
        cam.CFrame = cf
        lastLook = cf.LookVector
    else
        lastLook = look
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

print("[CamSpeed] Loaded - follow-the-camera mode")
