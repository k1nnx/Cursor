-- Example of using InfYiffLib with loadstring

-- Load the library directly (fixed version)
local success, result = pcall(function()
    local source = game:HttpGet('https://raw.githubusercontent.com/k1nnx/Cursor/refs/heads/main/InfYiffLib/loader.lua')
    print('Source loaded:', #source, 'bytes') -- Debug print
    local lib = loadstring(source)
    if not lib then error("Failed to compile library") end
    return lib()
end)

if not success then
    warn('Failed to load library:', result)
    return
end

local Library = result

-- Create a new UI instance
local UI = Library.new()

-- Add some interactive buttons
UI:AddButton('Click Me!', function()
    print('Button clicked!')
end)

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

print('Library loaded successfully!')
