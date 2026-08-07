-- ============================================
-- XENO SUIT SYSTEM v3.0
-- Полный экзоскелет для San Diego Border RP
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ============================================
-- КОНФИГУРАЦИЯ
-- ============================================

local CONFIG = {
    -- Уровни экзоскелета
    Levels = {
        [1] = {
            Name = "Light Xeno",
            Color = Color3.fromRGB(100, 200, 255),
            Health = 150,
            Speed = 20,
            JumpPower = 80,
            Shield = 50,
            Damage = 10,
            Price = 0
        },
        [2] = {
            Name = "Medium Xeno",
            Color = Color3.fromRGB(0, 150, 255),
            Health = 200,
            Speed = 22,
            JumpPower = 90,
            Shield = 100,
            Damage = 15,
            Price = 1000
        },
        [3] = {
            Name = "Heavy Xeno",
            Color = Color3.fromRGB(255, 100, 0),
            Health = 300,
            Speed = 18,
            JumpPower = 70,
            Shield = 200,
            Damage = 20,
            Price = 2500
        },
        [4] = {
            Name = "Elite Xeno",
            Color = Color3.fromRGB(255, 0, 255),
            Health = 400,
            Speed = 25,
            JumpPower = 100,
            Shield = 300,
            Damage = 25,
            Price = 5000
        },
        [5] = {
            Name = "Legendary Xeno",
            Color = Color3.fromRGB(255, 215, 0),
            Health = 500,
            Speed = 30,
            JumpPower = 120,
            Shield = 500,
            Damage = 35,
            Price = 10000
        }
    },
    
    -- Способности
    Abilities = {
        ShieldBoost = {
            Name = "🛡️ Shield Boost",
            Cooldown = 30,
            Duration = 10,
            Multiplier = 2,
            Key = Enum.KeyCode.One
        },
        SpeedBoost = {
            Name = "⚡ Speed Boost",
            Cooldown = 20,
            Duration = 8,
            Multiplier = 1.5,
            Key = Enum.KeyCode.Two
        },
        JumpBoost = {
            Name = "🚀 Jump Boost",
            Cooldown = 15,
            Duration = 5,
            Multiplier = 2,
            Key = Enum.KeyCode.Three
        },
        Heal = {
            Name = "❤️ Self Heal",
            Cooldown = 45,
            HealAmount = 50,
            Key = Enum.KeyCode.Four
        }
    }
}

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================

local XenoData = {
    Level = 1,
    Equipped = false,
    Shield = 0,
    MaxShield = 0,
    Abilities = {
        ShieldBoost = { Cooldown = 0, Active = false, Timer = 0 },
        SpeedBoost = { Cooldown = 0, Active = false, Timer = 0 },
        JumpBoost = { Cooldown = 0, Active = false, Timer = 0 },
        Heal = { Cooldown = 0 }
    }
}

local XenoParts = {}
local Connections = {}
local UI = {}

-- ============================================
-- СОЗДАНИЕ UI
-- ============================================

