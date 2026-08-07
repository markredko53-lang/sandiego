-- ============================================
-- XENO SUIT SYSTEM v4.2 (ПОЛНОСТЬЮ ИСПРАВЛЕННЫЙ)
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

-- Ждем персонажа, чтобы избежать nil ошибок при старте
repeat task.wait() until Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")

-- ============================================
-- КОНФИГУРАЦИЯ (данные)
-- ============================================
local CONFIG = {
    Levels = {
        [1] = { Name = "Light Xeno", Color = Color3.fromRGB(100, 200, 255), Health = 150, Speed = 20, JumpPower = 80, Shield = 50, Damage = 10 },
        [2] = { Name = "Medium Xeno", Color = Color3.fromRGB(0, 150, 255), Health = 200, Speed = 22, JumpPower = 90, Shield = 100, Damage = 15 },
        [3] = { Name = "Heavy Xeno", Color = Color3.fromRGB(255, 100, 0), Health = 300, Speed = 18, JumpPower = 70, Shield = 200, Damage = 20 },
        [4] = { Name = "Elite Xeno", Color = Color3.fromRGB(255, 0, 255), Health = 400, Speed = 25, JumpPower = 100, Shield = 300, Damage = 25 },
        [5] = { Name = "Legendary Xeno", Color = Color3.fromRGB(255, 215, 0), Health = 500, Speed = 30, JumpPower = 120, Shield = 500, Damage = 35 }
    },
    Abilities = {
        ShieldBoost = { Name = "🛡️ Shield Boost", Cooldown = 30, Duration = 10, Multiplier = 2, Key = Enum.KeyCode.One },
        SpeedBoost  = { Name = "⚡ Speed Boost",  Cooldown = 20, Duration = 8,  Multiplier = 1.5, Key = Enum.KeyCode.Two },
        JumpBoost   = { Name = "🚀 Jump Boost",   Cooldown = 15, Duration = 5,  Multiplier = 2,   Key = Enum.KeyCode.Three },
        Heal        = { Name = "❤️ Self Heal",    Cooldown = 45, HealAmount = 50,                  Key = Enum.KeyCode.Four }
    }
}

local XenoData = {
    Level = 1, Equipped = false, Shield = 0, MaxShield = 0,
    Abilities = {
        ShieldBoost = { Cooldown = 0, Active = false },
        SpeedBoost  = { Cooldown = 0, Active = false },
        JumpBoost   = { Cooldown = 0, Active = false },
        Heal        = { Cooldown = 0 }
    }
}

local XenoParts = {}
local Connections = {}
local UI = {}

