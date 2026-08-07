-- BorderManager (Server Script)
-- Этот скрипт управляет всей логикой КПП

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Создаем Remote Events для связи с клиентом
local RemoteEvents = Instance.new("Folder")
RemoteEvents.Name = "BorderRemotes"
RemoteEvents.Parent = ReplicatedStorage

local CheckDocumentEvent = Instance.new("RemoteEvent")
CheckDocumentEvent.Name = "CheckDocument"
CheckDocumentEvent.Parent = RemoteEvents

local ScanVehicleEvent = Instance.new("RemoteEvent")
ScanVehicleEvent.Name = "ScanVehicle"
ScanVehicleEvent.Parent = RemoteEvents

local BorderStatusEvent = Instance.new("RemoteEvent")
BorderStatusEvent.Name = "BorderStatus"
BorderStatusEvent.Parent = RemoteEvents

-- Настройки зоны КПП (Измени координаты под свой карту!)
local BORDER_ZONE = {
    Center = Vector3.new(0, 0, 0), -- Центр КПП (где стоят будки)
    Radius = 50, -- Радиус зоны
    CheckpointOffset = Vector3.new(0, 5, 0) -- Точка для спавна эффектов
}

-- База данных разыскиваемых авто (для примера)
local WANTED_VEHICLES = {
    ["ABC-123"] = true,
    ["XPT-666"] = true,
    ["LOL-001"] = true
}

-- Функция проверки документов у игрока
local function checkPlayerDocuments(player)
    -- Ищем в инвентаре игрока предмет "Visa" или "Passport"
    -- В San Diego RP обычно используется Tool или IntValue в игроке
    local backpack = player.Backpack
    local hasVisa = false
    
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and (item.Name == "Visa" or item.Name == "Passport") then
            hasVisa = true
            break
        end
    end
    
    -- Также проверяем в руках
    if player.Character then
        local character = player.Character
        for _, item in pairs(character:GetChildren()) do
            if item:IsA("Tool") and (item.Name == "Visa" or item.Name == "Passport") then
                hasVisa = true
                break
            end
        end
    end
    
    return hasVisa
end

-- Функция проверки машины (по номеру)
local function checkVehicle(vehicle)
    if not vehicle or not vehicle:IsA("VehicleSeat") then return false end
    -- Ищем атрибут "LicensePlate" у машины или родительской модели
    local parent = vehicle.Parent
    if parent then
        local plate = parent:FindFirstChild("LicensePlate")
        if plate and plate:IsA("StringValue") then
            return WANTED_VEHICLES[plate.Value] or false
        end
    end
    return false
end

-- Обработчик запроса на проверку документов (от полиции)
CheckDocumentEvent.OnServerEvent:Connect(function(player, targetPlayer)
    -- Проверяем, что игрок который вызывает (player) - полицейский (или имеет ранг)
    -- Для примера пропустим проверку ранга, но в реале добавь проверку Team или Rank
    
    if not targetPlayer or not targetPlayer:IsA("Player") then return end
    
    local hasDocs = checkPlayerDocuments(targetPlayer)
    local message = ""
    local color = Color3.new(0, 1, 0) -- Зеленый по умолчанию
    
    if hasDocs then
        message = targetPlayer.Name .. " имеет действующие документы. ✅"
    else
        message = targetPlayer.Name .. " НЕ ИМЕЕТ документов! 🚨 Арестуйте его!"
        color = Color3.new(1, 0, 0)
    end
    
    -- Отправляем результат обратно инициатору проверки
    BorderStatusEvent:FireClient(player, message, color)
    
    -- Логируем в чат сервера для всех (RP атмосфера)
    print(string.format("[Пограничный контроль] %s проверил %s. Результат: %s", player.Name, targetPlayer.Name, hasDocs and "Одобрено" or "Отказ"))
    
    -- Бонус: Если документов нет, кидаем эффект тревоги (для всех)
    if not hasDocs then
        for _, plr in pairs(Players:GetPlayers()) do
            BorderStatusEvent:FireClient(plr, "ВНИМАНИЕ! Нарушитель на КПП!", Color3.new(1, 0, 0))
        end
    end
end)

-- Обработчик сканирования номеров
ScanVehicleEvent.OnServerEvent:Connect(function(player, vehicle)
    if not vehicle or not vehicle:IsA("VehicleSeat") then 
        BorderStatusEvent:FireClient(player, "Ошибка: Объект не является транспортом.", Color3.new(1, 1, 0))
        return 
    end
    
    local isWanted = checkVehicle(vehicle)
    local message = ""
    local color = Color3.new(0, 1, 0)
    
    if isWanted then
        message = "🚨 ТРАНСПОРТ В РОЗЫСКЕ! Задержите водителя! 🚨"
        color = Color3.new(1, 0, 0)
        -- Тут можно добавить спавн NPC полиции или звук сирены
    else
        message = "Транспорт чист. Можете пропустить."
    end
    
    BorderStatusEvent:FireClient(player, message, color)
end)

-- Система автоматического обнаружения зоны (для красоты)
-- Игроки, заходящие в зону КПП, получают уведомление
task.spawn(function()
    while task.wait(5) do -- Проверка раз в 5 секунд для оптимизации
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local distance = (rootPart.Position - BORDER_ZONE.Center).Magnitude
                
                if distance < BORDER_ZONE.Radius then
                    BorderStatusEvent:FireClient(player, "Вы въехали в зону пограничного контроля. Приготовьте документы.", Color3.new(0, 0.5, 1))
                end
            end
        end
    end
end)

print("Border Control System загружен!")
