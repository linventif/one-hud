OneHud.Config = OneHud.Config or {}

// Main Settings
OneHud.Config.HUD = "Simple" // HUD Style (Simple, Horizontal, Vertical)

// What should be shown
OneHud.Config.Text = true // Show Text
OneHud.Config.Icon = true // Show Icon

// Order of the elements remove for hide
// Elements: Health, Armor, Money, Food, Team
OneHud.Config.Order = {
    "Team",
    "Money",
    "Health",
    "Armor",
    "Food",
    "Ammo",
}

// Bar HUD Settings
OneHud.Config.HeightSpacing = 6 // Spacing between the bars -6 to collapse them

// Money Settings
OneHud.Config.MoneyLeft = false // Show Money on Left of the money amount
OneHud.Config.Money = "dollar" // Money Format
OneHud.Config.MoneySymbol = "€" // Money Symbol
OneHud.Config.MoneySeparator = " " // Money Separator
OneHud.Config.Salary = true // Show Salary

// Main Color Settings
OneHud.Config.BackColor = Color(48, 48, 48) // Main Background Color
OneHud.Config.TextColor = Color(255, 255, 255) // Text Color
OneHud.Config.TextBackColor = Color(83, 83, 83)

// Health Colors Settings
OneHud.Config.HealthColor = Color(190, 68, 68) // Health Color
OneHud.Config.HealthBackColor = Color(121, 45, 45) // Health Background Color

// Armor Colors Settings
OneHud.Config.ArmorColor = Color(68, 125, 190) // Armor Color
OneHud.Config.ArmorBackColor = Color(45, 63, 121) // Armor Background Color

// Food Colors Settings
OneHud.Config.FoodColor = Color(190, 162, 68) // Food Color
OneHud.Config.FoodBackColor = Color(121, 107, 45) // Food Background Color

// Money Colors Settings
OneHud.Config.MoneyColor = OneHud.Config.TextColor // Money Color
OneHud.Config.MoneyBackColor = OneHud.Config.TextBackColor // Money Background Color

// Salary Colors Settings
OneHud.Config.SalaryColor = OneHud.Config.TextColor // Salary Color
OneHud.Config.SalaryBackColor = OneHud.Config.TextBackColor // Salary Background Color

// Team Colors Settings
OneHud.Config.TeamColor = OneHud.Config.TextColor // Team Color
OneHud.Config.TeamBackColor = OneHud.Config.TextBackColor // Team Background Color

// Main Advenced Settings
OneHud.Config.BackGroundBar = true // Show Background Bar
OneHud.Config.TextFont = "Trebuchet24" // Text Font
OneHud.Config.FontLiveTest = false // Font Live Test (Consumes a lot of FPS do not let in true)
OneHud.Config.TextSize = 20 // Text Size