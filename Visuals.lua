-- GRIMOIRE.CC - Visuals (принимает Config)
return function()
    local Visuals = {}
    local player = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera

    function Visuals.Start(Config)
        if not Config then error("Visuals: Config не передан") end

        local overlay = Instance.new("ScreenGui")
        overlay.Name = "GrimoireOverlay"
        overlay.Parent = game:GetService("CoreGui")
        overlay.ResetOnSpawn = false

        local function getPlayers()
            local list = {}
            for _, model in ipairs(workspace:GetChildren()) do
                if model:IsA("Model") and model:FindFirstChild("Humanoid") then
                    local plr = game.Players:GetPlayerFromCharacter(model)
                    if plr and plr ~= player then
                        table.insert(list, plr)
                    end
                end
            end
            return list
        end

        local function drawBox(plr, color)
            local char = plr.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local pos, onScreen = camera:WorldToScreenPoint(hrp.Position)
            if not onScreen then return end

            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, 80, 0, 150)
            box.Position = UDim2.new(0, pos.X - 40, 0, pos.Y - 75)
            box.BackgroundTransparency = 0.5
            box.BackgroundColor3 = color or Color3.new(1,0,0)
            box.BorderSizePixel = 1
            box.BorderColor3 = Color3.new(1,1,1)
            box.Parent = overlay
            task.delay(0.1, function() box:Destroy() end)
        end

        local function StorageESP()
            if not Config.Toggles.Storage then return end
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("Part") and obj.Name:match("Safe|Cash|Crate") then
                    local highlight = Instance.new("Highlight")
                    highlight.Adornee = obj
                    highlight.FillColor = Color3.fromRGB(0,255,0)
                    highlight.Parent = obj
                    task.delay(1, function() highlight:Destroy() end)
                end
            end
        end

        task.spawn(function()
            while true do
                if Config.Toggles.ESP then
                    local color = Config.Colors.ESP or Color3.new(1,0,0)
                    for _, plr in ipairs(getPlayers()) do
                        drawBox(plr, color)
                    end
                    StorageESP()
                end
                task.wait()
            end
        end)
    end

    return Visuals
end
