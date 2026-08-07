if game.CoreGui:FindFirstChild("EasyXenoMenu") then
    game.CoreGui.EasyXenoMenu:Destroy()
end

local ui = Instance.new("ScreenGui")
ui.Name = "EasyXenoMenu"
ui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Parent = ui
button.Size = UDim2.new(0, 260, 0, 50)
button.Position = UDim2.new(0.4, 0, 0.35, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
button.Text = "Байпас скорости: ВЫКЛ"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 14

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

-- Информационный текст для настройки скорости
local infoText = Instance.new("TextLabel")
infoText.Parent = ui
infoText.Size = UDim2.new(0, 260, 0, 30)
infoText.Position = UDim2.new(0.4, 0, 0.45, 0)
infoText.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
infoText.Text = "Текущий множитель: 0.15 (Безопасно)"
infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
infoText.TextSize = 12

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 5)
infoCorner.Parent = infoText

-- Кнопки быстрой регулировки скорости (чтобы найти идеальный баланс)
local PlusButton = Instance.new("TextButton")
PlusButton.Parent = ui
PlusButton.Size = UDim2.new(0, 125, 0, 30)
PlusButton.Position = UDim2.new(0.4, 0, 0.51, 0)
PlusButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlusButton.Text = "Скорость +"
PlusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusButton.Parent = ui

local MinusButton = Instance.new("TextButton")
MinusButton.Parent = ui
MinusButton.Size = UDim2.new(0, 125, 0, 30)
MinusButton.Position = UDim2.new(0.4, 135, 0.51, 0)
MinusButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinusButton.Text = "Скорость -"
MinusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusButton.Parent = ui

-- Переменные настройки
local speedBypassActive = false
local speedMultiplier = 0.15 -- Шаг микро-телепортации. Чем меньше, тем безопаснее!

button.MouseButton1Click:Connect(function()
    speedBypassActive = not speedBypassActive
    if speedBypassActive then
        button.Text = "Байпас скорости: РАБОТАЕТ"
        button.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    else
        button.Text = "Байпас скорости: ВЫКЛ"
        button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)

PlusButton.MouseButton1Click:Connect(function()
    speedMultiplier = speedMultiplier + 0.05
    infoText.Text = "Текущий множитель: " .. string.format("%.2f", speedMultiplier)
end)

MinusButton.MouseButton1Click:Connect(function()
    if speedMultiplier > 0.05 then
        speedMultiplier = speedMultiplier - 0.05
        infoText.Text = "Текущий множитель: " .. string.format("%.2f", speedMultiplier)
    end
end)

-- ОПТИМИЗИРОВАННЫЙ ЦИКЛ С ПАУЗАМИ ДЛЯ ОБХОДА ПРОВЕРКИ ДИСТАНЦИИ
game:GetService("RunService").Heartbeat:Connect(function()
    if speedBypassActive then
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.MoveDirection.Magnitude > 0 then
            -- Смещаем персонажа по направлению ходьбы с учетом нашего множителя
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * speedMultiplier)
        end
    end
end)
