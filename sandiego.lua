-- ============================================
-- 📁 FOV Changer для Roblox
-- Версия: 1.0
-- Описание: Переключение FOV 70↔120 по клавише F
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

if not camera then
    warn("[FOV] Камера не найдена, скрипт остановлен")
    return
end

-- ===== НАСТРОЙКИ =====
local DEFAULT_FOV = 70
local TARGET_FOV = 120
local TOGGLE_KEY = Enum.KeyCode.F  -- Клавиша для переключения
local NOTIFICATION_DURATION = 1.5  -- Время показа уведомления (сек)
local SMOOTH_DURATION = 0.25       -- Время плавного изменения (сек)

local isEnabled = false
local isChanging = false

-- ===== ПЛАВНОЕ ИЗМЕНЕНИЕ FOV =====
local function SmoothChange(targetFov, duration)
    duration = duration or SMOOTH_DURATION
    local startFov = camera.FieldOfView
    local startTime = tick()
    isChanging = true
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local alpha = math.min(elapsed / duration, 1)
        -- Ease-out квадратичное замедление
        alpha = 1 - (1 - alpha) * (1 - alpha)
        
        camera.FieldOfView = startFov + (targetFov - startFov) * alpha
        
        if alpha >= 1 then
            camera.FieldOfView = targetFov
            isChanging = false
            connection:Disconnect()
        end
    end)
end

-- ===== УВЕДОМЛЕНИЕ НА ЭКРАНЕ =====
local function Notify(message, isGood)
    -- Удаляем старые уведомления
    local oldGui = player.PlayerGui:FindFirstChild("FOVNotif")
    if oldGui then oldGui:Destroy() end
    
    local notification = Instance.new("ScreenGui")
    notification.Name = "FOVNotif"
    notification.ResetOnSpawn = false
    notification.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 54)
    frame.Position = UDim2.new(0.5, -160, 0, 60)
    frame.BackgroundColor3 = isGood and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = notification
    
    -- Скругление углов
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    -- Тень (лёгкий эффект)
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Parent = frame
    
    task.wait(NOTIFICATION_DURATION)
    notification:Destroy()
end

-- ===== ОСНОВНАЯ ФУНКЦИЯ ПЕРЕКЛЮЧЕНИЯ =====
local function ToggleFOV()
    if isChanging then return end
    
    isEnabled = not isEnabled
    
    if isEnabled then
        SmoothChange(TARGET_FOV)
        Notify("🔭 FOV: 120 (ВКЛЮЧЁН)", true)
        print("[FOV] → 120 (Включён)")
    else
        SmoothChange(DEFAULT_FOV)
        Notify("🔭 FOV: 70 (ВЫКЛЮЧЁН)", false)
        print("[FOV] → 70 (Выключён)")
    end
end

-- ===== ОБРАБОТЧИК КЛАВИШ =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == TOGGLE_KEY then
        ToggleFOV()
    end
end)

-- ===== КОМАНДЫ В КОНСОЛИ (для отладки) =====
-- Введите в консоли (F9): _toggleFOV() - для ручного переключения
_G._toggleFOV = ToggleFOV
_G._setFOV = function(value)
    if type(value) == "number" and value >= 1 and value <= 120 then
        SmoothChange(value)
        Notify("🔭 FOV: " .. tostring(value), true)
        print("[FOV] Установлен: " .. tostring(value))
    else
        warn("[FOV] Значение должно быть от 1 до 120")
    end
end

print("========================================")
print("  🔭 FOV Changer загружен!")
print("  ➤ Клавиша: " .. tostring(TOGGLE_KEY):gsub("Enum.KeyCode.", ""))
print("  ➤ FOV: 70 ↔ 120")
print("  ➤ Команды в консоли (F9):")
print("     _toggleFOV()  - переключить")
print("     _setFOV(90)   - установить своё значение")
print("========================================")
