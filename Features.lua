-- GRIMOIRE.CC - Features
return function()
    local Features = {}
    local Config = _G.GRIMOIRE["Config.lua"]
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- No Fall Damage (мягкая подмена скорости)
    function Features.NoFall()
        if not Config.Toggles.NoFall then return end
        local velocity = rootPart.Velocity
        if velocity.Y < -60 then -- критическое падение
            task.wait(0.05) -- задержка перед ударом
            rootPart.Velocity = Vector3.new(velocity.X, -4, velocity.Z)
        end
    end
    
    -- Infinite Stamina (обнуление веса)
    function Features.InfiniteStamina()
        if not Config.Toggles.InfiniteStamina then return end
        -- поиск скрытых атрибутов (пример)
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    local weight = item:FindFirstChild("Weight")
                    if weight then
                        weight.Value = 0
                    end
                end
            end
        end
        -- также обнуляем EquippedWeight
        local equip = character:FindFirstChild("EquippedWeight")
        if equip then equip.Value = 0 end
    end
    
    -- Legit Fly Hack (плавный полет на CFrame)
    local flyEnabled = false
    function Features.Fly()
        if not Config.Toggles.Fly then
            flyEnabled = false
            return
        end
        if not flyEnabled then
            flyEnabled = true
            humanoid.PlatformStand = true
            task.spawn(function()
                while flyEnabled and Config.Toggles.Fly do
                    local cam = workspace.CurrentCamera
                    local moveDirection = Vector3.new(0,0,0)
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + cam.CFrame.LookVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection - cam.CFrame.LookVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection - cam.CFrame.RightVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + cam.CFrame.RightVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.E) then
                        moveDirection = moveDirection + Vector3.new(0,1,0)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Q) then
                        moveDirection = moveDirection - Vector3.new(0,1,0)
                    end
                    if moveDirection.Magnitude > 0 then
                        moveDirection = moveDirection.Unit * Config.Sliders.FlySpeed * 0.1
                        rootPart.CFrame = rootPart.CFrame + moveDirection
                    end
                    task.wait()
                end
            end)
        else
            flyEnabled = false
            humanoid.PlatformStand = false
        end
    end
    
    -- Smart Third Person (расширение FOV)
    function Features.ThirdPerson()
        if Config.Toggles.ThirdPerson then
            workspace.CurrentCamera.FieldOfView = 120
            -- дополнительно разлок дистанции (перехват Zoom)
        else
            workspace.CurrentCamera.FieldOfView = 70
        end
    end
    
    -- Fullbright (яркость)
    function Features.Fullbright()
        if Config.Toggles.Fullbright then
            game:GetService("Lighting").Brightness = Config.Sliders.Brightness
            game:GetService("Lighting").Ambient = Color3.new(1,1,1)
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").Ambient = Color3.new(0,0,0)
        end
    end
    
    -- Запуск цикла фич
    function Features.Start()
        task.spawn(function()
            while true do
                Features.NoFall()
                Features.InfiniteStamina()
                Features.Fly()
                Features.ThirdPerson()
                Features.Fullbright()
                task.wait(0.1)
            end
        end)
        
        -- Бинды
        _G.GRIMOIRE["Loader.lua"].BindKey(Enum.KeyCode.H, function()
            Config.Toggles.Fly = not Config.Toggles.Fly
            if not Config.Toggles.Fly then
                flyEnabled = false
                humanoid.PlatformStand = false
            end
        end)
        _G.GRIMOIRE["Loader.lua"].BindKey(Enum.KeyCode.G, function()
            Config.Toggles.ThirdPerson = not Config.Toggles.ThirdPerson
        end)
    end
    
    return Features
end