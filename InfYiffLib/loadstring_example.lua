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

-- Add some interactive buttons
UI:AddButton('Click Me!', function()
    print('Button clicked!')
end)

UI:AddButton('Change Title Color', function()
    local colors = {
        Color3.fromRGB(255, 100, 100),  -- Red
        Color3.fromRGB(100, 255, 100),  -- Green
        Color3.fromRGB(100, 100, 255),  -- Blue
        Color3.fromRGB(255, 255, 255)   -- White
    }
    local currentColor = 1
    return function()
        UI.components.Title.TextColor3 = colors[currentColor]
        currentColor = (currentColor % #colors) + 1
    end
end())

UI:AddButton('Toggle UI (or press RightCtrl)', function()
    UI:Toggle()
end)

-- Add keybind for toggling
local UserInputService = game:GetService('UserInputService')
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        UI:Toggle()
    end
end)

-- Print instructions
print('Library loaded successfully!')
print('The UI is now visible and draggable by the title bar')
print('Press Right Control to toggle visibility')