local function CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "XenoUI"
    screenGui.Parent = Player.PlayerGui
    screenGui.ResetOnSpawn = false
    
    -- ===== ГЛАВНАЯ ПАНЕЛЬ =====
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 300, 0, 450)
    mainPanel.Position = UDim2.new(0.5, -150, 0.5, -225)
    mainPanel.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
    mainPanel.BackgroundTransparency = 0.1
    mainPanel.BorderSizePixel = 3
    mainPanel.BorderColor3 = Color3.new(0, 0.5, 1)
    mainPanel.Visible = false
    mainPanel.Parent = screenGui
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "⚡ XENO SYSTEM"
    title.TextColor3 = Color3.new(0, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainPanel
    
    -- Информация об уровне
    local levelInfo = Instance.new("Frame")
    levelInfo.Size = UDim2.new(0.9, 0, 0, 80)
    levelInfo.Position = UDim2.new(0.05, 0, 0, 70)
    levelInfo.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    levelInfo.BorderSizePixel = 1
    levelInfo.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
    levelInfo.Parent = mainPanel
    
    local levelName = Instance.new("TextLabel")
    levelName.Name = "LevelName"
    levelName.Size = UDim2.new(1, 0, 0.5, 0)
    levelName.Position = UDim2.new(0, 0, 0, 5)
    levelName.BackgroundTransparency = 1
    levelName.Text = "Light Xeno"
    levelName.TextColor3 = Color3.new(1, 1, 1)
    levelName.TextScaled = true
    levelName.Font = Enum.Font.GothamBold
    levelName.Parent = levelInfo
    
    local levelStats = Instance.new("TextLabel")
    levelStats.Name = "LevelStats"
    levelStats.Size = UDim2.new(1, 0, 0.5, 0)
    levelStats.Position = UDim2.new(0, 0, 0.5, 0)
    levelStats.BackgroundTransparency = 1
    levelStats.Text = "❤️ 100 | ⚡ 20 | 🛡️ 50"
    levelStats.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    levelStats.TextScaled = true
    levelStats.Font = Enum.Font.Gotham
    levelStats.Parent = levelInfo
    
    -- Кнопки управления
    local equipBtn = Instance.new("TextButton")
    equipBtn.Name = "EquipBtn"
    equipBtn.Size = UDim2.new(0.9, 0, 0, 40)
    equipBtn.Position = UDim2.new(0.05, 0, 0, 165)
    equipBtn.BackgroundColor3 = Color3.new(0, 0.5, 1)
    equipBtn.Text = "🔧 Надеть Xeno"
    equipBtn.TextColor3 = Color3.new(1, 1, 1)
    equipBtn.Font = Enum.Font.GothamBold
    equipBtn.TextScaled = true
    equipBtn.Parent = mainPanel
    
    local unequipBtn = Instance.new("TextButton")
    unequipBtn.Name = "UnequipBtn"
    unequipBtn.Size = UDim2.new(0.9, 0, 0, 40)
    unequipBtn.Position = UDim2.new(0.05, 0, 0, 210)
    unequipBtn.BackgroundColor3 = Color3.new(1, 0.2, 0.2)
    unequipBtn.Text = "❌ Снять Xeno"
    unequipBtn.TextColor3 = Color3.new(1, 1, 1)
    unequipBtn.Font = Enum.Font.GothamBold
    unequipBtn.TextScaled = true
    unequipBtn.Parent = mainPanel
    
    -- Кнопки уровней
    local upgradeBtn = Instance.new("TextButton")
    upgradeBtn.Name = "UpgradeBtn"
    upgradeBtn.Size = UDim2.new(0.9, 0, 0, 40)
    upgradeBtn.Position = UDim2.new(0.05, 0, 0, 255)
    upgradeBtn.BackgroundColor3 = Color3.new(0.8, 0.6, 0)
    upgradeBtn.Text = "⬆️ Улучшить ($1000)"
    upgradeBtn.TextColor3 = Color3.new(1, 1, 1)
    upgradeBtn.Font = Enum.Font.GothamBold
    upgradeBtn.TextScaled = true
    upgradeBtn.Parent = mainPanel
    
    -- Статистика
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(0.9, 0, 0, 80)
    statsFrame.Position = UDim2.new(0.05, 0, 0, 305)
    statsFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    statsFrame.BorderSizePixel = 1
    statsFrame.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
    statsFrame.Parent = mainPanel
    
    local shieldStat = Instance.new("TextLabel")
    shieldStat.Name = "ShieldStat"
    shieldStat.Size = UDim2.new(1, 0, 0.5, 0)
    shieldStat.Position = UDim2.new(0, 0, 0, 5)
    shieldStat.BackgroundTransparency = 1
    shieldStat.Text = "🛡️ Щит: 50/50"
    shieldStat.TextColor3 = Color3.new(0.5, 0.8, 1)
    shieldStat.TextScaled = true
    shieldStat.Font = Enum.Font.Gotham
    shieldStat.Parent = statsFrame
    
    local statusStat = Instance.new("TextLabel")
    statusStat.Name = "StatusStat"
    statusStat.Size = UDim2.new(1, 0, 0.5, 0)
    statusStat.Position = UDim2.new(0, 0, 0.5, 0)
    statusStat.BackgroundTransparency = 1
    statusStat.Text = "❌ Не надет"
    statusStat.TextColor3 = Color3.new(1, 0.3, 0.3)
    statusStat.TextScaled = true
    statusStat.Font = Enum.Font.Gotham
    statusStat.Parent = statsFrame
    
    -- ===== ПАНЕЛЬ СПОСОБНОСТЕЙ =====
    local abilityPanel = Instance.new("Frame")
    abilityPanel.Name = "AbilityPanel"
    abilityPanel.Size = UDim2.new(0, 250, 0, 200)
    abilityPanel.Position = UDim2.new(0, 10, 0.5, -100)
    abilityPanel.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
    abilityPanel.BackgroundTransparency = 0.2
    abilityPanel.BorderSizePixel = 2
    abilityPanel.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
    abilityPanel.Visible = false
    abilityPanel.Parent = screenGui
    
    local abTitle = Instance.new("TextLabel")
    abTitle.Size = UDim2.new(1, 0, 0, 30)
    abTitle.Position = UDim2.new(0, 0, 0, 5)
    abTitle.BackgroundTransparency = 1
    abTitle.Text = "⚡ СПОСОБНОСТИ"
    abTitle.TextColor3 = Color3.new(1, 1, 1)
    abTitle.TextScaled = true
    abTitle.Font = Enum.Font.GothamBold
    abTitle.Parent = abilityPanel
    
    local abilityButtons = {}
    local yPos = 40
    for name, ability in pairs(CONFIG.Abilities) do
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Btn"
        btn.Size = UDim2.new(0.9, 0, 0, 30)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
        btn.Text = ability.Name .. " [Готов]"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextScaled = true
        btn.Parent = abilityPanel
        
        abilityButtons[name] = btn
        yPos = yPos + 35
    end
    
    -- ===== ИНДИКАТОР ЩИТА (в игре) =====
    local shieldIndicator = Instance.new("Frame")
    shieldIndicator.Name = "ShieldIndicator"
    shieldIndicator.Size = UDim2.new(0, 250, 0, 40)
    shieldIndicator.Position = UDim2.new(0.5, -125, 0.9, 0)
    shieldIndicator.BackgroundColor3 = Color3.new(0, 0, 0)
    shieldIndicator.BackgroundTransparency = 0.5
    shieldIndicator.BorderSizePixel = 2
    shieldIndicator.BorderColor3 = Color3.new(0, 0.5, 1)
    shieldIndicator.Visible = false
    shieldIndicator.Parent = screenGui
    
    local shieldLabel = Instance.new("TextLabel")
    shieldLabel.Size = UDim2.new(0.3, 0, 1, 0)
    shieldLabel.Position = UDim2.new(0, 5, 0, 0)
    shieldLabel.BackgroundTransparency = 1
    shieldLabel.Text = "🛡️"
    shieldLabel.TextColor3 = Color3.new(1, 1, 1)
    shieldLabel.TextScaled = true
    shieldLabel.Font = Enum.Font.Gotham
    shieldLabel.Parent = shieldIndicator
    
    local shieldBar = Instance.new("Frame")
    shieldBar.Name = "ShieldBar"
    shieldBar.Size = UDim2.new(0.65, 0, 0.7, 0)
    shieldBar.Position = UDim2.new(0.33, 0, 0.15, 0)
    shieldBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    shieldBar.BorderSizePixel = 1
    shieldBar.Parent = shieldIndicator
    
    local shieldFill = Instance.new("Frame")
    shieldFill.Name = "ShieldFill"
    shieldFill.Size = UDim2.new(1, 0, 1, 0)
    shieldFill.BackgroundColor3 = Color3.new(0, 0.5, 1)
    shieldFill.BorderSizePixel = 0
    shieldFill.Parent = shieldBar
    
    local shieldText = Instance.new("TextLabel")
    shieldText.Name = "ShieldText"
    shieldText.Size = UDim2.new(1, 0, 1, 0)
    shieldText.BackgroundTransparency = 1
    shieldText.Text = "100/100"
    shieldText.TextColor3 = Color3.new(1, 1, 1)
    shieldText.TextScaled = true
    shieldText.Font = Enum.Font.Gotham
    shieldText.Parent = shieldBar
    
    -- Сохраняем UI
    UI = {
        ScreenGui = screenGui,
        MainPanel = mainPanel,
        AbilityPanel = abilityPanel,
        ShieldIndicator = shieldIndicator,
        LevelName = levelName,
        LevelStats = levelStats,
        ShieldStat = shieldStat,
        StatusStat = statusStat,
        ShieldFill = shieldFill,
        ShieldText = shieldText,
        EquipBtn = equipBtn,
        UnequipBtn = unequipBtn,
        UpgradeBtn = upgradeBtn,
        AbilityButtons = abilityButtons
    }
    
    -- Настройка кнопок
    setupButtons()
end

-- ============================================
-- НАСТРОЙКА КНОПОК
-- ============================================

local function setupButtons()
    -- Показать/скрыть меню
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.X then
            UI.MainPanel.Visible = not UI.MainPanel.Visible
            UI.AbilityPanel.Visible = UI.MainPanel.Visible
            updateUI()
        end
    end)
    
    -- Надеть Xeno
    UI.EquipBtn.MouseButton1Click:Connect(function()
        equipXeno()
    end)
    
    -- Снять Xeno
    UI.UnequipBtn.MouseButton1Click:Connect(function()
        unequipXeno()
    end)
    
    -- Улучшить
    UI.UpgradeBtn.MouseButton1Click:Connect(function()
        upgradeXeno()
    end)
    
    -- Способности
    for name, btn in pairs(UI.AbilityButtons) do
        btn.MouseButton1Click:Connect(function()
            useAbility(name)
        end)
    end
    
    -- Горячие клавиши для способностей
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if not XenoData.Equipped then return end
        
        for name, ability in pairs(CONFIG.Abilities) do
            if input.KeyCode == ability.Key then
                useAbility(name)
            end
        end
    end)