-- ============================================
-- ФУНКЦИЯ СОЗДАНИЯ ИНТЕРФЕЙСА (ВАЖНО: ОНА ПЕРВАЯ)
-- ============================================
local function CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "XenoUI"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    
    -- Главное окно
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 350, 0, 500)
    mainPanel.Position = UDim2.new(0.5, -175, 0.5, -250)
    mainPanel.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
    mainPanel.BackgroundTransparency = 0.15
    mainPanel.BorderSizePixel = 3
    mainPanel.BorderColor3 = Color3.new(0, 0.5, 1)
    mainPanel.Visible = false
    mainPanel.Parent = screenGui
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.new(0, 0.3, 0.6)
    title.Text = "⚡ XENO SYSTEM"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainPanel
    
    -- Инфо панель
    local levelInfo = Instance.new("Frame")
    levelInfo.Size = UDim2.new(0.9, 0, 0, 90)
    levelInfo.Position = UDim2.new(0.05, 0, 0, 70)
    levelInfo.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    levelInfo.BorderSizePixel = 2
    levelInfo.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
    levelInfo.Parent = mainPanel
    
    local levelName = Instance.new("TextLabel")
    levelName.Name = "LevelName"
    levelName.Size = UDim2.new(1, 0, 0.4, 0)
    levelName.Position = UDim2.new(0, 0, 0, 5)
    levelName.BackgroundTransparency = 1
    levelName.Text = "Light Xeno"
    levelName.TextColor3 = Color3.new(1, 1, 1)
    levelName.TextScaled = true
    levelName.Font = Enum.Font.GothamBold
    levelName.Parent = levelInfo
    
    local levelStats = Instance.new("TextLabel")
    levelStats.Name = "LevelStats"
    levelStats.Size = UDim2.new(1, 0, 0.4, 0)
    levelStats.Position = UDim2.new(0, 0, 0.4, 0)
    levelStats.BackgroundTransparency = 1
    levelStats.Text = "❤️ 100 | ⚡ 20 | 🛡️ 50"
    levelStats.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    levelStats.TextScaled = true
    levelStats.Font = Enum.Font.Gotham
    levelStats.Parent = levelInfo
    
    -- Кнопки
    local equipBtn = Instance.new("TextButton")
    equipBtn.Size = UDim2.new(0.9, 0, 0, 45)
    equipBtn.Position = UDim2.new(0.05, 0, 0, 175)
    equipBtn.BackgroundColor3 = Color3.new(0, 0.5, 1)
    equipBtn.Text = "🔧 Надеть Xeno"
    equipBtn.TextColor3 = Color3.new(1, 1, 1)
    equipBtn.Font = Enum.Font.GothamBold
    equipBtn.TextScaled = true
    equipBtn.Parent = mainPanel
    
    local unequipBtn = Instance.new("TextButton")
    unequipBtn.Size = UDim2.new(0.9, 0, 0, 45)
    unequipBtn.Position = UDim2.new(0.05, 0, 0, 225)
    unequipBtn.BackgroundColor3 = Color3.new(1, 0.2, 0.2)
    unequipBtn.Text = "❌ Снять Xeno"
    unequipBtn.TextColor3 = Color3.new(1, 1, 1)
    unequipBtn.Font = Enum.Font.GothamBold
    unequipBtn.TextScaled = true
    unequipBtn.Parent = mainPanel
    
    local upgradeBtn = Instance.new("TextButton")
    upgradeBtn.Size = UDim2.new(0.9, 0, 0, 45)
    upgradeBtn.Position = UDim2.new(0.05, 0, 0, 275)
    upgradeBtn.BackgroundColor3 = Color3.new(0.8, 0.6, 0)
    upgradeBtn.Text = "⬆️ Улучшить (Level 2)"
    upgradeBtn.TextColor3 = Color3.new(1, 1, 1)
    upgradeBtn.Font = Enum.Font.GothamBold
    upgradeBtn.TextScaled = true
    upgradeBtn.Parent = mainPanel
    
    -- Статы
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(0.9, 0, 0, 80)
    statsFrame.Position = UDim2.new(0.05, 0, 0, 330)
    statsFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    statsFrame.BorderSizePixel = 2
    statsFrame.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
    statsFrame.Parent = mainPanel
    
    local shieldStat = Instance.new("TextLabel")
    shieldStat.Name = "ShieldStat"
    shieldStat.Size = UDim2.new(1, 0, 0.4, 0)
    shieldStat.Position = UDim2.new(0, 0, 0, 5)
    shieldStat.BackgroundTransparency = 1
    shieldStat.Text = "🛡️ Щит: 50/50"
    shieldStat.TextColor3 = Color3.new(0.5, 0.8, 1)
    shieldStat.TextScaled = true
    shieldStat.Font = Enum.Font.Gotham
    shieldStat.Parent = statsFrame
    
    local statusStat = Instance.new("TextLabel")
    statusStat.Name = "StatusStat"
    statusStat.Size = UDim2.new(1, 0, 0.4, 0)
    statusStat.Position = UDim2.new(0, 0, 0.4, 0)
    statusStat.BackgroundTransparency = 1
    statusStat.Text = "❌ Не надет"
    statusStat.TextColor3 = Color3.new(1, 0.3, 0.3)
    statusStat.TextScaled = true
    statusStat.Font = Enum.Font.Gotham
    statusStat.Parent = statsFrame
    
    -- Панель способностей
    local abilityPanel = Instance.new("Frame")
    abilityPanel.Name = "AbilityPanel"
    abilityPanel.Size = UDim2.new(0, 280, 0, 220)
    abilityPanel.Position = UDim2.new(1, 10, 0.5, -110)
    abilityPanel.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
    abilityPanel.BackgroundTransparency = 0.2
    abilityPanel.BorderSizePixel = 2
    abilityPanel.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
    abilityPanel.Visible = false
    abilityPanel.Parent = screenGui
    
    local abTitle = Instance.new("TextLabel")
    abTitle.Size = UDim2.new(1, 0, 0, 35)
    abTitle.Position = UDim2.new(0, 0, 0, 5)
    abTitle.BackgroundTransparency = 1
    abTitle.Text = "⚡ СПОСОБНОСТИ"
    abTitle.TextColor3 = Color3.new(1, 1, 1)
    abTitle.TextScaled = true
    abTitle.Font = Enum.Font.GothamBold
    abTitle.Parent = abilityPanel
    
    local abilityButtons = {}
    local yPos = 45
    for name, ability in pairs(CONFIG.Abilities) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
        btn.Text = ability.Name .. " [Готов]"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextScaled = true
        btn.Parent = abilityPanel
        abilityButtons[name] = btn
        yPos = yPos + 40
    end
    
    -- Индикатор щита
    local shieldIndicator = Instance.new("Frame")
    shieldIndicator.Name = "ShieldIndicator"
    shieldIndicator.Size = UDim2.new(0, 300, 0, 45)
    shieldIndicator.Position = UDim2.new(0.5, -150, 0.92, 0)
    shieldIndicator.BackgroundColor3 = Color3.new(0, 0, 0)
    shieldIndicator.BackgroundTransparency = 0.4
    shieldIndicator.BorderSizePixel = 2
    shieldIndicator.BorderColor3 = Color3.new(0, 0.5, 1)
    shieldIndicator.Visible = false
    shieldIndicator.Parent = screenGui
    
    local shieldIcon = Instance.new("TextLabel")
    shieldIcon.Size = UDim2.new(0.1, 0, 1, 0)
    shieldIcon.Position = UDim2.new(0.02, 0, 0, 0)
    shieldIcon.BackgroundTransparency = 1
    shieldIcon.Text = "🛡️"
    shieldIcon.TextColor3 = Color3.new(1, 1, 1)
    shieldIcon.TextScaled = true
    shieldIcon.Font = Enum.Font.Gotham
    shieldIcon.Parent = shieldIndicator
    
    local shieldBar = Instance.new("Frame")
    shieldBar.Name = "ShieldBar"
    shieldBar.Size = UDim2.new(0.7, 0, 0.7, 0)
    shieldBar.Position = UDim2.new(0.15, 0, 0.15, 0)
    shieldBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    shieldBar.BorderSizePixel = 1
    shieldBar.Parent = shieldIndicator
    
    local shieldFill = Instance.new("Frame")
    shieldFill.Name = "ShieldFill"
    shieldFill.Size = UDim2.new(1, 0, 1, 0)
    shieldFill.BackgroundColor3 = Color3.new(0, 0.8, 1)
    shieldFill.BorderSizePixel = 0
    shieldFill.Parent = shieldBar
    
    local shieldText = Instance.new("TextLabel")
    shieldText.Name = "ShieldText"
    shieldText.Size = UDim2.new(0.2, 0, 1, 0)
    shieldText.Position = UDim2.new(0.78, 0, 0, 0)
    shieldText.BackgroundTransparency = 1
    shieldText.Text = "100/100"
    shieldText.TextColor3 = Color3.new(1, 1, 1)
    shieldText.TextScaled = true
    shieldText.Font = Enum.Font.Gotham
    shieldText.Parent = shieldIndicator
    
    UI = {
        ScreenGui = screenGui, MainPanel = mainPanel, AbilityPanel = abilityPanel,
        ShieldIndicator = shieldIndicator, LevelName = levelName, LevelStats = levelStats,
        ShieldStat = shieldStat, StatusStat = statusStat, ShieldFill = shieldFill,
        ShieldText = shieldText, EquipBtn = equipBtn, UnequipBtn = unequipBtn,
        UpgradeBtn = upgradeBtn, AbilityButtons = abilityButtons
    }
    return UI
