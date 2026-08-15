local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Window = OrionLib:MakeWindow({
    Name = "FOV Changer | Меню", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroText = "FOV Changer",
    IntroToggle = false
})

-- Переменная для хранения текущего FOV
getgenv().TargetFOV = 120

-- Функция принудительного удержания FOV
local function applyFOV()
    if Workspace.CurrentCamera then
        Workspace.CurrentCamera.FieldOfView = getgenv().TargetFOV
    end
end

-- Вкладка в меню
local MainTab = Window:MakeTab({
    Name = "Настройки",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Ползунок для изменения FOV
MainTab:AddSlider({
    Name = "Поле зрения (FOV)",
    Min = 70,
    Max = 120,
    Default = 120,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Градусов",
    Callback = function(Value)
        getgenv().TargetFOV = Value
        applyFOV()
    end    
})

-- Инструкция внутри меню
MainTab:AddLabel("Нажми Правый Shift (RightShift), чтобы скрыть меню.")

-- Защита от сброса при смерти и от изменения FOV самой игрой
Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applyFOV()
end)

Workspace.CurrentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if Workspace.CurrentCamera and Workspace.CurrentCamera.FieldOfView ~= getgenv().TargetFOV then
        Workspace.CurrentCamera.FieldOfView = getgenv().TargetFOV
    end
end)

-- Первичный запуск
applyFOV()
OrionLib:Init()

print("Скрипт запущен! Меню открывается/закрывается на Правый Shift.")