end

-- ============================================
-- ОСНОВНЫЕ ФУНКЦИИ
-- ============================================

-- Обновить UI
local function updateUI()
    local config = CONFIG.Levels[XenoData.Level]
    if not config then return end
    
    UI.LevelName.Text = config.Name
    UI.LevelName.TextColor3 = config.Color
    UI.LevelStats.Text = string.format("❤️ %d | ⚡ %d | 🛡️ %d", 
        config.Health, config.Speed, config.Shield)
    
    UI.ShieldStat.Text = string.format("🛡️ Щит: %d/%d", 
        XenoData.Shield, XenoData.MaxShield)
    
    UI.StatusStat.Text = XenoData.Equipped and "✅ Надет" or "❌ Не надет"
    UI.StatusStat.TextColor3 = XenoData.Equipped and Color3.new(0, 1, 0) or Color3.new(1, 0.3, 0.3)
    
    -- Обновить кнопку улучшения
    local nextLevel = XenoData.Level + 1
    if nextLevel <= 5 then
        local price = CONFIG.Levels[nextLevel].Price
        UI.UpgradeBtn.Text = string.format("⬆️ Улучшить до %s ($%d)", 
            CONFIG.Levels[nextLevel].Name, price)
        UI.UpgradeBtn.Visible = true
    else
        UI.UpgradeBtn.Text = "⭐ MAX LEVEL"
        UI.UpgradeBtn.Visible = true
    end
    
    -- Обновить индикатор щита
    if XenoData.Equipped then
        UI.ShieldIndicator.Visible = true
        local percent = XenoData.Shield / XenoData.MaxShield
        UI.ShieldFill.Size = UDim2.new(percent, 0, 1, 0)
        UI.ShieldText.Text = string.format("%d/%d", 
            math.floor(XenoData.Shield), XenoData.MaxShield)
    else
        UI.ShieldIndicator.Visible = false
    end
    
    -- Обновить кнопки способностей
    for name, btn in pairs(UI.AbilityButtons) do
        local ability = XenoData.Abilities[name]
        local config = CONFIG.Abilities[name]
        if ability.Cooldown > 0 then
            btn.Text = string.format("%s [⏳ %ds]", config.Name, math.ceil(ability.Cooldown))
            btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        else
            btn.Text = string.format("%s [✅ Готов]", config.Name)
            btn.BackgroundColor3 = Color3.new(0, 0.5, 0)
        end
    end
