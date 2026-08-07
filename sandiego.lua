-- Удаляем старые версии интерфейса, если они зависли
if game.CoreGui:FindFirstChild("SanDiegoFinalHUD") then
    game.CoreGui.SanDiegoFinalHUD:Destroy()
end

-- ============================================
-- ОСНОВА ИНТЕРФЕЙСА (HUD)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SanDiegoFinalHUD"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 190)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Title.Text = "  SAN DIEGO RP | PREMIUM HUD"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local BindText = Instance.new("TextLabel")
BindText.Size = UDim2.new(0.5, 0, 0, 40)
BindText.Position = UDim2.new(0.5, -10, 0, 0)
BindText.BackgroundTransparency = 1
BindText.Text = "[Right Shift для сворачивания]"
BindText.TextColor3 = Color3.fromRGB(150, 150, 150)
BindText.TextSize = 10
BindText.Font = Enum.Font.Gotham
BindText.TextXAlignment = Enum.TextXAlignment.Right
BindText.Parent = MainFrame

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

local EspButton = Instance.new("TextButton")
EspButton.Size = UDim2.new(0.9, 0, 0, 45)
EspButton.Position = UDim2.new(0.05, 0, 0.65, 0)
EspButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
EspButton.Text = "Включить ESP Boxes (ВХ)"
EspButton.TextColor3 = Color3.fromRGB(0, 170, 255)
EspButton.TextSize = 13
EspButton.Font = Enum.Font.GothamBold
EspButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = EspButton

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

local menuVisible = true
local espActive = false
local isFPressed = false
local espConnections = {} -- Чтобы сохранять подключения и отключать их при выключении

-- ============================================
-- 1. СВОРАЧИВАНИЕ (РАБОТАЕТ)
-- ============================================
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        MainFrame.Visible = menuVisible
    end
end)

-- ============================================
-- 2. УСКОРЕНИЕ НА F (ПЕРЕПИСАНО)
-- ============================================
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

-- Логика ускорения
runService.Heartbeat:Connect(function()
    if isFPressed then
        local char = localPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local seat = char.Humanoid.SeatPart
            if seat and seat:IsA("VehicleSeat") then
                local carBody = seat.Parent.PrimaryPart or seat
                
                -- Проверяем, едет ли машина вообще
                if seat.Throttle > 0 then
                    VehIndicator.Text = "Зажмите [ F ] в машине для ускорения\nСтатус: НАДДУВ АКТИВЕН"
                    VehIndicator.TextColor3 = Color3.fromRGB(0, 255, 100)
                    
                    -- Используем BodyVelocity вместо изменения CFrame вручную (безопаснее)
                    local bv = carBody:FindFirstChild("BoostVelocity")
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.Name = "BoostVelocity"
                        bv.MaxForce = Vector3.new(10000, 10000, 10000)
                        bv.Velocity = Vector3.new(0, 0, 0)
                        bv.Parent = carBody
                    end
                    
                    -- Применяем скорость по направлению машины
                    bv.Velocity = carBody.CFrame.LookVector * 70 
                end
            else
                VehIndicator.Text = "Зажмите [ F ] в машине для ускорения\nСтатус: СЯДЬТЕ ЗА РУЛЬ!"
                VehIndicator.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end
    else
        -- Убираем ускорение, когда F отпущена
        local char = localPlayer.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart then
            local seat = char.Humanoid.SeatPart
            if seat then
                local carBody = seat.Parent.PrimaryPart or seat
                local bv = carBody:FindFirstChild("BoostVelocity")
                if bv then bv:Destroy() end
            end
        end
    end
end)

-- ============================================
-- 3. ESP (ПЕРЕПИСАНО, РАБОТАЕТ БЕЗ СБОЕВ)
-- ============================================

local function clearESP()
    -- Очищаем все старые коннекты
    for _, conn in pairs(espConnections) do
        conn:Disconnect()
    end
    espConnections = {}
    
    -- Удаляем все коробки
    for _, p in pairs(players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local b = p.Character.HumanoidRootPart:FindFirstChild("EasyESPBox")
            if b then b:Destroy() end
        end
    end
end

local function applyBoxESP(player)
    if player == localPlayer then return end
    
    local function addBox(char)
        -- Ждем появления частей
        local root = char:WaitForChild("HumanoidRootPart", 3)
        if not root then return end
        
        -- Удаляем старую коробку, если есть
        local oldBox = root:FindFirstChild("EasyESPBox")
        if oldBox then oldBox:Destroy() end
        
        -- Проверяем, включен ли еще ESP
        if not espActive then return end

        task.wait(0.1) -- Маленькая задержка, чтобы игра успела прогрузить модель
        
        if root and not root:FindFirstChild("EasyESPBox") then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "EasyESPBox"
            box.Size = Vector3.new(4, 6, 4)
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Translucency = 0.5
            box.Adornee = root
            box.Parent = root
            box.Color3 = Color3.fromRGB(255, 50, 50) -- Красный по умолчанию
            
            -- Проверяем на полицию
            if player.Team then
                local teamName = player.Team.Name
                if teamName:match("Police") or teamName:match("Agent") or teamName:match("Patrol") then
                    box.Color3 = Color3.fromRGB(0, 100, 255) -- Синий для полиции
                end
            end
        end
    end
    
    -- Если персонаж уже есть, сразу рисуем
    if player.Character then
        addBox(player.Character)
    end
    
    -- Следим за появлением нового персонажа
    local conn = player.CharacterAdded:Connect(addBox)
    table.insert(espConnections, conn)
end

-- Включение/выключение по кнопке
EspButton.MouseButton1Click:Connect(function()
    espActive = not espActive
    
    if espActive then
        EspButton.Text = "ESP: АКТИВИРОВАН"
        EspButton.BackgroundColor3 = Color3.fromRGB(0, 120, 50)
        EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        -- Рисуем всех игроков, которые сейчас есть
        for _, p in pairs(players:GetPlayers()) do
            applyBoxESP(p)
        end
        
        -- Следим за новыми игроками
        local playerConn = players.PlayerAdded:Connect(applyBoxESP)
        table.insert(espConnections, playerConn)
        
    else
        EspButton.Text = "Включить ESP Boxes (ВХ)"
        EspButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        EspButton.TextColor3 = Color3.fromRGB(0, 170, 255)
        
        -- Очищаем всё
        clearESP()
    end
end)

-- ============================================
-- СТРАХОВКА ОТ ВЫЛЕТОВ
-- ============================================
-- Если игра загружается и игроков ещё нет, скрипт не упадет
task.wait(1)
print("✅ San Diego HUD загружен! Нажми F для разгона, Правый Shift для меню.")
