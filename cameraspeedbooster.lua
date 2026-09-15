-- Higher Camera Speed / Sensitivity
-- Place this in StarterPlayerScripts as a LocalScript
-- For your own Roblox game only

local UserInputService = game:GetService("UserInputService")
local UserSettings = UserSettings()
local GameSettings = UserSettings.GameSettings

-- ============================================================
-- CONFIG — adjust these to taste
-- ============================================================
local TOUCH_SENSITIVITY_MULTIPLIER = 3.0   -- how much faster mobile swipes rotate the camera
local MOUSE_SENSITIVITY_MULTIPLIER = 3.0   -- how much faster mouse movement rotates the camera
local GAMEPAD_SENSITIVITY_MULTIPLIER = 3.0 -- how much faster controller stick rotates the camera

-- ============================================================
-- STORE ORIGINALS (so we don't stack multipliers if re-run)
-- ============================================================
local originalTouch = GameSettings.TouchCameraSensitivity
local originalMouse = GameSettings.MouseSensitivity
local originalGamepad = GameSettings.GamepadCameraSensitivity

-- ============================================================
-- APPLY NEW SENSITIVITY
-- ============================================================
GameSettings.TouchCameraSensitivity = originalTouch * TOUCH_SENSITIVITY_MULTIPLIER
GameSettings.MouseSensitivity = originalMouse * MOUSE_SENSITIVITY_MULTIPLIER
GameSettings.GamepadCameraSensitivity = originalGamepad * GAMEPAD_SENSITIVITY_MULTIPLIER

-- ============================================================
-- RE-APPLY ON RESPAWN (in case the game resets it)
-- ============================================================
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.2)
    GameSettings.TouchCameraSensitivity = originalTouch * TOUCH_SENSITIVITY_MULTIPLIER
    GameSettings.MouseSensitivity = originalMouse * MOUSE_SENSITIVITY_MULTIPLIER
    GameSettings.GamepadCameraSensitivity = originalGamepad * GAMEPAD_SENSITIVITY_MULTIPLIER
end)
