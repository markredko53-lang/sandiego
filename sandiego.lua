-- ============================================
-- XENO SUIT SYSTEM v7.0
-- ДЛЯ INJECTOR (GitHub Version)
-- SAN DIEGO BORDER RP
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

if not Player then 
    print("❌ Ошибка: Игрок не найден!")
    return
end

print("✅ Xeno Loader запущен...")

-- ============================================
-- КОНФИГ
-- ============================================

local Xeno = {
    Level = 1,
    Equipped = false,
    Shield = 0,
    MaxShield = 0,
    
    Levels = {
        [1] = {Name = "Light Xeno", Color = Color3.fromRGB(100, 200, 255), Health = 150, Speed = 20, Shield = 50, Power = 10},
        [2] = {Name = "Medium Xeno", Color = Color3.fromRGB(0, 150, 255), Health = 200, Speed = 22, Shield = 100, Power = 15},
        [3] = {Name = "Heavy Xeno", Color = Color3.fromRGB(255, 100, 0), Health = 300, Speed = 18, Shield = 200, Power = 20},
        [4] = {Name = "Elite Xeno", Color = Color3.fromRGB(255, 0, 255), Health = 400, Speed = 25, Shield = 300, Power = 25},
        [5] = {Name = "Legendary Xeno", Color = Color3.fromRGB(255, 215, 0), Health = 500, Speed = 30, Shield = 500, Power = 35}
    },
    
    Abilities = {
        ShieldBoost = {Name = "🛡️ Shield Boost", Cooldown = 30, Duration = 10, Key = Enum.KeyCode.One},
        SpeedBoost = {Name = "⚡ Speed Boost", Cooldown = 20, Duration = 8, Key = Enum.KeyCode.Two},
        JumpBoost = {Name = "🚀 Jump Boost", Cooldown = 15, Duration = 5, Key = Enum.KeyCode.Three},
        Heal = {Name = "❤️ Self Heal", Cooldown = 45, Key = Enum.KeyCode.Four},
        Invis = {Name = "👻 Invisibility", Cooldown = 60, Duration = 15, Key = Enum.KeyCode.Five}
    }
}

local Abilities = {
    ShieldBoost = {Cooldown = 0, Active = false, Timer = 0},
    SpeedBoost = {Cooldown = 0, Active = false, Timer = 0},
    JumpBoost = {Cooldown = 0, Active = false, Timer = 0},
    Heal = {Cooldown = 0},
    Invis = {Cooldown = 0, Active = false, Timer = 0}
}

local Connections = {}
local XenoParts = {}

-- ============================================
-- СОЗДАНИЕ GUI
-- ============================================

