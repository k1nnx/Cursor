-- Example of using InfYiffLib with loadstring

-- Load the library directly
local InfYiffLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/k1nnx/Cursor/refs/heads/main/InfYiffLib/loader.lua"))()

-- Create a new UI instance
local UI = InfYiffLib.new()

-- Add some buttons
UI:AddButton("Hello World", function()
    print("Hello World!")
end)

UI:AddButton("Toggle UI", function()
    UI:Toggle()
end)

-- You can also create a simple keybind to toggle the UI
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        UI:Toggle()
    end
end)

-- Test that it's working
print("Library loaded successfully!") 