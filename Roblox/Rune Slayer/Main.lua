function boot()
    local boot = {}
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({
        Name = "Rayfield Example Window",
        Icon = "gem", -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
        LoadingTitle = "Rayfield Interface Suite",
        LoadingSubtitle = "by Sirius",
        Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
        
        DisableRayfieldPrompts = false,
        DisableBuildWarnings = false,
        
        ConfigurationSaving = {
            Enabled = true,
            FolderName = nil,
            FileName = "RuneSlayer"
        }
    })
    
    local Tab = Window:CreateTab("Info", "info") -- Title, Image
    local Section = Tab:CreateSection("Section Example")
    
    local function GetAlive()
        local alive = {}
        for i, v in pairs(workspace:WaitForChild("Alive"):GetChildren()) do
            if not game:GetService("Players"):GetPlayerFromCharacter(v) then
                table.insert(alive, v)
            end
        end
        return alive
    end
    
    local Dropdown = Tab:CreateDropdown({
        Name = "Dropdown Example",
        Options = {"Option 1", "Option 2"},
        CurrentOption = {"Option 1"},
        MultipleOptions = false,
        Flag = "Dropdown1"
    })
end

boot()