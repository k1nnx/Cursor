-- BlueHeater2 Entity System Loader
-- By k1nnx

-- Set this to true to enable debug messages
local DEBUG = true

local function debugPrint(...)
    if DEBUG then
        print("[BlueHeater2 Loader]", ...)
    end
end

-- URLs for components
local urls = {
    Info = "https://raw.githubusercontent.com/k1nnx/Cursor/refs/heads/main/Roblox/BlueHeater2/Info.lua?token=GHSAT0AAAAAAC74ORH2OTVN34F6YLFZCRMOZ6GKA5Q",
    GUI = "https://raw.githubusercontent.com/k1nnx/Cursor/refs/heads/main/Roblox/BlueHeater2/EntityInfoGUI.lua?token=GHSAT0AAAAAAC74ORH2ORT4M3OCBOULDTXKZ6GKAZQ",
    NameTags = "https://raw.githubusercontent.com/k1nnx/Cursor/refs/heads/main/Roblox/BlueHeater2/EntityNameTags.lua?token=GHSAT0AAAAAAC74ORH2AZRPTPA5BOFFJPCSZ6GKAUA"
}

-- Module container
local BlueHeater2 = {}

-- Load a module from URL
local function loadModule(name, url)
    debugPrint("Loading " .. name .. "...")
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        debugPrint(name .. " loaded successfully")
        return result
    else
        warn("Failed to load " .. name .. ": " .. tostring(result))
        return nil
    end
end

-- Load all modules
function BlueHeater2.LoadAll()
    -- Load Info API first (required by others)
    BlueHeater2.API = loadModule("Entity Info API", urls.Info)
    
    -- Then load GUI and NameTags
    if BlueHeater2.API then
        BlueHeater2.GUI = loadModule("Entity Info GUI", urls.GUI)
        BlueHeater2.NameTags = loadModule("Entity Name Tags", urls.NameTags)
        
        -- Notify user
        game.StarterGui:SetCore("SendNotification", {
            Title = "BlueHeater2 Loaded",
            Text = "Press N to toggle nametags\nPress RightControl to toggle GUI",
            Duration = 5
        })
        
        return true
    else
        warn("Failed to load BlueHeater2 system - Info API could not be loaded")
        return false
    end
end

-- Add commands to toggle features
function BlueHeater2.ToggleNameTags()
    if BlueHeater2.NameTags then
        return BlueHeater2.NameTags:Toggle()
    end
    return false
end

function BlueHeater2.ToggleGUI()
    if BlueHeater2.GUI and BlueHeater2.GUI.ToggleGui then
        BlueHeater2.GUI.ToggleGui()
        return true
    end
    return false
end

-- Start loading everything
BlueHeater2.LoadAll()

-- Return the module
return BlueHeater2 