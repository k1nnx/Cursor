-- Example of using InfYiffLib with loadstring

-- Load the library directly (fixed version)
local function fetchAndLoadLibrary()
    local source = game:HttpGet('https://raw.githubusercontent.com/k1nnx/Cursor/refs/heads/main/InfYiffLib/loader.lua')
    print('Source loaded:', #source, 'bytes') -- Debug print
    
    -- First load and execute the loader
    local loader = loadstring(source)
    if not loader then
        error('Failed to compile loader')
    end
    
    -- Get the library source code
    local librarySource = loader()
    if type(librarySource) ~= "string" then
        error('Loader did not return library source code')
    end
    
    -- Now load and execute the actual library code
    local library = loadstring(librarySource)
    if not library then
        error('Failed to compile library')
    end
    
    -- Execute the library code
    local result = library()
    if not result or type(result) ~= "table" or not result.new then
        error('Invalid library returned')
    end
    
    return result
end

local success, Library = pcall(fetchAndLoadLibrary)

if not success then
    warn('Failed to load library:', Library)
    return
end

print("Library loaded, type:", typeof(Library))
print("Library.new exists:", Library.new ~= nil)

-- Create a new UI instance
local UI = Library.new()

if not UI then
    warn("UI creation failed!")
    return
end

print("UI created successfully")

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