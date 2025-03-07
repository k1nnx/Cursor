[[Booting the Library
Loading the Rayfield Library]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

[[Enabling Configuration Saving
tip

    Enable ConfigurationSaving in the CreateWindow function
    Choose an appropiate FileName in the CreateWindow function
    Choose an unique flag identifier for each supported element you create
    Place Rayfield:LoadConfiguration() at the bottom of all your code

Rayfield will now automatically save and load your configuration]]   