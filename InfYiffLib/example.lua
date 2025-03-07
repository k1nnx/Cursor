-- Example usage of InfYiffLib

local InfYiffLib = require(game:GetService("ReplicatedStorage").InfYiffLib)

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