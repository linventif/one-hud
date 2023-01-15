local theme = {
    ["sentro"] = {
        ["background"] = Color(55, 55, 55),
        ["icon"] = Color(156, 156, 156),
        ["text"] = Color(255, 255, 255),
        ["text_background"] = Color(83, 83, 83),
        ["health"] = {
            ["front"] = Color(190, 68, 68),
            ["back"] = Color(121, 45, 45)
        },
        ["armor"] = {
            ["front"] = Color(68, 125, 190),
            ["back"] = Color(45, 63, 121)
        },
        ["food"] = {
            ["front"] = Color(190, 162, 68),
            ["back"] = Color(121, 107, 45)
        },
        ["level"] = {
            ["front"] = Color(121, 73, 175),
            ["back"] = Color(92, 49, 141)
        },
        ["props"] = {
            ["front"] = Color(73, 175, 81),
            ["back"] = Color(36, 104, 42)
        },
        ["ammo"] = {
            ["front"] = Color(175, 97, 61),
            ["back"] = Color(138, 71, 32)
        },
        ["spe_ammo"] = {
            ["front"] = Color(175, 61, 61),
            ["back"] = Color(138, 32, 32)
        },
        ["ping"] = {
            ["good"] = Color(73, 175, 81),
            ["medium"] = Color(175, 97, 61),
            ["bad"] = Color(175, 61, 61)
        },
        ["wanted"] = Color(190, 68, 68),
        ["license"] = Color(68, 107, 190)
    }
}

OneHud.Config.Color = theme[OneHud.Config.ThemeColor] || theme["sentro"]