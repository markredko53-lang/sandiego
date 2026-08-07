-- Удаляем старую версию, если есть
if game.CoreGui:FindFirstChild("SimpleESP_HUD") then
    game.CoreGui.SimpleESP_HUD:Destroy()
end

-- ============================================
-- СОЗДАНИЕ GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleESP_HUD"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 100)
MainFrame.Position = UDim2.new(0.02, 0, 0.4, 0)
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
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Title.Text = "  ESP MENU"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local BindText = Instance.new("TextLabel")
BindText.Size = UDim2.new(0.5, 0, 0, 30)
BindText.Position = UDim2.new(0.5, -10, 0, 0)
BindText.BackgroundTransparency = 1
BindText.Text = "[Right Shift]"
BindText.TextColor3 = Color3.fromRGB(150, 150, 150)
BindText.TextSize = 10
BindText.Font = Enum.Font.Gotham
BindText.TextXAlignment = Enum.TextXAlignment.Right
BindText.Parent = MainFrame

local EspButton = Instance.new("TextButton")
EspButton.Size = UDim2.new(0.9, 0, 0, 40)
EspButton.Position = UDim2.new(0.05, 0, 0.4, 0)
EspButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
EspButton.Text = "Включить ESP"
EspButton.TextColor3 = Color3.fromRGB(0, 170, 255)
EspButton.TextSize = 13
EspButton.Font = Enum.Font.GothamBold
EspButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = EspButton

-- ============================================
-- ЛОГИКА
-- ============================================
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

local menuVisible = true
local espActive = false
local espConnections = {}

-- 1. СВОРАЧИВАНИЕ ПО ПРАВОМУ ШИФТУ
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        MainFrame.Visible = menuVisible
    end
end)

-- ============================================
-- ЛОГИКА ESP (Включение/Выключение)
-- ============================================

local function clearESP()
    -- Отключаем все прослушки
    for _, conn in pairs(espConnections) do
        conn:Disconnect()
    end
    espConnections = {}
    
    -- Удаляем все боксы
    for _, p in pairs(players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local b = p.Character.HumanoidRootPart:FindFirstChild("SimpleESPBox")
            if b then b:Destroy() end
        end
    end
end

local function applyBoxESP(player)
    if player == localPlayer then return end
    
    local function addBox(char)
        if not espActive then return end
        
        local root = char:WaitForChild("HumanoidRootPart", 3)
        if not root then return end
        
        -- Не создаем, если уже есть
        if root:FindFirstChild("SimpleESPBox") then return end

        -- Создаем бокс
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "SimpleESPBox"
        box.Size = Vector3.new(4, 6, 4)
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Translucency = 0.5
        box.Adornee = root
        box.Parent = root
        box.Color3 = Color3.fromRGB(255, 50, 50) -- Красный по умолчанию
        
        -- Если полиция - синий
        if player.Team then
            local teamName = player.Team.Name
            if teamName:match("Police") or teamName:match("Agent") or teamName:match("Patrol") then
                box.Color3 = Color3.fromRGB(0, 100, 255)
            end
        end
    end
    
    if player.Character then
        addBox(player.Character)
    end
    
    local conn = player.CharacterAdded:Connect(addBox)
    table.insert(espConnections, conn)
end

-- Кнопка вкл/выкл
EspButton.MouseButton1Click:Connect(function()
    espActive = not espActive
    
    if espActive then
        EspButton.Text = "ESP: ВКЛЮЧЕН"
        EspButton.BackgroundColor3 = Color3.fromRGB(0, 120, 50)
        EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        -- Включаем для всех текущих игроков
        for _, p in pairs(players:GetPlayers()) do
            applyBoxESP(p)
        end
        
        -- Следим за новыми
        local playerConn = players.PlayerAdded:Connect(applyBoxESP)
        table.insert(espConnections, playerConn)
        
    else
        EspButton.Text = "Включить ESP"
        EspButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        EspButton.TextColor3 = Color3.fromRGB(0, 170, 255)
        
        clearESP()
    end
end)

print("✅ Готово. Используй Правый Shift для меню.")
