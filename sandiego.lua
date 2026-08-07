if game.CoreGui:FindFirstChild("SanDiegoUltimateMenu") then
    game.CoreGui.SanDiegoUltimateMenu:Destroy()
end

local ui = Instance.new("ScreenGui")
ui.Name = "SanDiegoUltimateMenu"
ui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = ui
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local label = Instance.new("TextLabel")
label.Parent = frame
label.Size = UDim2.new(1, 0, 0, 40)
label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
label.Text = "  San Diego Border RP | Безопасный Чит"
label.TextColor3 = Color3.fromRGB(255, 165, 0)
label.TextSize = 14

local labelCorner = Instance.new("UICorner")
labelCorner.CornerRadius = UDim.new(0, 8)
labelCorner.Parent = label

-- КНОПКА 1: БЕСКОНЕЧНЫЙ РАДИУС ДЕЙСТВИЯ (Взаимодействие через всю карту)
local BtnRange = Instance.new("TextButton")
BtnRange.Parent = frame
BtnRange.Size = UDim2.new(0.9, 0, 0, 40)
BtnRange.Position = UDim2.new(0.05, 0, 0.32, 0)
BtnRange.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
BtnRange.Text = "Включить клики через всю карту"
BtnRange.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnRange.TextSize = 13

local c1 = Instance.new("UICorner")
c1.CornerRadius = UDim.new(0, 5)
c1.Parent = BtnRange

local rangeActive = false
BtnRange.MouseButton1Click:Connect(function()
    rangeActive = not rangeActive
    if rangeActive then
        BtnRange.Text = "БЕСКОНЕЧНЫЙ РАДИУС: РАБОТАЕТ"
        BtnRange.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
        
        -- Увеличиваем радиус действия всех кнопок (Е-шек) в игре до максимума
        task.spawn(function()
            while rangeActive do
                for _, prompt in pairs(game.Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.MaxActivationDistance = 999999 -- Теперь кнопку видно из любой точки карты
                        prompt.RequiresLineOfSight = false    -- Можно нажимать сквозь стены
                    end
                end
                task.wait(2)
            end
        end)
    else
        BtnRange.Text = "Включить клики через всю карту"
        BtnRange.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
    end
end)

-- КНОПКА 2: ХОЖДЕНИЕ СКВОЗЬ СТЕНЫ (Noclip)
local BtnNoclip = Instance.new("TextButton")
BtnNoclip.Parent = frame
BtnNoclip.Size = UDim2.new(0.9, 0, 0, 40)
BtnNoclip.Position = UDim2.new(0.05, 0, 0.65, 0)
BtnNoclip.BackgroundColor3 = Color3.fromRGB(40, 70, 120)
BtnNoclip.Text = "Включить проход сквозь стены (Noclip)"
BtnNoclip.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnNoclip.TextSize = 13

local c2 = Instance.new("UICorner")
c2.CornerRadius = UDim.new(0, 5)
c2.Parent = BtnNoclip

local noclipActive = false
BtnNoclip.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    if noclipActive then
        BtnNoclip.Text = "NOCLIP: АКТИВИРОВАН"
        BtnNoclip.BackgroundColor3 = Color3.fromRGB(0, 90, 160)
    else
        BtnNoclip.Text = "Включить проход сквозь стены (Noclip)"
        BtnNoclip.BackgroundColor3 = Color3.fromRGB(40, 70, 120)
    end
end)

-- Цикл ноклипа (отключает коллизию тела с картой)
game:GetService("RunService").Stepped:Connect(function()
    if noclipActive then
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)