local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XenoSystem"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    -- ===== ГЛАВНАЯ ПАНЕЛЬ =====
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 350, 0, 500)
    Main.Position = UDim2.new(0.5, -175, 0.5, -250)
    Main.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
    Main.BackgroundTransparency = 0.15
    Main.BorderSizePixel = 3
    Main.BorderColor3 = Color3.new(0, 0.6, 1)
    Main.Visible = false
    Main.Parent = ScreenGui
    
    -- Заголовок с градиентом
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 55)
    Header.BackgroundColor3 = Color3.new(0, 0.3, 0.6)
    Header.Parent = Main
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚡ XENO SYSTEM v7.0"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Header
    
    -- Инфо панель
    local Info = Instance.new("Frame")
    Info.Size = UDim2.new(0.92, 0, 0, 90)
    Info.Position = UDim2.new(0.04, 0, 0, 65)
    Info.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    Info.BorderSizePixel = 2
    Info.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
    Info.Parent = Main
    
    local LvlName = Instance.new("TextLabel")
    LvlName.Name = "LvlName"
    LvlName.Size = UDim2.new(1, 0, 0.4, 0)
    LvlName.Position = UDim2.new(0, 0, 0, 5)
    LvlName.BackgroundTransparency = 1
    LvlName.Text = "Light Xeno"
    LvlName.TextColor3 = Color3.new(1, 1, 1)
    LvlName.TextScaled = true
    LvlName.Font = Enum.Font.GothamBold
    LvlName.Parent = Info
    
    local LvlStats = Instance.new("TextLabel")
    LvlStats.Name = "LvlStats"
    LvlStats.Size = UDim2.new(1, 0, 0.4, 0)
    LvlStats.Position = UDim2.new(0, 0, 0.4, 0)
    LvlStats.BackgroundTransparency = 1
    LvlStats.Text = "❤️ 150 | ⚡ 20 | 🛡️ 50 | 💥 10"
    LvlStats.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    LvlStats.TextScaled = true
    LvlStats.Font = Enum.Font.Gotham
    LvlStats.Parent = Info
    
    -- Кнопки управления
    local BtnEquip = Instance.new("TextButton")
    BtnEquip.Name = "BtnEquip"
    BtnEquip.Size = UDim2.new(0.9, 0, 0, 42)
    BtnEquip.Position = UDim2.new(0.05, 0, 0, 170)
    BtnEquip.BackgroundColor3 = Color3.new(0, 0.5, 1)
    BtnEquip.Text = "🔧 Надеть Xeno"
    BtnEquip.TextColor3 = Color3.new(1, 1, 1)
    BtnEquip.Font = Enum.Font.GothamBold
    BtnEquip.TextScaled = true
    BtnEquip.Parent = Main
    
    local BtnUnequip = Instance.new("TextButton")
    BtnUnequip.Name = "BtnUnequip"
    BtnUnequip.Size = UDim2.new(0.9, 0, 0, 42)
    BtnUnequip.Position = UDim2.new(0.05, 0, 0, 218)
    BtnUnequip.BackgroundColor3 = Color3.new(1, 0.2, 0.2)
    BtnUnequip.Text = "❌ Снять Xeno"
    BtnUnequip.TextColor3 = Color3.new(1, 1, 1)
    BtnUnequip.Font = Enum.Font.GothamBold
    BtnUnequip.TextScaled = true
    BtnUnequip.Parent = Main
    
    local BtnUpgrade = Instance.new("TextButton")
    BtnUpgrade.Name = "BtnUpgrade"
    BtnUpgrade.Size = UDim2.new(0.9, 0, 0, 42)
    BtnUpgrade.Position = UDim2.new(0.05, 0, 0, 266)
    BtnUpgrade.BackgroundColor3 = Color3.new(0.8, 0.6, 0)
    BtnUpgrade.Text = "⬆️ Улучшить (Level 2)"
    BtnUpgrade.TextColor3 = Color3.new(1, 1, 1)
    BtnUpgrade.Font = Enum.Font.GothamBold
    BtnUpgrade.TextScaled = true
    BtnUpgrade.Parent = Main
    
    -- Статус
    local Status = Instance.new("Frame")
    Status.Size = UDim2.new(0.92, 0, 0, 85)
    Status.Position = UDim2.new(0.04, 0, 0, 320)
    Status.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    Status.BorderSizePixel = 2
    Status.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
    Status.Parent = Main
    
    local ShieldText = Instance.new("TextLabel")
    ShieldText.Name = "ShieldText"
    ShieldText.Size = UDim2.new(1, 0, 0.4, 0)
    ShieldText.Position = UDim2.new(0, 0, 0, 5)
    ShieldText.BackgroundTransparency = 1
    ShieldText.Text = "🛡️ Щит: 50/50"
    ShieldText.TextColor3 = Color3.new(0.5, 0.8, 1)
    ShieldText.TextScaled = true
    ShieldText.Font = Enum.Font.Gotham
    ShieldText.Parent = Status
    
    local EquipText = Instance.new("TextLabel")
    EquipText.Name = "EquipText"
    EquipText.Size = UDim2.new(1, 0, 0.4, 0)
    EquipText.Position = UDim2.new(0, 0, 0.4, 0)
    EquipText.BackgroundTransparency = 1
    EquipText.Text = "❌ Не надет"
    EquipText.TextColor3 = Color3.new(1, 0.3, 0.3)
    EquipText.TextScaled = true
    EquipText.Font = Enum.Font.Gotham
    EquipText.Parent = Status
    
    -- ===== ПАНЕЛЬ СПОСОБНОСТЕЙ =====
    local AbilPanel = Instance.new("Frame")
    AbilPanel.Name = "AbilPanel"
    AbilPanel.Size = UDim2.new(0, 280, 0, 260)
    AbilPanel.Position = UDim2.new(1, 15, 0.5, -130)
    AbilPanel.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
    AbilPanel.BackgroundTransparency = 0.2
    AbilPanel.BorderSizePixel = 2
    AbilPanel.BorderColor3 = Color3.new(0.4, 0.4, 0.4)
    AbilPanel.Visible = false
    AbilPanel.Parent = ScreenGui
    
    local AbTitle = Instance.new("TextLabel")
    AbTitle.Size = UDim2.new(1, 0, 0, 35)
    AbTitle.Position = UDim2.new(0, 0, 0, 5)
    AbTitle.BackgroundTransparency = 1
    AbTitle.Text = "⚡ СПОСОБНОСТИ"
    AbTitle.TextColor3 = Color3.new(1, 1, 1)
    AbTitle.TextScaled = true
    AbTitle.Font = Enum.Font.GothamBold
    AbTitle.Parent = AbilPanel
    
    local AbilityBtns = {}
    local y = 45
    for name, ability in pairs(Xeno.Abilities) do
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Btn"
        btn.Size = UDim2.new(0.92, 0, 0, 36)
        btn.Position = UDim2.new(0.04, 0, 0, y)
        btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
        btn.Text = ability.Name .. " [Готов]"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextScaled = true
        btn.Parent = AbilPanel
        AbilityBtns[name] = btn
        y = y + 42
    end
    
    local HotkeyInfo = Instance.new("TextLabel")
    HotkeyInfo.Size = UDim2.new(1, 0, 0, 20)
    HotkeyInfo.Position = UDim2.new(0, 0, 0, y)
    HotkeyInfo.BackgroundTransparency = 1
    HotkeyInfo.Text = "Клавиши: 1-5 | X - меню"
    HotkeyInfo.TextColor3 = Color3.new(0.5, 0.5, 0.5)
    HotkeyInfo.TextScaled = true
    HotkeyInfo.Font = Enum.Font.Gotham
    HotkeyInfo.Parent = AbilPanel
    
    -- ===== ИНДИКАТОР ЩИТА =====
    local ShieldInd = Instance.new("Frame")
    ShieldInd.Name = "ShieldInd"
    ShieldInd.Size = UDim2.new(0, 320, 0, 40)
    ShieldInd.Position = UDim2.new(0.5, -160, 0.92, 0)
    ShieldInd.BackgroundColor3 = Color3.new(0, 0, 0)
    ShieldInd.BackgroundTransparency = 0.4
    ShieldInd.BorderSizePixel = 2
    ShieldInd.BorderColor3 = Color3.new(0, 0.5, 1)
    ShieldInd.Visible = false
    ShieldInd.Parent = ScreenGui
    
    local ShieldIcon = Instance.new("TextLabel")
    ShieldIcon.Size = UDim2.new(0.1, 0, 1, 0)
    ShieldIcon.Position = UDim2.new(0.02, 0, 0, 0)
    ShieldIcon.BackgroundTransparency = 1
    ShieldIcon.Text = "🛡️"
    ShieldIcon.TextColor3 = Color3.new(1, 1, 1)
    ShieldIcon.TextScaled = true
    ShieldIcon.Font = Enum.Font.Gotham
    ShieldIcon.Parent = ShieldInd
    
    local ShieldBar = Instance.new("Frame")
    ShieldBar.Size = UDim2.new(0.7, 0, 0.7, 0)
    ShieldBar.Position = UDim2.new(0.14, 0, 0.15, 0)
    ShieldBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.2)
    ShieldBar.BorderSizePixel = 1
    ShieldBar.Parent = ShieldInd
    
    local ShieldFill = Instance.new("Frame")
    ShieldFill.Name = "ShieldFill"
    ShieldFill.Size = UDim2.new(1, 0, 1, 0)
    ShieldFill.BackgroundColor3 = Color3.new(0, 0.8, 1)
    ShieldFill.BorderSizePixel = 0
    ShieldFill.Parent = ShieldBar
    
    local ShieldNum = Instance.new("TextLabel")
    ShieldNum.Name = "ShieldNum"
    ShieldNum.Size = UDim2.new(0.2, 0, 1, 0)
    ShieldNum.Position = UDim2.new(0.78, 0, 0, 0)
    ShieldNum.BackgroundTransparency = 1
    ShieldNum.Text = "100/100"
    ShieldNum.TextColor3 = Color3.new(1, 1, 1)
    ShieldNum.TextScaled = true
    ShieldNum.Font = Enum.Font.Gotham
    ShieldNum.Parent = ShieldBar
    
    return {
        ScreenGui = ScreenGui,
        Main = Main,
        AbilPanel = AbilPanel,
        ShieldInd = ShieldInd,
        LvlName = LvlName,
        LvlStats = LvlStats,
        ShieldText = ShieldText,
        EquipText = EquipText,
        ShieldFill = ShieldFill,
        ShieldNum = ShieldNum,
        BtnEquip = BtnEquip,
        BtnUnequip = BtnUnequip,
        BtnUpgrade = BtnUpgrade,
        AbilityBtns = AbilityBtns
    }
