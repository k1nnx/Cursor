[[Textual elements in Rayfield
Creating a Label]]

local Label = Tab:CreateLabel("Label Example", 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme

[[Lucide Icon Support

You can now also use Lucide Icons with Rayfield. To do so, replace the Image Id above 4483362458 with a string value of an icon name in Lucide Icons.]]

local Label = Tab:CreateLabel("Label Example", "rewind")

[[This will set the icon to a rewind symbol from Lucide Icons.

All Lucide Icons Supported Lucide Icons

Credit to Lucide and Latte Softworks
Updating a Label]]

Label:Set("Label Example", 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme

[[Creating a Paragraph]]

local Paragraph = Tab:CreateParagraph({Title = "Paragraph Example", Content = "Paragraph Example"})

[[Updating a Paragraph]]

Paragraph:Set({Title = "Paragraph Example", Content = "Paragraph Example"})