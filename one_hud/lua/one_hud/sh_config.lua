OneHud.Config = OneHud.Config or {}

// Main Settings
OneHud.Config.HUD = "Flat" // HUD Style (Flat - Flat Bar)
OneHud.Config.Responsive = true // HUD Responsive
OneHud.Config.TalkIcon = true // Talk Icon

// What should be shown
OneHud.Config.Text = true // Show Text
OneHud.Config.Icon = true // Show Icon
OneHud.Config.ArmorWhenNone = true // Show Armor when you have none
OneHud.Config.PropsWhenNone = false // Show Props when you have none
OneHud.Config.SpeAmmoWhenNone = false // Show Special Ammo when you have none

// Order of the elements remove for hide
// Elements: Health, Armor, Money, Food, Team, Level, Name, Props, Group, Rank, Special Ammo, Weapon
// Level is only compatible with https://github.com/uen/Leveling-System
// Props is only compatible with Linventif Prop Limit https://github.com/linventif/gmod-scripts
// Rank is only compatible with Linventif Rank System (in development)
OneHud.Config.Order = {
    "Name",
    //"Group",
    "Team",
    "Money",
    //"Weapon",
    "Health",
    "Armor",
    //"Food",
    "Level",
    "Props",
    "Ammo",
    "Special Ammo"
}

// Possition of the elements (left, right) only for Flat Theme
OneHud.Config.Possition = {
    ["Name"] = "right",
    ["Group"] = "right",
    ["Team"] = "right",
    ["Money"] = "right",
    ["Weapon"] = "right",
    ["Health"] = "left",
    ["Armor"] = "left",
    ["Food"] = "left",
    ["Level"] = "left",
    ["Props"] = "left",
    ["Ammo"] = "right",
    ["Special Ammo"] = "right"
}

// Weapon to not show ammo
OneHud.Config.HideAmmoWeps = {
    ["weapon_physcannon"] = true
}

// Weapon Name
OneHud.Config.WepsName = {
    ["weapon_physcannon"] = "Gravity Gun"
}

// Groups Name to show
OneHud.Config.Groups = {
    ["superadmin"] = "Super Admin",
    ["admin"] = "Admin",
    ["moderator"] = "Moderator",
    ["operator"] = "Operator",
    ["user"] = "User"
}

// Money Settings
OneHud.Config.MoneyLeft = false // Show Money on Left of the money amount
OneHud.Config.Money = "dollar" // Money Format
OneHud.Config.MoneySymbol = "€" // Money Symbol
OneHud.Config.MoneySeparator = " " // Money Separator
OneHud.Config.Salary = true // Show Salary

// Main Color Settings
OneHud.Config.BackColor = Color(48, 48, 48) // Main Background Color
OneHud.Config.IconColor = Color(156, 156, 156) // Icon Color Modificator
OneHud.Config.TextColor = Color(255, 255, 255) // Text Color
OneHud.Config.TextBackColor = Color(83, 83, 83) // Text Background Color

// Health Colors Settings
OneHud.Config.HealthColor = Color(190, 68, 68) // Health Color
OneHud.Config.HealthBackColor = Color(121, 45, 45) // Health Background Color

// Armor Colors Settings
OneHud.Config.ArmorColor = Color(68, 125, 190) // Armor Color
OneHud.Config.ArmorBackColor = Color(45, 63, 121) // Armor Background Color

// Food Colors Settings
OneHud.Config.FoodColor = Color(190, 162, 68) // Food Color
OneHud.Config.FoodBackColor = Color(121, 107, 45) // Food Background Color

// Level Colors Settings
OneHud.Config.LevelColor = Color(121, 73, 175) // Level Color
OneHud.Config.LevelBackColor = Color(92, 49, 141) // Level Background Color

// Props Colors Settings
OneHud.Config.PropsColor = Color(73, 175, 81) // Props Color
OneHud.Config.PropsBackColor = Color(36, 104, 42) // Props Background Color

// Ammo Colors Settings
OneHud.Config.AmmoColor = Color(175, 97, 61) // Ammo Color
OneHud.Config.AmmoBackColor = Color(138, 71, 32) // Ammo Background Color

// Special Ammo Colors Settings
OneHud.Config.SpeAmmoColor = Color(175, 61, 61) // Special Ammo Color
OneHud.Config.SpeAmmoBackColor = Color(138, 32, 32) // Special Ammo Background Color

// Main Advenced Settings
OneHud.Config.BackGroundBar = true // Show Background Bar
OneHud.Config.TextFont = "Trebuchet24" // Text Font
OneHud.Config.FontLiveTest = false // Font Live Test (Consumes a lot of FPS do not let in true)
OneHud.Config.TextSize = 20 // Text Size
OneHud.Config.HeightSpacing = 6 // Spacing between the bars -6 to collapse them
OneHud.Config.WidthSpacing = 6 // Spacing between the bars -6 to collapse them
OneHud.Config.AlwayText = { // Always show the elements in the order
    ["Name"] = true,
    ["Group"] = true,
    ["Team"] = true,
    ["Money"] = true,
    ["Weapon"] = true,
    ["Ammo"] = true,
    ["Special Ammo"] = true,
    ["Level"] = true
}