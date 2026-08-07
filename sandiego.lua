-- ОБХОД АНТИЧЕТА: Плавный разгон (Speed Booster)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Начальное уведомление в игре
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Скрипт Запущен!",
    Text = "Начинаем разгон и сбор координат...",
    Duration = 5
})

-- 1. Цикл: Каждые 2 секунды выводим координаты в консоль (нажмите F9 в игре, чтобы увидеть)
task.spawn(function()
    while true do
        if rootPart then
            print("--- ВАШИ КООРДИНАТЫ ---")
            print("Position: Vector3.new(" .. tostring(rootPart.Position) .. ")")
        end
        task.wait(2)
    end
end)

-- 2. Безопасно увеличиваем скорость персонажа
local targetSpeed = 45 -- Безопасный лимит для San Diego
humanoid.WalkSpeed = targetSpeed

print("Скрипт успешно настроен на скорость: " .. targetSpeed)
