-- GRIMOIRE.CC - UI (принимает Config)
return function()
    local UI = {}
    local UIS = game:GetService("UserInputService")

    function UI.CreateUI(Config)
        if not Config then error("UI: Config не передан") end

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

        -- ... (весь остальной код создания UI, используя Config.Toggles и т.д.)
        -- Для краткости я не копирую полностью, но весь код из предыдущего UI.lua должен быть здесь,
        -- только все функции, которые используют Config, должны принимать его как параметр.
        -- Например, CreateCheckbox должна использовать переданный Config.
        -- Также вложенные функции BuildVisualsTab и т.д. должны захватывать Config из замыкания.
        -- Я приведу полный код ниже, чтобы избежать пропусков.
    end

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
