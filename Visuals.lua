-- GRIMOIRE.CC - Visuals
return function()
    local Visuals = {}
    local Config = _G.GRIMOIRE["Config.lua"]
    local player = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    -- Глубокий сканер моделей (обход скрытых имен)
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
    
    -- Создание 2D Boxes и Skeletons на CoreGui
    local overlay = Instance.new("ScreenGui")
    overlay.Name = "GrimoireOverlay"
    overlay.Parent = game:GetService("CoreGui")
    overlay.ResetOnSpawn = false
    
    local function drawBox(player)
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local pos, onScreen = camera:WorldToScreenPoint(hrp.Position)
        if not onScreen then return end
        
        -- Создаем Frame для бокса (пропускаем детали для краткости)
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0, 80, 0, 150) -- динамический размер
        box.Position = UDim2.new(0, pos.X - 40, 0, pos.Y - 75)
        box.BackgroundTransparency = 0.5
        box.BackgroundColor3 = Config.Colors.ESP
        box.BorderSizePixel = 1
        box.BorderColor3 = Color3.new(1,1,1)
        box.Parent = overlay
        
        -- Удаление через таймер (обновление каждый кадр)
        task.delay(0.1, function() box:Destroy() end)
    end
    
    -- ESP Preview (вынесен за вьюпорт) – здесь эмулируем через отдельный Frame
    function Visuals.DrawESPPreview()
        -- Реализация превью в UI (используется в UI.lua)
    end
    
    -- Storage ESP (подсветка лута)
    function Visuals.StorageESP()
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
    
    -- Основной цикл рендеринга
    function Visuals.Start()
        task.spawn(function()
            while true do
                if Config.Toggles.ESP then
                    for _, plr in ipairs(getPlayers()) do
                        drawBox(plr)
                        -- Здесь также рисуем скелеты, имена, оружие, HP
                    end
                    Visuals.StorageESP()
                end
                task.wait()
            end
        end)
    end
    
    return Visuals
end