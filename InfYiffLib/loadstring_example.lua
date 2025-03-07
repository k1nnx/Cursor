-- Example of using InfYiffLib with loadstring

-- Load the library using loadstring
local source = loadstring(game:HttpGet('https://raw.githubusercontent.com/YourUsername/InfYiffLib/main/loader.lua'))()
local InfYiffLib = loadstring(source)()

-- Create a new UI instance
local UI = InfYiffLib.new()

-- Add some buttons
UI:AddButton("Hello World", function()
    print("Hello World!")
end)

UI:AddButton("Toggle UI", function()
    UI:Toggle()
end)

-- Print the library version
print("InfYiffLib Version:", UI:GetVersion())

-- You can also create a simple keybind to toggle the UI
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        UI:Toggle()
    end
end) 