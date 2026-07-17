-- GRIMOIRE.CC - Config
return function()
    local Config = {
        Toggles = {
            ESP = true,
            Boxes = true,
            Skeletons = true,
            Names = true,
            Health = true,
            Weapon = true,
            Storage = true,
            Fullbright = false,
            NoFall = true,
            InfiniteStamina = true,
            Fly = false,
            ThirdPerson = false,
        },
        Colors = {
            ESP = Color3.fromHSV(0, 1, 1), -- красный
            Chams = Color3.fromHSV(0.5, 1, 1), -- синий
        },
        Binds = {
            ToggleMenu = Enum.KeyCode.Insert,
            Fly = Enum.KeyCode.H,
            ThirdPerson = Enum.KeyCode.G,
        },
        Sliders = {
            Brightness = 1,
            FlySpeed = 30,
        },
        Players = {}, -- список друзей (заполняется динамически)
    }
    return Config
end