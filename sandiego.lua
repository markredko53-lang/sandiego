-- BorderManager (Server Script)
-- Полностью рабочий скрипт для San Diego Border RP

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Создаем Remote Events для связи
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

-- Настройки КПП
local BORDER_ZONE = {
    Center = Vector3.new(0, 0, 0), -- Центр КПП
    Radius = 50
}

-- База разыскиваемых авто
local WANTED_VEHICLES = {
    ["ABC-123"] = true,
    ["XPT-666"] = true,
    ["LOL-001"] = true
}

-- Проверка документов
local function checkPlayerDocuments(player)
    local hasVisa = false
    
    -- Проверяем в инвентаре
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") and (item.Name == "Visa" or item.Name == "Passport") then
            hasVisa = true
            break
        end
    end
    
    -- Проверяем в руках
    if player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            if item:IsA("Tool") and (item.Name == "Visa" or item.Name == "Passport") then
                hasVisa = true
                break
            end
        end
    end
    
    return hasVisa
end

-- Проверка машины
local function checkVehicle(vehicle)
    if not vehicle or not vehicle:IsA("VehicleSeat") then 
        return false 
    end
    
    local parent = vehicle.Parent
    if parent then
        local plate = parent:FindFirstChild("LicensePlate")
        if plate and plate:IsA("StringValue") then
            return WANTED_VEHICLES[plate.Value] or false
        end
    end
    return false
end

-- Обработчик проверки документов
CheckDocumentEvent.OnServerEvent:Connect(function(player, targetPlayer)
    if not targetPlayer or not targetPlayer:IsA("Player") then 
        return 
    end
    
    local hasDocs = checkPlayerDocuments(targetPlayer)
    local message = ""
    local color = Color3.new(0, 1, 0)
    
    if hasDocs then
        message = targetPlayer.Name .. " ✅ Имеет документы. Пропустить!"
    else
        message = "🚨 " .. targetPlayer.Name .. " НЕТ ДОКУМЕНТОВ! ЗАДЕРЖАТЬ!"
        color = Color3.new(1, 0, 0)
    end
    
    BorderStatusEvent:FireClient(player, message, color)
    
    -- Оповещение всех полицейских
    if not hasDocs then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Team and plr.Team.Name == "Police" then
                BorderStatusEvent:FireClient(plr, "🚨 ВНИМАНИЕ! Нарушитель: " .. targetPlayer.Name, Color3.new(1, 0, 0))
            end
        end
    end
end)

-- Обработчик сканирования номеров
ScanVehicleEvent.OnServerEvent:Connect(function(player, vehicle)
    if not vehicle or not vehicle:IsA("VehicleSeat") then 
        BorderStatusEvent:FireClient(player, "❌ Это не транспорт!", Color3.new(1, 1, 0))
        return 
    end
    
    local isWanted = checkVehicle(vehicle)
    local message = ""
    local color = Color3.new(0, 1, 0)
    
    if isWanted then
        message = "🚨 ТРАНСПОРТ В РОЗЫСКЕ! Задержите!"
        color = Color3.new(1, 0, 0)
    else
        message = "✅ Транспорт чист. Пропустить!"
    end
    
    BorderStatusEvent:FireClient(player, message, color)
end)

-- Авто-уведомление при входе в зону
task.spawn(function()
    while task.wait(5) do
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local distance = (rootPart.Position - BORDER_ZONE.Center).Magnitude
                
                if distance < BORDER_ZONE.Radius then
                    BorderStatusEvent:FireClient(player, "🚧 Вы на КПП. Приготовьте документы!", Color3.new(0, 0.5, 1))
                end
            end
        end
    end
end)

print("✅ Border Control System загружен!")