end

local UI = CreateUI()

-- ============================================
-- ФУНКЦИИ УПРАВЛЕНИЯ
-- ============================================

local function UpdateUI()
    local lvl = Xeno.Levels[Xeno.Level]
    UI.LvlName.Text = lvl.Name
    UI.LvlName.TextColor3 = lvl.Color
    UI.LvlStats.Text = string.format("❤️ %d | ⚡ %d | 🛡️ %d | 💥 %d", 
        lvl.Health, lvl.Speed, lvl.Shield, lvl.Power)
    UI.ShieldText.Text = string.format("🛡️ Щит: %d/%d", Xeno.Shield, Xeno.MaxShield)
    UI.EquipText.Text = Xeno.Equipped and "✅ Надет" or "❌ Не надет"
    UI.EquipText.TextColor3 = Xeno.Equipped and Color3.new(0, 1, 0) or Color3.new(1, 0.3, 0.3)
    
    local nextLvl = Xeno.Level + 1
    if nextLvl <= 5 then
        UI.BtnUpgrade.Text = string.format("⬆️ Улучшить до %s", Xeno.Levels[nextLvl].Name)
        UI.BtnUpgrade.Visible = true
    else
        UI.BtnUpgrade.Text = "⭐ MAX LEVEL"
        UI.BtnUpgrade.Visible = true
    end
    
    if Xeno.Equipped then
        UI.ShieldInd.Visible = true
        local percent = Xeno.Shield / Xeno.MaxShield
        UI.ShieldFill.Size = UDim2.new(math.clamp(percent, 0, 1), 0, 1, 0)
        UI.ShieldNum.Text = string.format("%d/%d", math.floor(Xeno.Shield), Xeno.MaxShield)
        
        if percent > 0.5 then
            UI.ShieldFill.BackgroundColor3 = Color3.new(0, 0.8, 1)
        elseif percent > 0.25 then
            UI.ShieldFill.BackgroundColor3 = Color3.new(1, 0.8, 0)
        else
            UI.ShieldFill.BackgroundColor3 = Color3.new(1, 0, 0)
        end
    else
        UI.ShieldInd.Visible = false
    end
    
    for name, btn in pairs(UI.AbilityBtns) do
        local ab = Abilities[name]
        local config = Xeno.Abilities[name]
        if ab.Cooldown > 0 then
            btn.Text = string.format("%s [⏳ %ds]", config.Name, math.ceil(ab.Cooldown))
            btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        elseif ab.Active then
            btn.Text = string.format("%s [⚡ ACTIVE]", config.Name)
            btn.BackgroundColor3 = Color3.new(0, 0.8, 0)
        else
            btn.Text = string.format("%s [✅ Готов]", config.Name)
            btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
        end
    end
