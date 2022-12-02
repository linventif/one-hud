// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//            General Settings            //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

// Main Settings
OneHud.Config.Theme = "Flat" // HUD Theme (Flat - Flat Bar)
OneHud.Config.Responsive = false // HUD Responsive
OneHud.Config.TalkIcon = true // Talk Icon
OneHud.Config.RoundValue = 8 // Round Value (0 - 2)

// What should be shown
OneHud.Config.Text = true // Show Text
OneHud.Config.MaxValue = false // Show Max Value if set false you will be modify the width space of the bar in Themes Settings
OneHud.Config.Icon = true // Show Icon
OneHud.Config.ArmorWhenNone = false // Show Armor when you have none
OneHud.Config.PropsWhenNone = false // Show Props when you have none
OneHud.Config.SpeAmmoWhenNone = false // Show Special Ammo when you have none
OneHud.Config.LicenseWhenNone = true // Show License when you have none

// Order of the elements remove for hide
// Elements: Health, Armor, Money, Food, Team, Level, Name, Props, Group, Rank, Special Ammo, Weapon, Ping, Wanted, License
OneHud.Config.Order = {
    "Name",
//    "Group",
//    "Weapon",
    "Health",
    "Armor",
    "Food",
    "Props", // only compatible with Linventif Prop Limit https://github.com/linventif/gmod-scripts
    "Level", // Level Settings only compatible with https://github.com/uen/Leveling-System and https://github.com/GlorifiedPig/GlorifiedLeveling
    "Rank", // only compatible with Linventif Rank System (in development)
    "Team",
    "Ammo",
    "Special Ammo",
    "Ping", // only compatible with the theme : flat bar
    "Wanted",
    "License",
    "Money",
}

// Money Settings
OneHud.Config.MoneyLeft = false // Show Money on Left of the money amount
OneHud.Config.Money = "dollar" // Money Format
OneHud.Config.MoneySymbol = "€" // Money Symbol
OneHud.Config.MoneySeparator = " " // Money Separator
OneHud.Config.Salary = true // Show Salary

// Ping Settings
OneHud.Config.PingGood = 100 // Ping Good
OneHud.Config.PingBad = 200 // Ping Bad

 // Command to open the HUD Settings
OneHud.Config.Command = {
    ["!hud"] = true,
    ["/hud"] = true,
    ["!onehud"] = true,
    ["/onehud"] = true,
    ["!onehudsettings"] = true,
    ["/onehudsettings"] = true,
    ["!onehudconfig"] = true,
    ["/onehudconfig"] = true,
    ["!onehud_settings"] = true,
    ["/onehud_settings"] = true,
    ["!onehud_config"] = true,
    ["/onehud_config"] = true,
    ["!onehud-settings"] = true,
    ["/onehud-settings"] = true,
    ["!onehud-config"] = true,
    ["/onehud-config"] = true,
}

// Possition of the elements (left, right)
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
    ["weapon_physcannon"] = true,
    ["weapon_bugbait"] = true,
}

// Weapon Name to show
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

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//             Themes Settings            //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

// -- //
// Theme Settings : Flat
// -- //

// -- //
// Theme Settings : Flat Bar
// -- //

OneHud.Config.HeightSpacingFlatBar = 6 // Spacing of padding between the bars and the text
OneHud.Config.WidthSpacing = 20 // Spacing ellement of the horizontal bar
OneHud.Config.FlatBarMessage = "dsc.gg/linventif" // Message for on the Flat Bar Theme

// Multiplier of the spacing
OneHud.Config.MoreSpace = {
    ["Level"] = 3,
    ["Name"] = 3,
    ["Team"] = 3,
    ["Ping"] = 15,
    ["Props"] = 4
}

// If Hide Max Value is true you can set the postfix
OneHud.Config.Postfix = {
    ["Health"] = "HP",
    ["Armor"] = "%",
    ["Food"] = "%",
    ["Level"] = "lvl",
    ["Props"] = " Props"
}

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//         User Interface Settings        //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

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

// Ping Colors Settings
OneHud.Config.PingColorGood = Color(73, 175, 81) // Ping Color
OneHud.Config.PingColorMedium = Color(175, 97, 61) // Ping Color
OneHud.Config.PingColorBad = Color(175, 61, 61) // Ping Color

// Wanted Colors Settings
OneHud.Config.WantedColor = Color(190, 68, 68) // Icon Color

// License Colors Settings
OneHud.Config.LincenseColor = Color(68, 107, 190) // Icon Color

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//            Advenced Settings           //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

// Font Settings
OneHud.Config.TextFont = "Roboto" // Text Font
OneHud.Config.FontLiveTest = false // Font Live Test (Consumes a lot of FPS do not let in true)
OneHud.Config.TextSize = 20 // Text Size
OneHud.Config.PingRefrech = 5 // Ping Refrech Time
OneHud.Config.HeightSpacing = 6 // Spacing between the bars -6 to collapse

// Others Settings
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

// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//            Languages Settings          //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

OneHud.Language = {
    ["armor"] = "Armor",
    ["wanted"] = "Rechercher",
    ["yes"] = "Oui",
    ["no"] = "Non"
}