end

-- ============================================
-- ОБНОВЛЕНИЕ UI И УВЕДОМЛЕНИЯ
-- ============================================
local function updateUI()
    local config = CONFIG.Levels[XenoData.Level]
    if not config or not UI.LevelName then return end
    
    UI.LevelName.Text = config.Name
    UI.LevelName.TextColor3 = config.Color
    UI.LevelStats.Text = string.format("❤️ %d | ⚡ %d | 🛡️ %d", config.Health, config.Speed, config.Shield)
    UI.ShieldStat.Text = string.format("🛡️ Щит: %d/%d", XenoData.Shield, XenoData.MaxShield)
    UI.StatusStat.Text = XenoData.Equipped and "✅ Надет" or "❌ Не надет"
    UI.StatusStat.TextColor3 = XenoData.Equipped and Color3.new(0, 1, 0) or Color3.new(1, 0.3, 0.3)
    
    local nextLevel = XenoData.Level + 1
    if nextLevel <= 5 then
        UI.UpgradeBtn.Text = string.format("⬆️ Улучшить до %s", CONFIG.Levels[nextLevel].Name)
        UI.UpgradeBtn.Visible = true
    else
        UI.UpgradeBtn.Text = "⭐ MAX LEVEL"
        UI.UpgradeBtn.Visible = true
    end
    
    if XenoData.Equipped then
        UI.ShieldIndicator.Visible = true
        local percent = XenoData.Shield / XenoData.MaxShield
        UI.ShieldFill.Size = UDim2.new(percent, 0, 1, 0)
        UI.ShieldText.Text = string.format("%d/%d", math.floor(XenoData.Shield), XenoData.MaxShield)
        if percent > 0.5 then UI.ShieldFill.BackgroundColor3 = Color3.new(0, 0.8, 1)
        elseif percent > 0.25 then UI.ShieldFill.BackgroundColor3 = Color3.new(1, 0.8, 0)
        else UI.ShieldFill.BackgroundColor3 = Color3.new(1, 0, 0) end
    else
        UI.ShieldIndicator.Visible = false
    end
    
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

