-- Удаляем старый интерфейс, если он запущен
if game.CoreGui:FindFirstChild("SanDiegoPremiumHUD") then
    game.CoreGui.SanDiegoPremiumHUD:Destroy()
end

-- Создаем основу современного HUD
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SanDiegoPremiumHUD"
ScreenGui.Parent = game:GetService("CoreGui")

-- Главный фрейм (HUD)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 190)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0) -- Стильное расположение слева на экране
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Неоновая обводка HUD
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Заголовок меню
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Title.Text = "  SAN DIEGO RP | PREMIUM HUD"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- ИНДИКАТОР КЛАВИШИ F (Ускорение машины)
local VehIndicator = Instance.new("TextLabel")
VehIndicator.Size = UDim2.new(0.9, 0, 0, 45)
VehIndicator.Position = UDim2.new(0.05, 0, 0.28, 0)
VehIndicator.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
VehIndicator.Text = "Зажмите [ F ] в машине для ускорения\nСтатус: ОЖИДАНИЕ"
VehIndicator.TextColor3 = Color3.fromRGB(200, 200, 200)
VehIndicator.TextSize = 12
VehIndicator.Font = Enum.Font.Gotham
VehIndicator.Parent = MainFrame

local IndCorner = Instance.new("UICorner")
IndCorner.CornerRadius = UDim.new(0, 6)
IndCorner.Parent = VehIndicator

-- КНОПКА ВКЛЮЧЕНИЯ ESP (Валлхака)
local EspButton = Instance.new("TextButton")
EspButton.Size = UDim2.new(0.9, 0, 0, 45)
EspButton.Position = UDim2.new(0.05, 0, 0.65, 0)
EspButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
EspButton.Text = "Включить ESP Wallhack"
EspButton.TextColor3 = Color3.fromRGB(0, 170, 255)
EspButton.TextSize = 13
EspButton.Font = Enum.Font.GothamBold
EspButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = EspButton

-- Переменные управления
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

local espActive = false
local isFPressed = false
local carSpeedValue = 0.55 -- Самое сбалансированное значение микро-толчка, чтобы не убивало!

-- 1. СЛЕЖЕНИЕ ЗА НАЖАТИЕМ КЛАВИШИ F
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        isFPressed = true
    end
end)

uis.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        isFPressed = false
        VehIndicator.Text = "Зажмите [ F ] в машине для ускорения\nСтатус: ОЖИДАНИЕ"
        VehIndicator.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- 2. ЛОГИКА БЕЗОПАСНОГО РАЗГОНА МАШИНЫ НА "F"
runService.Heartbeat:Connect(function()
    if isFPressed then
        local char = localPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local seat = char.Humanoid.SeatPart
            -- Проверяем, сидим ли за рулем
            if seat and seat:IsA("VehicleSeat") then
                local carBody = seat.Parent.PrimaryPart or seat
                if seat.Throttle > 0 then
                    VehIndicator.Text = "Зажмите [ F ] в машине для ускорения\nСтатус: НАДДУВ АКТИВЕН"
                    VehIndicator.TextColor3 = Color3.fromRGB(0, 255, 100)
                    -- Микро-смещение вперед по вектору направления машины
                    carBody.CFrame = carBody.CFrame + (carBody.CFrame.LookVector * carSpeedValue)
                end
            else
                VehIndicator.Text = "Зажмите [ F ] в машине для ускорения\nСтатус: СЯДЬТЕ ЗА РУЛЬ!"
                VehIndicator.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end
    end
end)

-- 3. ЛОГИКА ESP WALLHACK
local function applyESP(player)
    if player == localPlayer then return end
    local function addHighlight(char)
        if not char:FindFirstChild("ESPHighlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.Parent = char
            highlight.FillColor = Color3.fromRGB(255, 50, 50)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            
            if player.Team and (player.Team.Name:match("Police") or player.Team.Name:match("Agent")) then
                highlight.FillColor = Color3.fromRGB(0, 100, 255) -- Копы синие
            end
        end
    end
    if player.Character then addHighlight(player.Character) end
    player.CharacterAdded:Connect(addHighlight)
end

EspButton.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        EspButton.Text = "ESP: АКТИВИРОВАН"
        EspButton.BackgroundColor3 = Color3.fromRGB(0, 120, 50)
        EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        for _, p in pairs(players:GetPlayers()) do applyESP(p) end
        players.PlayerAdded:Connect(applyESP)
    else
        EspButton.Text = "Включить ESP Wallhack"
        EspButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        EspButton.TextColor3 = Color3.fromRGB(0, 170, 255)
        for _, p in pairs(players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ESPHighlight") then
                p.Character.ESPHighlight:Destroy()
            end
        end
    end
end)
