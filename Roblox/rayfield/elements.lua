[[Adding interactive elements
Notifying the user]]

Rayfield:Notify({
   Title = "Notification Title",
   Content = "Notification Content",
   Duration = 6.5,
   Image = 4483362458,
})

[[Lucide Icon Support

You can now also use Lucide Icons with Rayfield. To do so, replace the Image Id above 4483362458 with a string value of an icon name in Lucide Icons.]]

Rayfield:Notify({
   Title = "Notification Title",
   Content = "Notification Content",
   Duration = 6.5,
   Image = "rewind",
})

[[This will set the icon to a rewind symbol from Lucide Icons.

All Lucide Icons Supported Lucide Icons

Credit to Lucide and Latte Softworks
Creating a Button]]

local Button = Tab:CreateButton({
   Name = "Button Example",
   Callback = function()
   -- The function that takes place when the button is pressed
   end,
})

[[Updating a Button]]

Button:Set("Button Example")

[[Creating a Toggle]]

local Toggle = Tab:CreateToggle({
   Name = "Toggle Example",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- The function that takes place when the toggle is pressed
   -- The variable (Value) is a boolean on whether the toggle is true or false
   end,
})

[[Updating a Toggle]]

Toggle:Set(false)

[[Creating a Color Picker]]

local ColorPicker = Tab:CreateColorPicker({
    Name = "Color Picker",
    Color = Color3.fromRGB(255,255,255),
    Flag = "ColorPicker1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        -- The function that takes place every time the color picker is moved/changed
        -- The variable (Value) is a Color3fromRGB value based on which color is selected
    end
})

[[Updating a Color Picker]]

ColorPicker:Set(Color3.fromRGB(255,255,255)

[[Creating a Slider]]

local Slider = Tab:CreateSlider({
   Name = "Slider Example",
   Range = {0, 100},
   Increment = 10,
   Suffix = "Bananas",
   CurrentValue = 10,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- The function that takes place when the slider changes
   -- The variable (Value) is a number which correlates to the value the slider is currently at
   end,
})

[[Updating a Slider]]

Slider:Set(10) -- The new slider integer value

[[Creating an Adaptive Input (TextBox)]]

local Input = Tab:CreateInput({
   Name = "Input Example",
   CurrentValue = "",
   PlaceholderText = "Input Placeholder",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
   -- The function that takes place when the input is changed
   -- The variable (Text) is a string for the value in the text box
   end,
})

[[Updating a an Adaptive Input (TextBox)]]

Input:Set("New Text") -- The new input text value

[[Creating a Dropdown menu]]

local Dropdown = Tab:CreateDropdown({
   Name = "Dropdown Example",
   Options = {"Option 1","Option 2"},
   CurrentOption = {"Option 1"},
   MultipleOptions = false,
   Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
   -- The function that takes place when the selected option is changed
   -- The variable (Options) is a table of strings for the current selected options
   end,
})

[[Updating a Dropdown]]

Dropdown:Set({"Option 2"}) -- The new selected options

[[Resetting a dropdown]]

Dropdown:Refresh({"Option 1", "Option 2", "Option 3"}) -- The new list of options available.

[[Check the value of an existing element

To check the current value of an existing element, using the variable, you can do ElementName.CurrentValue, if it's a keybind or dropdown, you will need to use KeybindName.CurrentKeybind or DropdownName.CurrentOption You can also check it via the flags from Rayfield.Flags]]