end

local function Notify(text, color)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(0.5, -220, 0.8, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 2
    frame.BorderColor3 = color or Color3.new(1, 1, 1)
    frame.Parent = UI.ScreenGui
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 440, 0, 50)
    }):Play()
    
    task.wait(3)
    
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    frame:Destroy()
end

-- ============================================
-- XENO ФУНКЦИИ
-- ============================================

local function EquipXeno()
    if Xeno.Equipped then
        Notify("⚠️ Xeno уже надет!", Color3.new(1, 1, 0))
        return
    end
    
    local char = Player.Character
    if not char then
        Notify("❌ Персонаж не найден!", Color3.new(1, 0, 0))
        return
    end
    
    local lvl = Xeno.Levels[Xeno.Level]
    
    -- Очистка старых частей
    for _, part in pairs(char:GetChildren()) do
        if part.Name == "XenoPart" then
            part:Destroy()
        end
    end
    for _, conn in pairs(Connections) do
        pcall(function() conn:Disconnect() end)
    end
    Connections = {}
    XenoParts = {}
    
    -- Создание Xeno
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        Notify("❌ RootPart не найден!", Color3.new(1, 0, 0))
        return
    end
    
    local xeno = Instance.new("Part")
    xeno.Name = "XenoPart"
    xeno.Size = Vector3.new(3.5, 1.2, 3.5)
    xeno.Shape = Enum.PartType.Ball
    xeno.Material = Enum.Material.Neon
    xeno.Color = lvl.Color
    xeno.Transparency = 0.25
    xeno.Anchored = false
    xeno.CanCollide = false
    
    local weld = Instance.new("Weld")
    weld.Part0 = root
    weld.Part1 = xeno
    weld.C0 = CFrame.new(0, 1.8, 0)
    weld.Parent = xeno
    
    xeno.Parent = char
    table.insert(XenoParts, xeno)
    
    -- Свет
    local light = Instance.new("PointLight")
    light.Range = 18
    light.Brightness = 4
    light.Color = lvl.Color
    light.Parent = xeno
    
    -- Анимация
    local conn = RunService.RenderStepped:Connect(function()
        if not xeno.Parent then
            conn:Disconnect()
            return
        end
        local float = math.sin(tick() * 2.5) * 0.25
        local rot = tick() * 45
        if root then
            xeno.Position = root.Position + Vector3.new(0, 1.8 + float, 0)
            xeno.Orientation = Vector3.new(0, rot % 360, 0)
        end
    end)
    table.insert(Connections, conn)
    
    -- Применение статов
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.MaxHealth = lvl.Health
        humanoid.Health = lvl.Health
        humanoid.WalkSpeed = lvl.Speed
        humanoid.JumpPower = lvl.JumpPower
    end
    
    Xeno.Equipped = true
    Xeno.Shield = lvl.Shield
    Xeno.MaxShield = lvl.Shield
    
    Notify("✅ Xeno надет! (" .. lvl.Name .. ")", Color3.new(0, 1, 0))
    UpdateUI()
