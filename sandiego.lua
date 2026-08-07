-- Очищаем старые меню, если висели в игре
if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("SimpleSD_ESP") then
    game:GetService("Players").LocalPlayer.PlayerGui.SimpleSD_ESP:Destroy()
end

-- ============================================
-- ПЕРЕМЕННЫЕ И СЕРВИСЫ
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Ждем, пока персонаж появится, чтобы не получить nil ошибки
repeat task.wait() until LocalPlayer.Character

-- ============================================
-- СОЗДАНИЕ ЛЕГКОГО GUI (без CoreGui, безопасно)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleSD_ESP"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false -- Чтобы не пропадало при смерти

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 75)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -37.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "SAN DIEGO ESP MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.Parent = MainFrame

local EspToggleBtn = Instance.new("TextButton")
EspToggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
EspToggleBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
EspToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
EspToggleBtn.Text = "Включить ESP (Wallhack)"
EspToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspToggleBtn.Font = Enum.Font.Gotham
EspToggleBtn.TextSize = 12
EspToggleBtn.Parent = MainFrame

-- ============================================
-- ЛОГИКА ESP (Безопасная)
-- ============================================
local espActive = false
local espConnections = {}

local function ClearESP()
    -- Отключаем все коннекты
    for _, conn in pairs(espConnections) do
        conn:Disconnect()
    end
    espConnections = {}
    
    -- Удаляем все нарисованные коробки
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local box = p.Character.HumanoidRootPart:FindFirstChild("SD_BoxESP")
            if box then box:Destroy() end
        end
    end
end

local function CreateESPForPlayer(player)
    if player == LocalPlayer then return end -- Не рисовать на себе

    local function AddBox(char)
        if not espActive then return end
        
        local root = char:WaitForChild("HumanoidRootPart", 2)
        if not root then return end
        
        -- Проверка, чтобы не спамить коробками
        if root:FindFirstChild("SD_BoxESP") then return end
        
        -- Создаем коробку
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "SD_BoxESP"
        box.Size = Vector3.new(4, 6, 4)
        box.AlwaysOnTop = true -- Видно сквозь стены (Wallhack)
        box.ZIndex = 10
        box.Translucency = 0.4
        box.Adornee = root
        box.Parent = root
        box.Color3 = Color3.fromRGB(255, 50, 50) -- По умолчанию красный (враг)
        
        -- Логика цвета для San Diego RP (Синий для полиции)
        if player.Team then
            local teamName = player.Team.Name
            if teamName:find("Police") or teamName:find("Agent") or teamName:find("Patrol") or teamName:find("PD") then
                box.Color3 = Color3.fromRGB(0, 150, 255) -- Синий
            end
        end
    end
    
    if player.Character then
        AddBox(player.Character)
    end
    
    -- Следим за респавном игрока
    local conn = player.CharacterAdded:Connect(AddBox)
    table.insert(espConnections, conn)
end

-- Действие по нажатию на кнопку
EspToggleBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    
    if espActive then
        EspToggleBtn.Text = "ESP: ВКЛЮЧЕН"
        EspToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        
        -- Рисуем всех, кто уже на сервере
        for _, p in pairs(Players:GetPlayers()) do
            CreateESPForPlayer(p)
        end
        
        -- Следим за новыми игроками, которые заходят
        local conn = Players.PlayerAdded:Connect(CreateESPForPlayer)
        table.insert(espConnections, conn)
    else
        EspToggleBtn.Text = "Включить ESP (Wallhack)"
        EspToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        ClearESP()
    end
end)

-- ============================================
-- ОТКРЫТИЕ ПО ПРАВОМУ SHIFT
-- ============================================
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible -- Скрыть или показать меню
    end
end)

print("✅ Легкий ESP для San Diego загружен. Нажми Правый Shift, чтобы открыть меню.")
