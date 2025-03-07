-- Example of using InfYiffLib with loadstring

-- Load the library directly (fixed version)
local success, result = pcall(function()
    local source = game:HttpGet('https://raw.githubusercontent.com/k1nnx/Cursor/refs/heads/main/InfYiffLib/loader.lua')
    print("Source loaded:", #source, "bytes") -- Debug print
    
    local loader = loadstring(source)
    if not loader then
        error("Failed to compile loader")
    end
    
    local lib = loader()
    if not lib then
        error("Failed to get library code")
    end
    
    return loadstring(lib)()
end)

if not success then
    warn("Failed to load library:", result)
    return
end

local Library = result

-- Create a new UI instance
local UI = Library.new()

-- Add some buttons
UI:AddButton('Hello World', function()
    print('Hello World!')
end)

UI:AddButton('Toggle UI', function()
    UI:Toggle()
end)

-- You can also create a simple keybind to toggle the UI
local UserInputService = game:GetService('UserInputService')
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        UI:Toggle()
    end
end)

-- Test that it's working
print('Library loaded successfully!')
