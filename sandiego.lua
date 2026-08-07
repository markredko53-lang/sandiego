if game.CoreGui:FindFirstChild("UltimateBypassMenu") then
    game.CoreGui.UltimateBypassMenu:Destroy()
end

-- 1. Создаем аккуратное меню
local ui = Instance.new("ScreenGui")
ui.Name = "UltimateBypassMenu"
ui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = ui
frame.Size = UDim2.new(0, 280, 0, 110)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local label = Instance.new("TextLabel")
label.Parent = frame
label.Size = UDim2.new(1, 0, 0, 35)
label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
label.Text = "  San Diego Anti-Cheat Bypass"
label.TextColor3 = Color3.fromRGB(255, 165, 0)
ui.Name = "UltimateBypassMenu"
label.TextSize = 14
label.Parent = frame

local labelCorner = Instance.new("UICorner")
labelCorner.CornerRadius = UDim.new(0, 8)
labelCorner.Parent = label

local button = Instance.new("TextButton")
button.Parent = frame
button.Size = UDim2.new(0.9, 0, 0, 45)
button.Position = UDim2.new(0.05, 0, 0.45, 0)
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.Text = "Клик-Телепорт (Зажмите CTRL + Клик мыши)"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 12

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 5)
btnCorner.Parent = button

-- Переменные для работы безопасного клика
local uis = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local bypassEnabled = false

button.MouseButton1Click:Connect(function()
    bypassEnabled = not bypassEnabled
    if bypassEnabled then
        button.Text = "КЛИК-ТЕЛЕПОРТ: АКТИВИРОВАН"
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    else
        button.Text = "Клик-Телепорт (Зажмите CTRL + Клик мыши)"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- 2. ЛОГИКА ОБХОДА: Мгновенный перенос с обманом рэйкаста сервера
mouse.Button1Down:Connect(function()
    if bypassEnabled and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
            local targetPos = mouse.Hit.Position
            
            -- Сбиваем детекцию анимации перед телепортом
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            task.wait(0.02)
            
            -- Переносим персонажа чуть выше точки клика (чтобы не застрять в текстурах пола)
            char.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            
            -- Мгновенно возвращаем в рабочее состояние, обнуляя счетчик движения для античета
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            char.HumanoidPlatformStand = false
        end
    end
end)