end

local function UnequipXeno()
    if not Xeno.Equipped then
        Notify("⚠️ Xeno не надет!", Color3.new(1, 1, 0))
        return
    end
    
    local char = Player.Character
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part.Name == "XenoPart" then
                part:Destroy()
            end
        end
        
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
    
    for _, conn in pairs(Connections) do
        pcall(function() conn:Disconnect() end)
    end
    Connections = {}
    XenoParts = {}
    
    Xeno.Equipped = false
    Xeno.Shield = 0
    
    Notify("❌ Xeno снят!", Color3.new(1, 0, 0))
    UpdateUI()
end

local function UpgradeXeno()
    local nextLvl = Xeno.Level + 1
    if nextLvl > 5 then
        Notify("⭐ У вас максимальный уровень!", Color3.new(1, 1, 0))
        return
    end
    
    Xeno.Level = nextLvl
    
    if Xeno.Equipped then
        UnequipXeno()
        task.wait(0.3)
        EquipXeno()
    end
    
    Notify(string.format("⬆️ Улучшено до %s!", Xeno.Levels[nextLvl].Name), Color3.new(0, 1, 0))
    UpdateUI()
end

local function UseAbility(name)
    if not Xeno.Equipped then
        Notify("❌ Наденьте Xeno!", Color3.new(1, 0, 0))
        return
    end
    
    local ab = Abilities[name]
    local config = Xeno.Abilities[name]
    
    if ab.Cooldown > 0 then
        Notify(string.format("⏳ Перезарядка %ds", math.ceil(ab.Cooldown)), Color3.new(1, 1, 0))
        return
    end
    
    if ab.Active then
        Notify("⚠️ Способность активна!", Color3.new(1, 1, 0))
        return
    end
    
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    ab.Active = true
    ab.Cooldown = config.Cooldown
    ab.Timer = config.Duration or 0
    
    if name == "ShieldBoost" then
        local boost = Xeno.MaxShield * 2
        Xeno.MaxShield = boost
        Xeno.Shield = boost
        Notify(string.format("🛡️ Щит увеличен до %d!", boost), Color3.new(0, 0.5, 1))
        
        task.wait(config.Duration)
        local lvl = Xeno.Levels[Xeno.Level]
        Xeno.MaxShield = lvl.Shield
        Xeno.Shield = math.min(Xeno.Shield, Xeno.MaxShield)
        ab.Active = false
        Notify("🛡️ Щит восстановлен", Color3.new(0.5, 0.5, 0.5))
        
    elseif name == "SpeedBoost" then
        local speed = humanoid.WalkSpeed * 1.8
        humanoid.WalkSpeed = speed
        Notify(string.format("⚡ Скорость: %d", speed), Color3.new(1, 1, 0))
        
        task.wait(config.Duration)
        humanoid.WalkSpeed = Xeno.Levels[Xeno.Level].Speed
        ab.Active = false
        Notify("⚡ Скорость восстановлена", Color3.new(0.5, 0.5, 0.5))
        
    elseif name == "JumpBoost" then
        local jump = humanoid.JumpPower * 2
        humanoid.JumpPower = jump
        Notify(string.format("🚀 Прыжок: %d", jump), Color3.new(0, 1, 1))
        
        task.wait(config.Duration)
        humanoid.JumpPower = Xeno.Levels[Xeno.Level].JumpPower
        ab.Active = false
        Notify("🚀 Прыжок восстановлен", Color3.new(0.5, 0.5, 0.5))
        
    elseif name == "Heal" then
        local heal = 50
        humanoid.Health = math.min(humanoid.Health + heal, humanoid.MaxHealth)
        Notify(string.format("❤️ Восстановлено %d здоровья!", heal), Color3.new(0, 1, 0))
        ab.Active = false
        
    elseif name == "Invis" then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.8
            end
        end
        Notify("👻 Невидимость активирована!", Color3.new(0.5, 0, 1))
        
        task.wait(config.Duration)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        ab.Active = false
        Notify("👻 Невидимость деактивирована", Color3.new(0.5, 0.5, 0.5))
    end
    
    UpdateUI()
    
    task.spawn(function()
        while ab.Cooldown > 0 do
            task.wait(1)
            ab.Cooldown = ab.Cooldown - 1
            UpdateUI()
        end
        if not ab.Active then
            ab.Cooldown = 0
            UpdateUI()
        end
    end)
