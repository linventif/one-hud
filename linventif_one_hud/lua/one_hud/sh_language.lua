local languages = {}

// -- // -- // -- // -- // -- // -- // -- //
// DO NOT EDIT ABOVE THIS LINE
// -- // -- // -- // -- // -- // -- // -- //

languages["english"] = {
    ["health"] = "Health",
    ["money"] = "Money",
    ["food"] = "Food",
    ["level"] = "Level",
    ["props"] = "Props",
    ["ammo"] = "Ammo",
    ["special ammo"] = "Special Ammo",
    ["ping"] = "Ping",
    ["name"] = "Name",
    ["group"] = "Group",
    ["team"] = "Team",
    ["license"] = "License",
    ["weapon"] = "Weapon",
    ["armor"] = "Armor",
    ["wanted"] = "Wanted",
    ["yes"] = "Yes",
    ["no"] = "No",
    ["money"] = "Money",
    ["health"] = "Health"
}

languages["french"] = {
    ["health"] = "Santé",
    ["money"] = "Argent",
    ["food"] = "Nourriture",
    ["level"] = "Niveau",
    ["props"] = "Props",
    ["ammo"] = "Munitions",
    ["special ammo"] = "Munitions Spéciales",
    ["ping"] = "Ping",
    ["name"] = "Nom",
    ["group"] = "Groupe",
    ["team"] = "Équipe",
    ["license"] = "Permis",
    ["weapon"] = "Arme",
    ["armor"] = "Armure",
    ["wanted"] = "Rechercher",
    ["yes"] = "Oui",
    ["no"] = "Non",
    ["money"] = "Argent",
    ["health"] = "Santé"
}

// -- // -- // -- // -- // -- // -- // -- //
// DO NOT EDIT BELOW THIS LINE
// -- // -- // -- // -- // -- // -- // -- //

function OneHud.GetTranslation(id)
    return languages[OneHud.Config.Language][id] || id
end