local function notify(message, color)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 0, 0, 0)
    notification.Position = UDim2.new(0.5, -200, 0.8, 0)
    notification.BackgroundColor3 = Color3.new(0, 0, 0)
    notification.BackgroundTransparency = 0.5
    notification.BorderSizePixel = 2
    notification.BorderColor3 = color or Color3.new(1, 1, 1)
    notification.Parent = CoreGui
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = notification
    
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 400, 0, 50) }):Play()
    task.wait(3)
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 0, 0, 0) }):Play()
    task.wait(0.3)
    notification:Destroy()
end

-- ============================================
-- ОСНОВНАЯ ЛОГИКА
-- ============================================
local function equipXeno()
    if XenoData.Equipped then notify("⚠️ Xeno уже надет!", Color3.new(1, 1, 0)) return end
    local config = CONFIG.Levels[XenoData.Level]
    local character = Player.Character
    if not character then notify("❌ Персонаж не найден!", Color3.new(1, 0, 0)) return end
    
    for _, part in pairs(character:GetChildren()) do if part.Name == "XenoPart" then part:Destroy() end end
    
    local xenoPart = Instance.new("Part")
    xenoPart.Name = "XenoPart"
    xenoPart.Size = Vector3.new(3, 1, 3)
    xenoPart.Shape = Enum.PartType.Ball
    xenoPart.Material = Enum.Material.Neon
    xenoPart.Color = config.Color
    xenoPart.Transparency = 0.3
    xenoPart.Anchored = false
    xenoPart.CanCollide = false
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then
        local weld = Instance.new("Weld")
        weld.Part0 = root
        weld.Part1 = xenoPart
        weld.C0 = CFrame.new(0, 1.5, 0)
        weld.Parent = xenoPart
    end
    xenoPart.Parent = character
    
    local light = Instance.new("PointLight")
    light.Range = 15
    light.Brightness = 3
    light.Color = config.Color
    light.Parent = xenoPart
    
    local connection = RunService.RenderStepped:Connect(function()
        if not xenoPart.Parent then connection:Disconnect() return end
        local float = math.sin(tick() * 2) * 0.2
        if root then
            xenoPart.Position = root.Position + Vector3.new(0, 1.5 + float, 0)
            xenoPart.Orientation = Vector3.new(0, tick() * 50 % 360, 0)
        end
    end)
    table.insert(XenoParts, xenoPart)
    table.insert(Connections, connection)
    
    XenoData.Equipped = true
    XenoData.Shield = config.Shield
    XenoData.MaxShield = config.Shield
    
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