end

-- Надеть Xeno
local function equipXeno()
    if XenoData.Equipped then
        notify("⚠️ Xeno уже надет!", Color3.new(1, 1, 0))
        return
    end
    
    local config = CONFIG.Levels[XenoData.Level]
    local character = Player.Character
    if not character then
        notify("❌ Персонаж не найден!", Color3.new(1, 0, 0))
        return
    end
    
    -- Создаем Xeno части
    createXenoParts(character, config)
    
    XenoData.Equipped = true
    XenoData.Shield = config.Shield
    XenoData.MaxShield = config.Shield
    
    -- Применяем статы
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.MaxHealth = config.Health
        humanoid.Health = config.Health
        humanoid.WalkSpeed = config.Speed
        humanoid.JumpPower = config.JumpPower
    end
    
    notify("✅ Xeno надет!", Color3.new(0, 1, 0))
    updateUI()
end

-- Создать Xeno части
local function createXenoParts(character, config)
    -- Удаляем старые части
    for _, part in pairs(character:GetChildren()) do
        if part.Name == "XenoPart" then
            part:Destroy()
        end
    end
    
    -- Создаем основную часть
    local xenoPart = Instance.new("Part")
    xenoPart.Name = "XenoPart"
    xenoPart.Size = Vector3.new(3, 1, 3)
    xenoPart.Shape = Enum.PartType.Ball
    xenoPart.Material = Enum.Material.Neon
    xenoPart.Color = config.Color
    xenoPart.Transparency = 0.4
    xenoPart.Anchored = false
    xenoPart.CanCollide = false
    
    -- Weld к персонажу
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then
        local weld = Instance.new("Weld")
        weld.Part0 = root
        weld.Part1 = xenoPart
        weld.C0 = CFrame.new(0, 1.5, 0) * CFrame.Angles(0, 0, 0)
        weld.Parent = xenoPart
    end
    
    xenoPart.Parent = character
    
    -- Свет
    local light = Instance.new("PointLight")
    light.Range = 15
    light.Brightness = 3
    light.Color = config.Color
    light.Parent = xenoPart
    
    -- Анимация парящей части
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not xenoPart.Parent then
            connection:Disconnect()
            return
        end
        local float = math.sin(tick() * 2) * 0.2
        xenoPart.Position = root.Position + Vector3.new(0, 1.5 + float, 0)
        xenoPart.Orientation = Vector3.new(0, tick() * 50 % 360, 0)
    end)
    
    table.insert(XenoParts, xenoPart)
    Connections[#Connections + 1] = connection
end

-- Снять Xeno
local function unequipXeno()
    if not XenoData.Equipped then
        notify("⚠️ Xeno не надет!", Color3.new(1, 1, 0))
        return
    end
    
    local character = Player.Character
    if character then
        -- Удаляем части
        for _, part in pairs(character:GetChildren()) do
            if part.Name == "XenoPart" then
                part:Destroy()
            end
        end
        
        -- Восстанавливаем статы
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
    
    XenoData.Equipped = false
    XenoData.Shield = 0
    
    -- Очищаем соединения
    for _, conn in pairs(Connections) do
        conn:Disconnect()
    end
    Connections = {}
    XenoParts = {}
    
    notify("❌ Xeno снят!", Color3.new(1, 0, 0))
    updateUI()
end

-- Улучшить Xeno
local function upgradeXeno()
    local nextLevel = XenoData.Level + 1
    if nextLevel > 5 then
        notify("⭐ У вас максимальный уровень!", Color3.new(1, 1, 0))
        return
    end
    
    local price = CONFIG.Levels[nextLevel].Price
    
    -- Проверка денег (пример с CashValue)
    local cash = Player:FindFirstChild("CashValue")
    if cash and cash:IsA("NumberValue") then
        if cash.Value < price then
            notify(string.format("❌ Недостаточно денег! Нужно $%d", price), Color3.new(1, 0, 0))
            return
        end
        cash.Value = cash.Value - price
    else
        -- Если нет системы денег, просто улучшаем
        notify("⚠️ Система денег не найдена, улучшение бесплатно!", Color3.new(1, 1, 0))
    end
    
    XenoData.Level = nextLevel
    
    -- Если надето, обновляем
    if XenoData.Equipped then
        unequipXeno()
        task.wait(0.5)
        equipXeno()
    end
    
    notify(string.format("⬆️ Улучшено до %s!", CONFIG.Levels[nextLevel].Name), Color3.new(0, 1, 0))
    updateUI()
end

-- Использовать способность
local function useAbility(name)
    if not XenoData.Equipped then
        notify("❌ Наденьте Xeno!", Color3.new(1, 0, 0))
        return
    end
    
    local ability = XenoData.Abilities[name]
    local config = CONFIG.Abilities[name]
    
    if ability.Cooldown > 0 then
        notify(string.format("⏳ Способность перезаряжается! (%ds)", math.ceil(ability.Cooldown)), 
            Color3.new(1, 1, 0))
        return
    end
    
    if ability.Active then
        notify("⚠️ Способность уже активна!", Color3.new(1, 1, 0))
        return
    end
    
    local character = Player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Активируем способность
    ability.Active = true
    ability.Cooldown = config.Cooldown
    
    if name == "ShieldBoost" then
        local boost = XenoData.MaxShield * config.Multiplier
        XenoData.MaxShield = boost
        XenoData.Shield = boost
        notify(string.format("🛡️ Щит увеличен до %d!", boost), Color3.new(0, 0.5, 1))
        
        task.wait(config.Duration)
        local config2 = CONFIG.Levels[XenoData.Level]
        XenoData.MaxShield = config2.Shield
        XenoData.Shield = math.min(XenoData.Shield, XenoData.MaxShield)
        ability.Active = false
        notify("🛡️ Щит восстановлен", Color3.new(0.5, 0.5, 0.5))
        
    elseif name == "SpeedBoost" then
        local speed = humanoid.WalkSpeed * config.Multiplier
        humanoid.WalkSpeed = speed
        notify(string.format("⚡ Скорость увеличена до %d!", speed), Color3.new(1, 1, 0))
        
        task.wait(config.Duration)
        humanoid.WalkSpeed = CONFIG.Levels[XenoData.Level].Speed
        ability.Active = false
        notify("⚡ Скорость восстановлена", Color3.new(0.5, 0.5, 0.5))
        
    elseif name == "JumpBoost" then
        local jump = humanoid.JumpPower * config.Multiplier
        humanoid.JumpPower = jump
        notify(string.format("🚀 Прыжок увеличен до %d!", jump), Color3.new(0, 1, 1))
        
        task.wait(config.Duration)
        humanoid.JumpPower = CONFIG.Levels[XenoData.Level].JumpPower
        ability.Active = false
        notify("🚀 Прыжок восстановлен", Color3.new(0.5, 0.5, 0.5))
        
    elseif name == "Heal" then
        local heal = config.HealAmount
        humanoid.Health = math.min(humanoid.Health + heal, humanoid.MaxHealth)
        notify(string.format("❤️ Восстановлено %d здоровья!", heal), Color3.new(0, 1, 0))
        ability.Active = false
    end
    
    updateUI()
    
    -- Таймер перезарядки
    task.spawn(function()
        while ability.Cooldown > 0 do
            task.wait(1)
            ability.Cooldown = ability.Cooldown - 1
            updateUI()
        end
        if not ability.Active then
            ability.Cooldown = 0
            updateUI()
        end
    end)
end

-- Уведомление
local function notify(message, color)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 400, 0, 50)
    notification.Position = UDim2.new(0.5, -200, 0.8, 0)
    notification.BackgroundColor3 = Color3.new(0, 0, 0)
    notification.BackgroundTransparency = 0.5
    notification.BorderSizePixel = 2
    notification.BorderColor3 = color or Color3.new(1, 1, 1)
    notification.Text = message
    notification.TextColor3 = Color3.new(1, 1, 1)
    notification.TextScaled = true
    notification.Font = Enum.Font.GothamBold
    notification.Parent = Player.PlayerGui
    
    -- Анимация появления
    notification.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(notification, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 400, 0, 50)
    }):Play()
    
    task.wait(3)
    TweenService:Create(notification, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    notification:Destroy()
end

-- ============================================
-- ЗАЩИТА ЩИТА
-- ============================================

-- Система регенерации щита
task.spawn(function()
    while task.wait(2) do
        if XenoData.Equipped and XenoData.Shield < XenoData.MaxShield then
            XenoData.Shield = math.min(XenoData.Shield + 5, XenoData.MaxShield)
            updateUI()
        end
    end
end)

-- Система урона для щита
local function onCharacterAdded(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local originalHealth = humanoid.Health
    
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if not XenoData.Equipped then return end
        
        local damage = originalHealth - humanoid.Health
        if damage > 0 and XenoData.Shield > 0 then
            -- Урон идет в щит
            local shieldDamage = math.min(damage, XenoData.Shield)
            XenoData.Shield = XenoData.Shield - shieldDamage
            humanoid.Health = humanoid.Health + shieldDamage
            
            if XenoData.Shield <= 0 then
                XenoData.Shield = 0
                notify("⚠️ Щит разрушен!", Color3.new(1, 0, 0))
            end
            
            updateUI()
        end
        originalHealth = humanoid.Health
    end)
end

Player.CharacterAdded:Connect(onCharacterAdded)
if Player.Character then
    onCharacterAdded(Player.Character)
end

-- ============================================
-- ИНИЦИАЛИЗАЦИЯ
-- ============================================

-- Создать UI
CreateUI()

-- Загрузить данные
local function loadData()
    -- Проверяем наличие сохраненных данных
    local data = Player:FindFirstChild("XenoData")
    if data then
        XenoData.Level = data.Level or 1
    else
        -- Создаем новые данные
        local newData = Instance.new("NumberValue")
        newData.Name = "XenoData"
        newData.Value = XenoData.Level
        newData.Parent = Player
    end
    updateUI()
end

-- Сохранять данные при выходе
Player:GetPropertyChangedSignal("Parent"):Connect(function()
    local data = Player:FindFirstChild("XenoData")
    if data then
        data.Value = XenoData.Level
    end
end)

loadData()

print("✅ Xeno System загружен!")
print("🔥 Нажми X для открытия меню")
print("🎮 Используй 1-4 для способностей")

-- ============================================
-- СПРАВКА ПО КЛАВИШАМ
-- ============================================
-- X - Открыть меню
-- 1 - Shield Boost
-- 2 - Speed Boost
-- 3 - Jump Boost
-- 4 - Self Heal
-- ============================================
