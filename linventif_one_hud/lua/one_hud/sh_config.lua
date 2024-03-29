// -- // -- // -- // -- // -- // -- // -- //
//                                        //
//            General Settings            //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

// Main Settings
OneHud.Config.Language = "french" // Language (english - french) you can add your own language in sh_language.lua
OneHud.Config.Theme = "Flat" // HUD Theme (Flat - Flat Bar)
OneHud.Config.ThemeColor = "sentro" // HUD Theme Color (sentro)
OneHud.Config.TalkIcon = true // Talk Icon
OneHud.Config.RoundValue = 8 // Round Value (0 = disable)

// What should be shown
OneHud.Config.Text = true // Show Text
OneHud.Config.MaxValue = false // Show Max Value if set false you will be modify the width space of the bar in Themes Settings
OneHud.Config.Icon = true // Show Icon
OneHud.Config.ArmorWhenNone = true // Show Armor when you have none
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
    "Props", // Only compatible with Linventif Prop Limit https://github.com/linventif/gmod-scripts
//    "Level", // Level Settings only compatible with https://github.com/uen/Leveling-System and https://github.com/GlorifiedPig/GlorifiedLeveling
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
//            Advenced Settings           //
//                                        //
// -- // -- // -- // -- // -- // -- // -- //

// Font Settings
OneHud.Config.TextFont = "Roboto" // Text Font
OneHud.Config.FontLiveTest = false // Font Live Test (Consumes a lot of FPS do not let in true)
OneHud.Config.TextSize = 20 // Text Size

// Other Settings
OneHud.Config.PingRefrech = 5 // Ping Refrech Time
OneHud.Config.HeightSpacing = 6 // Spacing between the bars -6 to collapse the bars
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