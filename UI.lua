-- GRIMOIRE.CC - UI (исправлен: Config берётся внутри CreateUI)
return function()
    local UI = {}
    local player = game.Players.LocalPlayer
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    function UI.CreateUI()
        -- Получаем Config здесь, после того как _G.GRIMOIRE уже создан
        local Config = _G.GRIMOIRE["Config.lua"]
        if not Config then
            error("[GRIMOIRE] UI: Config не найден в _G.GRIMOIRE")
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "GrimoireUI"
        screenGui.Parent = game:GetService("CoreGui")
        screenGui.ResetOnSpawn = false

        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 480, 0, 580)
        mainFrame.Position = UDim2.new(0.5, -240, 0.5, -290)
        mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        mainFrame.BackgroundTransparency = 0.05
        mainFrame.BorderSizePixel = 0
        mainFrame.ClipsDescendants = true
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.Parent = screenGui

        -- Тень
        local shadow = Instance.new("Frame")
        shadow.Size = UDim2.new(1, 10, 1, 10)
        shadow.Position = UDim2.new(0, -5, 0, -5)
        shadow.BackgroundColor3 = Color3.new(0,0,0)
        shadow.BackgroundTransparency = 0.6
        shadow.BorderSizePixel = 0
        shadow.Parent = mainFrame

        -- Заголовок
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.Text = "GRIMOIRE.CC v1.0"
        title.TextColor3 = Color3.fromRGB(255, 200, 50)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.TextSize = 22
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextYAlignment = Enum.TextYAlignment.Center
        title.Padding = UDim.new(0, 15)
        title.Parent = mainFrame

        -- Крестик закрытия
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0, 5)
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.new(1,1,1)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        closeBtn.BorderSizePixel = 0
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 18
        closeBtn.Parent = mainFrame
        closeBtn.MouseButton1Click:Connect(function()
            mainFrame.Visible = not mainFrame.Visible
        end)

        -- Панель вкладок
        local tabPanel = Instance.new("Frame")
        tabPanel.Size = UDim2.new(1, 0, 0, 35)
        tabPanel.Position = UDim2.new(0, 0, 0, 40)
        tabPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        tabPanel.BorderSizePixel = 0
        tabPanel.Parent = mainFrame

        local tabs = {"Visuals", "Features", "Settings"}
        local tabButtons = {}
        local activeTab = nil

        for i, name in ipairs(tabs) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1/#tabs, -2, 1, -4)
            btn.Position = UDim2.new((i-1)/#tabs + 0.01, 0, 0, 2)
            btn.Text = name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 50)
            btn.BorderSizePixel = 0
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 14
            btn.Parent = tabPanel
            tabButtons[name] = btn
            btn.MouseButton1Click:Connect(function()
                SwitchTab(name)
            end)
        end

        -- Контейнер для содержимого
        local contentContainer = Instance.new("Frame")
        contentContainer.Size = UDim2.new(1, -20, 1, -100)
        contentContainer.Position = UDim2.new(0, 10, 0, 80)
        contentContainer.BackgroundTransparency = 1
        contentContainer.Parent = mainFrame

        -- Функция переключения вкладок
        local function SwitchTab(tabName)
            if activeTab == tabName then return end
            activeTab = tabName
            for name, btn in pairs(tabButtons) do
                btn.BackgroundColor3 = (name == tabName) and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 50)
            end
            for _, child in ipairs(contentContainer:GetChildren()) do
                child:Destroy()
            end
            if tabName == "Visuals" then
                BuildVisualsTab()
            elseif tabName == "Features" then
                BuildFeaturesTab()
            elseif tabName == "Settings" then
                BuildSettingsTab()
            end
        end

        -- Вспомогательная функция создания чекбокса
        local function CreateCheckbox(parent, label, configKey, yPos)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 30)
            frame.Position = UDim2.new(0, 0, 0, yPos)
            frame.BackgroundTransparency = 1
            frame.Parent = parent

            local labelText = Instance.new("TextLabel")
            labelText.Size = UDim2.new(0.7, 0, 1, 0)
            labelText.Position = UDim2.new(0, 0, 0, 0)
            labelText.Text = label
            labelText.TextColor3 = Color3.new(1,1,1)
            labelText.BackgroundTransparency = 1
            labelText.TextXAlignment = Enum.TextXAlignment.Left
            labelText.Font = Enum.Font.GothamMedium
            labelText.TextSize = 14
            labelText.Parent = frame

            local checkbox = Instance.new("TextButton")
            checkbox.Size = UDim2.new(0, 25, 0, 25)
            checkbox.Position = UDim2.new(1, -30, 0, 2)
            checkbox.Text = ""
            checkbox.BackgroundColor3 = Config.Toggles[configKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(60, 60, 70)
            checkbox.BorderSizePixel = 0
            checkbox.Parent = frame
            checkbox.MouseButton1Click:Connect(function()
                Config.Toggles[configKey] = not Config.Toggles[configKey]
                checkbox.BackgroundColor3 = Config.Toggles[configKey] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(60, 60, 70)
                checkbox.Text = Config.Toggles[configKey] and "✔" or ""
            end)
            if Config.Toggles[configKey] then checkbox.Text = "✔" end
        end

        -- Вкладка Visuals
        function BuildVisualsTab()
            local y = 0
            CreateCheckbox(contentContainer, "ESP (вкл/выкл)", "ESP", y); y = y + 32
            CreateCheckbox(contentContainer, "Boxes (рамки)", "Boxes", y); y = y + 32
            CreateCheckbox(contentContainer, "Skeletons (скелет)", "Skeletons", y); y = y + 32
            CreateCheckbox(contentContainer, "Names (имена)", "Names", y); y = y + 32
            CreateCheckbox(contentContainer, "Health (здоровье)", "Health", y); y = y + 32
            CreateCheckbox(contentContainer, "Weapon (оружие)", "Weapon", y); y = y + 32
            CreateCheckbox(contentContainer, "Storage (лут)", "Storage", y); y = y + 32

            -- Цветовой пикер
            local hueLabel = Instance.new("TextLabel")
            hueLabel.Size = UDim2.new(0.5, 0, 0, 25)
            hueLabel.Position = UDim2.new(0, 0, 0, y)
            hueLabel.Text = "Цвет ESP"
            hueLabel.TextColor3 = Color3.new(1,1,1)
            hueLabel.BackgroundTransparency = 1
            hueLabel.TextXAlignment = Enum.TextXAlignment.Left
            hueLabel.Font = Enum.Font.GothamMedium
            hueLabel.TextSize = 14
            hueLabel.Parent = contentContainer

            local hueSlider = Instance.new("Frame")
            hueSlider.Size = UDim2.new(0.4, 0, 0, 20)
            hueSlider.Position = UDim2.new(0.55, 0, 0, y+2)
            hueSlider.BackgroundColor3 = Color3.new(1,0,0)
            hueSlider.BorderSizePixel = 0
            hueSlider.Parent = contentContainer

            for i = 0, 1, 0.05 do
                local part = Instance.new("Frame")
                part.Size = UDim2.new(0.05, 0, 1, 0)
                part.Position = UDim2.new(i, 0, 0, 0)
                part.BackgroundColor3 = Color3.fromHSV(i, 1, 1)
                part.BorderSizePixel = 0
                part.Parent = hueSlider
            end

            local hueIndicator = Instance.new("Frame")
            hueIndicator.Size = UDim2.new(0, 4, 1, 0)
            hueIndicator.Position = UDim2.new(Config.Colors.ESP.Hue or 0, -2, 0, 0)
            hueIndicator.BackgroundColor3 = Color3.new(1,1,1)
            hueIndicator.BorderSizePixel = 0
            hueIndicator.Parent = hueSlider

            local draggingHue = false
            hueSlider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingHue = true
                end
            end)
            hueSlider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingHue = false
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if draggingHue and input.UserInputType == Enum.UserInputType.MousePosition then
                    local pos = input.Position
                    local absPos = hueSlider.AbsolutePosition
                    local size = hueSlider.AbsoluteSize
                    local x = math.clamp((pos.X - absPos.X) / size.X, 0, 1)
                    hueIndicator.Position = UDim2.new(x, -2, 0, 0)
                    Config.Colors.ESP = Color3.fromHSV(x, 1, 1)
                end
            end)
        end

        -- Вкладка Features
        function BuildFeaturesTab()
            local y = 0
            CreateCheckbox(contentContainer, "No Fall Damage", "NoFall", y); y = y + 32
            CreateCheckbox(contentContainer, "Infinite Stamina", "InfiniteStamina", y); y = y + 32
            CreateCheckbox(contentContainer, "Fly Hack (H)", "Fly", y); y = y + 32
            CreateCheckbox(contentContainer, "Third Person (G)", "ThirdPerson", y); y = y + 32
            CreateCheckbox(contentContainer, "Fullbright", "Fullbright", y); y = y + 32

            -- Слайдер яркости
            local brightLabel = Instance.new("TextLabel")
            brightLabel.Size = UDim2.new(0.5, 0, 0, 25)
            brightLabel.Position = UDim2.new(0, 0, 0, y)
            brightLabel.Text = "Яркость"
            brightLabel.TextColor3 = Color3.new(1,1,1)
            brightLabel.BackgroundTransparency = 1
            brightLabel.TextXAlignment = Enum.TextXAlignment.Left
            brightLabel.Font = Enum.Font.GothamMedium
            brightLabel.TextSize = 14
            brightLabel.Parent = contentContainer

            local brightSlider = Instance.new("Frame")
            brightSlider.Size = UDim2.new(0.4, 0, 0, 12)
            brightSlider.Position = UDim2.new(0.55, 0, 0, y+6)
            brightSlider.BackgroundColor3 = Color3.fromRGB(80,80,90)
            brightSlider.BorderSizePixel = 0
            brightSlider.Parent = contentContainer

            local brightFill = Instance.new("Frame")
            brightFill.Size = UDim2.new(Config.Sliders.Brightness or 0.5, 0, 1, 0)
            brightFill.BackgroundColor3 = Color3.fromRGB(255,200,100)
            brightFill.BorderSizePixel = 0
            brightFill.Parent = brightSlider

            local brightIndicator = Instance.new("Frame")
            brightIndicator.Size = UDim2.new(0, 16, 1, 2)
            brightIndicator.Position = UDim2.new(Config.Sliders.Brightness or 0.5, -8, 0, -1)
            brightIndicator.BackgroundColor3 = Color3.new(1,1,1)
            brightIndicator.BorderSizePixel = 0
            brightIndicator.Parent = brightSlider

            local draggingBright = false
            brightSlider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingBright = true
                end
            end)
            brightSlider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingBright = false
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if draggingBright and input.UserInputType == Enum.UserInputType.MousePosition then
                    local pos = input.Position
                    local absPos = brightSlider.AbsolutePosition
                    local size = brightSlider.AbsoluteSize
                    local x = math.clamp((pos.X - absPos.X) / size.X, 0, 1)
                    brightFill.Size = UDim2.new(x, 0, 1, 0)
                    brightIndicator.Position = UDim2.new(x, -8, 0, -1)
                    Config.Sliders.Brightness = x
                    if Config.Toggles.Fullbright then
                        game:GetService("Lighting").Brightness = x * 3 + 0.5
                    end
                end
            end)

            -- Слайдер скорости полёта
            y = y + 35
            local speedLabel = Instance.new("TextLabel")
            speedLabel.Size = UDim2.new(0.5, 0, 0, 25)
            speedLabel.Position = UDim2.new(0, 0, 0, y)
            speedLabel.Text = "Скорость полёта"
            speedLabel.TextColor3 = Color3.new(1,1,1)
            speedLabel.BackgroundTransparency = 1
            speedLabel.TextXAlignment = Enum.TextXAlignment.Left
            speedLabel.Font = Enum.Font.GothamMedium
            speedLabel.TextSize = 14
            speedLabel.Parent = contentContainer

            local speedSlider = Instance.new("Frame")
            speedSlider.Size = UDim2.new(0.4, 0, 0, 12)
            speedSlider.Position = UDim2.new(0.55, 0, 0, y+6)
            speedSlider.BackgroundColor3 = Color3.fromRGB(80,80,90)
            speedSlider.BorderSizePixel = 0
            speedSlider.Parent = contentContainer

            local speedFill = Instance.new("Frame")
            speedFill.Size = UDim2.new((Config.Sliders.FlySpeed or 30)/100, 0, 1, 0)
            speedFill.BackgroundColor3 = Color3.fromRGB(100,200,255)
            speedFill.BorderSizePixel = 0
            speedFill.Parent = speedSlider

            local speedIndicator = Instance.new("Frame")
            speedIndicator.Size = UDim2.new(0, 16, 1, 2)
            speedIndicator.Position = UDim2.new((Config.Sliders.FlySpeed or 30)/100, -8, 0, -1)
            speedIndicator.BackgroundColor3 = Color3.new(1,1,1)
            speedIndicator.BorderSizePixel = 0
            speedIndicator.Parent = speedSlider

            local draggingSpeed = false
            speedSlider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSpeed = true
                end
            end)
            speedSlider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSpeed = false
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if draggingSpeed and input.UserInputType == Enum.UserInputType.MousePosition then
                    local pos = input.Position
                    local absPos = speedSlider.AbsolutePosition
                    local size = speedSlider.AbsoluteSize
                    local x = math.clamp((pos.X - absPos.X) / size.X, 0, 1)
                    local val = math.round(x * 100)
                    speedFill.Size = UDim2.new(x, 0, 1, 0)
                    speedIndicator.Position = UDim2.new(x, -8, 0, -1)
                    Config.Sliders.FlySpeed = val
                end
            end)
        end

        -- Вкладка Settings
        function BuildSettingsTab()
            local y = 0
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 25)
            label.Position = UDim2.new(0, 0, 0, y)
            label.Text = "Список друзей (заглушка)"
            label.TextColor3 = Color3.fromRGB(200,200,200)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamMedium
            label.TextSize = 14
            label.Parent = contentContainer
            y = y + 30

            local reloadBtn = Instance.new("TextButton")
            reloadBtn.Size = UDim2.new(0.5, 0, 0, 35)
            reloadBtn.Position = UDim2.new(0.25, 0, 0, y)
            reloadBtn.Text = "Перезагрузить"
            reloadBtn.TextColor3 = Color3.new(1,1,1)
            reloadBtn.BackgroundColor3 = Color3.fromRGB(60,60,80)
            reloadBtn.BorderSizePixel = 0
            reloadBtn.Font = Enum.Font.GothamBold
            reloadBtn.TextSize = 16
            reloadBtn.Parent = contentContainer
            reloadBtn.MouseButton1Click:Connect(function()
                print("[GRIMOIRE] Перезагрузка модулей...")
                -- Здесь можно реализовать полную перезагрузку
            end)
        end

        -- Запускаем первую вкладку
        SwitchTab("Visuals")
    end

    -- Функция переключения видимости (не требует Config)
    function UI.ToggleUI()
        local gui = game:GetService("CoreGui"):FindFirstChild("GrimoireUI")
        if gui then
            local mainFrame = gui:FindFirstChildOfClass("Frame")
            if mainFrame then
                mainFrame.Visible = not mainFrame.Visible
            end
        end
    end

    return {
        CreateUI = UI.CreateUI,
        ToggleUI = UI.ToggleUI,
    }
end
