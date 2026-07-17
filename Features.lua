-- GRIMOIRE.CC - Features (принимает Config)
return function()
    local Features = {}
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    function Features.Start(Config)
        if not Config then error("Features: Config не передан") end

        local flyEnabled = false

        local function NoFall()
            if not Config.Toggles.NoFall then return end
            local velocity = rootPart.Velocity
            if velocity.Y < -60 then
                task.wait(0.05)
                rootPart.Velocity = Vector3.new(velocity.X, -4, velocity.Z)
            end
        end

        local function InfiniteStamina()
            if not Config.Toggles.InfiniteStamina then return end
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        local weight = item:FindFirstChild("Weight")
                        if weight then weight.Value = 0 end
                    end
                end
            end
            local equip = character:FindFirstChild("EquippedWeight")
            if equip then equip.Value = 0 end
        end

        local function Fly()
            if not Config.Toggles.Fly then
                flyEnabled = false
                humanoid.PlatformStand = false
                return
            end
            if not flyEnabled then
                flyEnabled = true
                humanoid.PlatformStand = true
                task.spawn(function()
                    while flyEnabled and Config.Toggles.Fly do
                        local cam = workspace.CurrentCamera
                        local moveDirection = Vector3.new(0,0,0)
                        local UIS = game:GetService("UserInputService")
                        if UIS:IsKeyDown(Enum.KeyCode.W) then
                            moveDirection = moveDirection + cam.CFrame.LookVector
                        end
                        if UIS:IsKeyDown(Enum.KeyCode.S) then
                            moveDirection = moveDirection - cam.CFrame.LookVector
                        end
                        if UIS:IsKeyDown(Enum.KeyCode.A) then
                            moveDirection = moveDirection - cam.CFrame.RightVector
                        end
                        if UIS:IsKeyDown(Enum.KeyCode.D) then
                            moveDirection = moveDirection + cam.CFrame.RightVector
                        end
                        if UIS:IsKeyDown(Enum.KeyCode.E) then
                            moveDirection = moveDirection + Vector3.new(0,1,0)
                        end
                        if UIS:IsKeyDown(Enum.KeyCode.Q) then
                            moveDirection = moveDirection - Vector3.new(0,1,0)
                        end
                        if moveDirection.Magnitude > 0 then
                            moveDirection = moveDirection.Unit * (Config.Sliders.FlySpeed or 30) * 0.1
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

        local function ThirdPerson()
            if Config.Toggles.ThirdPerson then
                workspace.CurrentCamera.FieldOfView = 120
            else
                workspace.CurrentCamera.FieldOfView = 70
            end
        end

        local function Fullbright()
            if Config.Toggles.Fullbright then
                game:GetService("Lighting").Brightness = (Config.Sliders.Brightness or 1) * 3 + 0.5
                game:GetService("Lighting").Ambient = Color3.new(1,1,1)
            else
                game:GetService("Lighting").Brightness = 1
                game:GetService("Lighting").Ambient = Color3.new(0,0,0)
            end
        end

        -- Бинды
        local Loader = _G.GRIMOIRE["Loader.lua"] -- или можно передать, но мы оставим как есть
        if Loader and Loader.BindKey then
            Loader.BindKey(Enum.KeyCode.H, function()
                Config.Toggles.Fly = not Config.Toggles.Fly
                if not Config.Toggles.Fly then
                    flyEnabled = false
                    humanoid.PlatformStand = false
                end
            end)
            Loader.BindKey(Enum.KeyCode.G, function()
                Config.Toggles.ThirdPerson = not Config.Toggles.ThirdPerson
            end)
        end

        task.spawn(function()
            while true do
                NoFall()
                InfiniteStamina()
                Fly()
                ThirdPerson()
                Fullbright()
                task.wait(0.1)
            end
        end)
    end

    return Features
end
