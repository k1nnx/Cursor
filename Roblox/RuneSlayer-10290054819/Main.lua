function load()
    -- Load external dependencies
    loadstring(game:HttpGet('https://raw.githubusercontent.com/k1nnx/Cursor/refs/heads/main/Roblox/RuneSlayer-10290054819/Functions.lua'))()
    local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
    local PrefabsId = `rbxassetid://{ReGui.PrefabsId}`

    -- Initialize ReGui
    ReGui:Init({
        Prefabs = game:GetService("InsertService"):LoadLocalAsset(PrefabsId)
    })

    -- Create main window
    local TabsWindow = ReGui:TabsWindow({
        Title = "RuneSlayer-10290054819",
        Size = UDim2.fromOffset(600, 400)
    })

    -- Create Console tab
    local ConsoleTab = TabsWindow:CreateTab({
        Name = "Console"
    })

    local Console = ConsoleTab:Console({
        AutoScroll = true,
        RichText = true,
        ReadOnly = true,
        LineNumbers = true,
    })

    -- Create Mobs tab
    local MobsTab = TabsWindow:CreateTab({
        Name = "Mobs"
    })
    mobtab()
    getMob().ChildAdded:Connect(mobtab())
end

load()