end

-- ============================================
-- НАСТРОЙКА КНОПОК
-- ============================================

local function SetupButtons()
    -- Открытие меню (X)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.X then
            UI.Main.Visible = not UI.Main.Visible
            UI.AbilPanel.Visible = UI.Main.Visible
            if UI.Main.Visible then UpdateUI() end
        end
    end)
    
    -- Кнопки
    UI.BtnEquip.MouseButton1Click:Connect(EquipXeno)
    UI.BtnUnequip.MouseButton1Click:Connect(UnequipXeno)
    UI.BtnUpgrade.MouseButton1Click:Connect(UpgradeXeno)
    
    for name, btn in pairs(UI.AbilityBtns) do
        btn.MouseButton1Click:Connect(function()
            UseAbility(name)
        end)
    end
    
    -- Горячие клавиши способностей
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        for name, config in pairs(Xeno.Abilities) do
            if input.KeyCode == config.Key then
                UseAbility(name)
            end
        end
    end)
end

SetupButtons()

-- ============================================
-- РЕГЕНЕРАЦИЯ ЩИТА
-- ============================================

task.spawn(function()
    while task.wait(2) do
        if Xeno.Equipped and Xeno.Shield < Xeno.MaxShield then
            Xeno.Shield = math.min(Xeno.Shield + 5, Xeno.MaxShield)
            UpdateUI()
        end
    end
end)

-- ============================================
-- ЗАЩИТА ОТ УРОНА (ЩИТ)
-- ============================================

local function OnCharacterAdded(char)
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local oldHealth = humanoid.Health
    
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if not Xeno.Equipped then return end
        local damage = oldHealth - humanoid.Health
        if damage > 0 and Xeno.Shield > 0 then
            local shieldDmg = math.min(damage, Xeno.Shield)
            Xeno.Shield = Xeno.Shield - shieldDmg
            humanoid.Health = humanoid.Health + shieldDmg
            
            if Xeno.Shield <= 0 then
                Xeno.Shield = 0
                Notify("⚠️ Щит разрушен!", Color3.new(1, 0, 0))
            end
            UpdateUI()
        end
        oldHealth = humanoid.Health
    end)
end

Player.CharacterAdded:Connect(OnCharacterAdded)
if Player.Character then
    OnCharacterAdded(Player.Character)
end

-- ============================================
-- ИНИЦИАЛИЗАЦИЯ
-- ============================================

UpdateUI()

print("========================================")
print("✅ XENO SYSTEM v7.0 ЗАГРУЖЕН!")
print("========================================")
print("🔥 Нажми X для открытия меню")
print("🎮 Клавиши способностей:")
print("   1 - Shield Boost")
print("   2 - Speed Boost")
print("   3 - Jump Boost")
print("   4 - Self Heal")
print("   5 - Invisibility")
print("========================================")
print("💡 Для обновления скрипта:")
print("   loadstring(game:HttpGet('YOUR_URL'))()")
print("========================================")