local function unequipXeno()
    if not XenoData.Equipped then notify("⚠️ Xeno не надет!", Color3.new(1, 1, 0)) return end
    local character = Player.Character
    if character then
        for _, part in pairs(character:GetChildren()) do if part.Name == "XenoPart" then part:Destroy() end end
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
    for _, conn in pairs(Connections) do conn:Disconnect() end
    Connections = {}
    XenoParts = {}
    XenoData.Equipped = false
    XenoData.Shield = 0
    notify("❌ Xeno снят!", Color3.new(1, 0, 0))
    updateUI()
end

local function upgradeXeno()
    local nextLevel = XenoData.Level + 1
    if nextLevel > 5 then notify("⭐ У вас максимальный уровень!", Color3.new(1, 1, 0)) return end
    XenoData.Level = nextLevel
    if XenoData.Equipped then unequipXeno(); task.wait(0.5); equipXeno() end
    notify(string.format("⬆️ Улучшено до %s!", CONFIG.Levels[nextLevel].Name), Color3.new(0, 1, 0))
    updateUI()
end

local function useAbility(name)
    if not XenoData.Equipped then notify("❌ Наденьте Xeno!", Color3.new(1, 0, 0)) return end
    local ability = XenoData.Abilities[name]
    local config = CONFIG.Abilities[name]
    if ability.Cooldown > 0 then
        notify(string.format("⏳ Перезарядка %ds", math.ceil(ability.Cooldown)), Color3.new(1, 1, 0))
        return
    end
    if ability.Active then notify("⚠️ Способность активна!", Color3.new(1, 1, 0)) return end
    
    local character = Player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
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
        notify(string.format("⚡ Скорость: %d", speed), Color3.new(1, 1, 0))
        task.wait(config.Duration)
        humanoid.WalkSpeed = CONFIG.Levels[XenoData.Level].Speed
        ability.Active = false
        notify("⚡ Скорость восстановлена", Color3.new(0.5, 0.5, 0.5))
    elseif name == "JumpBoost" then
        local jump = humanoid.JumpPower * config.Multiplier
        humanoid.JumpPower = jump
        notify(string.format("🚀 Прыжок: %d", jump), Color3.new(0, 1, 1))
        task.wait(config.Duration)
        humanoid.JumpPower = CONFIG.Levels[XenoData.Level].JumpPower
        ability.Active = false
        notify("🚀 Прыжок восстановлен", Color3.new(0.5, 0.5, 0.5))
    elseif name == "Heal" then
        humanoid.Health = math.min(humanoid.Health + config.HealAmount, humanoid.MaxHealth)
        notify(string.format("❤️ +%d здоровья", config.HealAmount), Color3.new(0, 1, 0))
        ability.Active = false
    end
    updateUI()
    
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

-- ============================================
-- СБОРКА И ЗАПУСК
-- ============================================

UI = CreateUI() -- ВАЖНО: Сохраняем результат функции в UI
updateUI()

-- Привязка клавиш и кнопок
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        UI.MainPanel.Visible = not UI.MainPanel.Visible
        UI.AbilityPanel.Visible = UI.MainPanel.Visible
        updateUI()
    end
    if XenoData.Equipped then
        for name, ability in pairs(CONFIG.Abilities) do
            if input.KeyCode == ability.Key then useAbility(name) end
        end
    end
end)

UI.EquipBtn.MouseButton1Click:Connect(equipXeno)
UI.UnequipBtn.MouseButton1Click:Connect(unequipXeno)
UI.UpgradeBtn.MouseButton1Click:Connect(upgradeXeno)
for name, btn in pairs(UI.AbilityButtons) do
    btn.MouseButton1Click:Connect(function() useAbility(name) end)
end

task.spawn(function()
    while task.wait(2) do
        if XenoData.Equipped and XenoData.Shield < XenoData.MaxShield then
            XenoData.Shield = math.min(XenoData.Shield + 5, XenoData.MaxShield)
            updateUI()
        end
    end
end)

print("✅ XENO SYSTEM ЗАГРУЖЕН! Нажми X для меню, 1-4 для абилок.")
