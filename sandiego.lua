-- Защита от дублирования GUI
if game.CoreGui:FindFirstChild("SanDiegoPremiumMenu") then
    game.CoreGui.SanDiegoPremiumMenu:Destroy()
end

-- Создаем основу интерфейса (Полностью автономно, без внешних сайтов!)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SanDiegoPremiumMenu"
ScreenGui.Parent = game:GetService("CoreGui")

-- Главная панель
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 220)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Меню можно двигать мышкой!
MainFrame.Parent = ScreenGui

-- Скругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Заголовок меню
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "  San Diego Border RP | Premium Xeno"
Title.TextColor3 = Color3.fromRGB(255, 215, 0) -- Золотой цвет текста
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- КНОПКА 1: БЕЗОПАСНЫЙ РАЗГОН (Спидхак)
local SpeedButton = Instance.new("TextButton")
SpeedButton.Size = UDim2.new(0.9, 0, 0, 40)
SpeedButton.Position = UDim2.new(0.05, 0, 0.25, 0)
SpeedButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
SpeedButton.Text = "Включить безопасный разгон (Скорость 45)"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.TextSize = 14
SpeedButton.Parent = MainFrame

local Corner1 = Instance.new("UICorner")
Corner1.CornerRadius = UDim.new(0, 5)
Corner1.Parent = SpeedButton

SpeedButton.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 45 -- Безопасный предел для San Diego
        SpeedButton.Text = "РАЗГОН АКТИВИРОВАН!"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(20, 80, 20)
    end
end)

-- КНОПКА 2: ПОЛУЧИТЬ КООРДИНАТЫ (Вывод в консоль)
local CoordButton = Instance.new("TextButton")
CoordButton.Size = UDim2.new(0.9, 0, 0, 40)
CoordButton.Position = UDim2.new(0.05, 0, 0.48, 0)
CoordButton.BackgroundColor3 = Color3.fromRGB(40, 70, 120)
CoordButton.Text = "Начать сбор координат в консоль (F9)"
CoordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CoordButton.TextSize = 14
CoordButton.Parent = MainFrame

local Corner2 = Instance.new("UICorner")
Corner2.CornerRadius = UDim.new(0, 5)
Corner2.Parent = CoordButton

local tracking = false
CoordButton.MouseButton1Click:Connect(function()
    if tracking then return end
    tracking = true
    CoordButton.Text = "СБОР НАЧАТ (Смотри логи F9)"
    CoordButton.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
    
    task.spawn(function()
        while tracking do
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                print("--- ВАШИ КООРДИНАТЫ ---")
                print("CFrame: CFrame.new(" .. tostring(char.HumanoidRootPart.Position) .. ")")
            end
            task.wait(3)
        end
    end)
end)

-- КНОПКА 3: ЗАКРЫТЬ МЕНЮ
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.9, 0, 0, 35)
CloseButton.Position = UDim2.new(0.05, 0, 0.72, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
CloseButton.Text = "Закрыть чит-меню"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Parent = MainFrame

local Corner3 = Instance.new("UICorner")
Corner3.CornerRadius = UDim.new(0, 5)
Corner3.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
