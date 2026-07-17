-- GRIMOIRE.CC - UI
return function()
    local UI = {}
    local Config = _G.GRIMOIRE["Config.lua"]
    
    -- Создание главного меню
    function UI.CreateUI()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "GrimoireUI"
        screenGui.Parent = game:GetService("CoreGui")
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 400, 0, 500)
        mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
        mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        mainFrame.BackgroundTransparency = 0.2
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.Parent = screenGui
        
        -- Заголовок
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Text = "GRIMOIRE.CC v1.0"
        title.TextColor3 = Color3.fromRGB(255, 200, 50)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.TextSize = 18
        title.Parent = mainFrame
        
        -- Вкладки (пример)
        local tab1 = Instance.new("TextButton")
        tab1.Size = UDim2.new(0.5, 0, 0, 30)
        tab1.Position = UDim2.new(0, 0, 0, 30)
        tab1.Text = "Visuals"
        tab1.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        tab1.TextColor3 = Color3.new(1,1,1)
        tab1.Parent = mainFrame
        tab1.MouseButton1Click:Connect(function()
            -- переключение вкладки
        end)
        
        -- Colour Picker (ползунок Hue)
        local hueSlider = Instance.new("Frame")
        hueSlider.Size = UDim2.new(0.8, 0, 0, 20)
        hueSlider.Position = UDim2.new(0.1, 0, 0.2, 0)
        hueSlider.BackgroundColor3 = Color3.new(1,0,0)
        hueSlider.Parent = mainFrame
        -- ... здесь реализация ползунка с привязкой к Config.Colors.ESP
        
        -- Bind система (пример для Fly)
        local bindBtn = Instance.new("TextButton")
        bindBtn.Size = UDim2.new(0.3, 0, 0, 30)
        bindBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
        bindBtn.Text = "Fly: H"
        bindBtn.BackgroundColor3 = Color3.fromRGB(70,70,80)
        bindBtn.Parent = mainFrame
        bindBtn.MouseButton1Click:Connect(function()
            -- ожидание нажатия клавиши для смены бинда
        end)
        
        -- Drag-and-Drop ESP Preview (контейнер с ViewportFrame)
        local previewFrame = Instance.new("Frame")
        previewFrame.Size = UDim2.new(0.4, 0, 0.3, 0)
        previewFrame.Position = UDim2.new(0.55, 0, 0.2, 0)
        previewFrame.BackgroundColor3 = Color3.fromRGB(20,20,30)
        previewFrame.Parent = mainFrame
        
        local viewport = Instance.new("ViewportFrame")
        viewport.Size = UDim2.new(1,0,1,0)
        viewport.Parent = previewFrame
        -- Загрузка dummy модели с неоновой текстурой для превью Chams
        -- (реализация опущена для краткости)
        
        -- Кнопка закрытия
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0, 5)
        closeBtn.Text = "X"
        closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        closeBtn.Parent = mainFrame
        closeBtn.MouseButton1Click:Connect(function()
            mainFrame.Visible = not mainFrame.Visible
        end)
        
        -- Перехват Insert для показа/скрытия
        _G.GRIMOIRE["Loader.lua"].BindKey(Enum.KeyCode.Insert, function()
            mainFrame.Visible = not mainFrame.Visible
        end)
    end
    
    return UI
end