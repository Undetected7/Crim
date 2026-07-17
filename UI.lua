-- GRIMOIRE.CC - Features (принимает Config)
return function(Config)
    local Features = {}
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")

    local function NoFall(cfg)
        if not cfg or not cfg.Toggles.NoFall then return end
        local velocity = rootPart.Velocity
        if velocity.Y < -60 then
            task.wait(0.05)
            rootPart.Velocity = Vector3.new(velocity.X, -4, velocity.Z)
        end
    end

    local function InfiniteStamina(cfg)
        if not cfg or not cfg.Toggles.InfiniteStamina then return end
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

    local flyEnabled = false
    local function Fly(cfg)
        if not cfg then return end
        if not cfg.Toggles.Fly then
            flyEnabled = false
            humanoid.PlatformStand = false
            return
        end
        if not flyEnabled then
            flyEnabled = true
            humanoid.PlatformStand = true
            task.spawn(function()
                while flyEnabled and cfg.Toggles.Fly do
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
                        moveDirection = moveDirection.Unit * (cfg.Sliders.FlySpeed or 30) * 0.1
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

    local function ThirdPerson(cfg)
        if not cfg then return end
        if cfg.Toggles.ThirdPerson then
            workspace.CurrentCamera.FieldOfView = 120
        else
            workspace.CurrentCamera.FieldOfView = 70
        end
    end

    local function Fullbright(cfg)
        if not cfg then return end
        if cfg.Toggles.Fullbright then
            game:GetService("Lighting").Brightness = (cfg.Sliders.Brightness or 1) * 3 + 0.5
            game:GetService("Lighting").Ambient = Color3.new(1,1,1)
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").Ambient = Color3.new(0,0,0)
        end
    end

    function Features.Start(cfg)
        cfg = cfg or Config
        if not cfg then error("[GRIMOIRE] Features: Config не передан") end

        -- Бинды
        local Loader = _G.GRIMOIRE["Loader.lua"]
        if Loader and Loader.BindKey then
            Loader.BindKey(Enum.KeyCode.H, function()
                cfg.Toggles.Fly = not cfg.Toggles.Fly
                if not cfg.Toggles.Fly then
                    flyEnabled = false
                    humanoid.PlatformStand = false
                end
            end)
            Loader.BindKey(Enum.KeyCode.G, function()
                cfg.Toggles.ThirdPerson = not cfg.Toggles.ThirdPerson
            end)
        end

        task.spawn(function()
            while true do
                NoFall(cfg)
                InfiniteStamina(cfg)
                Fly(cfg)
                ThirdPerson(cfg)
                Fullbright(cfg)
                task.wait(0.1)
            end
        end)
    end

    return Features
end
