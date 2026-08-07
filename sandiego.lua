if game.CoreGui:FindFirstChild("VehicleXenoMenu") then
    game.CoreGui.VehicleXenoMenu:Destroy()
end

local ui = Instance.new("ScreenGui")
ui.Name = "VehicleXenoMenu"
ui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Parent = ui
button.Size = UDim2.new(0, 260, 0, 60)
button.Position = UDim2.new(0.4, 0, 0.4, 0)
button.BackgroundColor3 = Color3.fromRGB(180, 70, 0) -- Оранжевый цвет
button.Text = "РАЗГОН МАШИНЫ: ВЫКЛ\n(Сначала сядьте за руль!)"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 13

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

local carSpeedActive = false
local carSpeedMultiplier = 2.5 -- Множитель скорости машины (в 2.5 раза быстрее обычного)

button.MouseButton1Click:Connect(function()
    carSpeedActive = not carSpeedActive
    if carSpeedActive then
        button.Text = "РАЗГОН МАШИНЫ: РАБОТАЕТ\n(Зажмите W для полета/быстрой езды)"
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    else
        button.Text = "РАЗГОН МАШИНЫ: ВЫКЛ\n(Сначала сядьте за руль!)"
        button.BackgroundColor3 = Color3.fromRGB(180, 70, 0)
    end
end)

-- Цикл ускорения машины через физический импульс (Velocity)
game:GetService("RunService").Heartbeat:Connect(function()
    if carSpeedActive then
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            -- Проверяем, сидит ли игрок в машине
            local seat = char.Humanoid.SeatPart
            if seat and seat:IsA("VehicleSeat") then
                -- Находим основную деталь кузова машины
                local carBody = seat.Parent.PrimaryPart or seat
                -- Если нажата кнопка газа (машина пытается ехать вперед)
                if seat.Throttle > 0 then
                    -- Добавляем физическое ускорение кузову вперед
                    carBody.AssemblyLinearVelocity = carBody.CFrame.LookVector * (seat.MaxSpeed * carSpeedMultiplier)
                end
            end
        end
    end
end)
