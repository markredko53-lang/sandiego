-- Удаляем старое меню, если оно было
if game.CoreGui:FindFirstChild("EasyXenoMenu") then
    game.CoreGui.EasyXenoMenu:Destroy()
end

-- 1. Создаем простое GUI
local ui = Instance.new("ScreenGui")
ui.Name = "EasyXenoMenu"
ui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Parent = ui
button.Size = UDim2.new(0, 250, 0, 50)
button.Position = UDim2.new(0.4, 0, 0.4, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
button.Text = "Включить безопасную скорость"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 15

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

-- Переменные для обхода
local speedBypassActive = false
local customSpeed = 50 -- Физическая скорость разгона

-- 2. Настройка кнопки
button.MouseButton1Click:Connect(function()
    speedBypassActive = not speedBypassActive
    
    if speedBypassActive then
        button.Text = "СКОРОСТЬ РАБОТАЕТ (БЕЗ УРОНА)"
        button.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    else
        button.Text = "Включить безопасную скорость"
        button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)

-- 3. САМ ОБХОД: Физическое микро-перемещение персонажа вместо WalkSpeed
game:GetService("RunService").Heartbeat:Connect(function()
    if speedBypassActive then
        local player = game.Players.LocalPlayer
        local char = player.Character
        -- Проверяем, что персонаж существует и он реально идет, а не стоит на месте
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.MoveDirection.Magnitude > 0 then
            -- Смещаем позицию вперед по направлению движения, имитируя скорость
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * (customSpeed / 120))
        end
    end
end)
