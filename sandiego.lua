-- Чистим старые меню
if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("SD_ESP_Menu") then
    game:GetService("Players").LocalPlayer.PlayerGui.SD_ESP_Menu:Destroy()
end

-- ============================================
-- СЕРВИСЫ И ПОДГОТОВКА
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Ждем загрузки персонажа (уберегает от вылетов при старте)
repeat task.wait() until LocalPlayer and LocalPlayer.Character

-- ============================================
-- СОЗДАНИЕ ЛЕГКОГО GUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SD_ESP_Menu"
ScreenGui.Parent = LocalPlayer.PlayerGui -- Не CoreGui, чтобы инжектор не крашнулся
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 75)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -37.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "SAN DIEGO ESP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
ToggleBtn.Text = "Включить ESP (Wallhack)"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.Gotham
ToggleBtn.TextSize = 12
ToggleBtn.Parent = MainFrame

-- ============================================
-- ЛОГИКА ESP ЧЕРЕЗ HIGHLIGHT (РАБОТАЕТ 100%)
-- ============================================
local espActive = false
local espConnections = {} -- Храним ивенты, чтобы отключать их при выключении

local function ClearESP()
    -- Отключаем все слежения за игроками
    for _, conn in pairs(espConnections) do
        conn:Disconnect()
    end
    espConnections = {}
    
    -- Убираем подсветку со всех игроков
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hl = player.Character:FindFirstChild("SD_Highlight")
            if hl then hl:Destroy() end
        end
    end
end

local function SetupPlayerESP(player)
    if player == LocalPlayer then return end
    
    local function AddHighlight(char)
        if not espActive then return end
        
        -- Если подсветка уже есть, удаляем старую перед созданием новой
        local old = char:FindFirstChild("SD_Highlight")
        if old then old:Destroy() end
        
        task.wait(0.2) -- Небольшая задержка, чтобы персонаж успел прогрузиться
        
        if espActive then
            local hl = Instance.new("Highlight")
            hl.Name = "SD_Highlight"
            hl.Adornee = char
            hl.FillColor = Color3.fromRGB(255, 50, 50) -- Красный (враг)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.Parent = char
            
            -- Если полиция - синий
            if player.Team then
                local teamName = player.Team.Name
                if teamName:find("Police") or teamName:find("Agent") or teamName:find("Patrol") or teamName:find("PD") then
                    hl.FillColor = Color3.fromRGB(0, 120, 255) -- Синий
                end
            end
        end
    end
    
    if player.Character then
        AddHighlight(player.Character)
    end
    
    -- Следим за респавнами
    local con = player.CharacterAdded:Connect(AddHighlight)
    table.insert(espConnections, con)
end

-- Нажатие на кнопку
ToggleBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    
    if espActive then
        ToggleBtn.Text = "ESP: ВКЛЮЧЕН"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 0)
        
        -- Включаем на всех, кто сейчас есть
        for _, p in pairs(Players:GetPlayers()) do
            SetupPlayerESP(p)
        end
        
        -- Подключаем новых заходящих игроков
        local conn = Players.PlayerAdded:Connect(SetupPlayerESP)
        table.insert(espConnections, conn)
    else
        ToggleBtn.Text = "Включить ESP (Wallhack)"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        
        ClearESP()
    end
end)

-- ============================================
-- ОТКРЫТИЕ ПО ПРАВОМУ SHIFT
-- ============================================
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("✅ ESP через Highlight успешно загружен! Нажми Правый Shift.")
