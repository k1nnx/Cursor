local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Get the GetEntityData function from Info.lua
local getEntityDataFunction = loadstring(script:WaitForChild("Info").Source)()

-- Create GUI
local function createInfoGUI(player)
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EntityInfoGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.6, 0, 0.7, 0)
    mainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0.06, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(0.5, 0, 1, 0)
    titleText.Position = UDim2.new(0.25, 0, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Entity Information"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 18
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0.05, 0, 1, 0)
    closeButton.Position = UDim2.new(0.95, 0, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    -- SearchBar
    local searchBar = Instance.new("Frame")
    searchBar.Name = "SearchBar"
    searchBar.Size = UDim2.new(1, 0, 0.05, 0)
    searchBar.Position = UDim2.new(0, 0, 0.06, 0)
    searchBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    searchBar.BorderSizePixel = 0
    searchBar.Parent = mainFrame
    
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(0.9, 0, 0.8, 0)
    searchBox.Position = UDim2.new(0.05, 0, 0.1, 0)
    searchBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    searchBox.PlaceholderText = "Search entities..."
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    searchBox.TextSize = 14
    searchBox.Font = Enum.Font.Gotham
    searchBox.BorderSizePixel = 0
    searchBox.Parent = searchBar
    
    -- Scroll Frame for Entities
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "EntitiesScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 0.89, 0)
    scrollFrame.Position = UDim2.new(0, 0, 0.11, 0)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = mainFrame
    
    -- Template for entity entry (hidden)
    local entityTemplate = Instance.new("Frame")
    entityTemplate.Name = "EntityTemplate"
    entityTemplate.Size = UDim2.new(0.98, 0, 0, 70)
    entityTemplate.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    entityTemplate.BorderSizePixel = 0
    entityTemplate.Visible = false
    entityTemplate.Parent = mainFrame
    
    local entityHeader = Instance.new("Frame")
    entityHeader.Name = "Header"
    entityHeader.Size = UDim2.new(1, 0, 0.3, 0)
    entityHeader.BackgroundColor3 = Color3.fromRGB(30, 30, 80)
    entityHeader.BorderSizePixel = 0
    entityHeader.Parent = entityTemplate
    
    local entityName = Instance.new("TextLabel")
    entityName.Name = "EntityName"
    entityName.Size = UDim2.new(0.6, 0, 1, 0)
    entityName.BackgroundTransparency = 1
    entityName.Text = "Entity Name"
    entityName.TextColor3 = Color3.fromRGB(255, 255, 255)
    entityName.TextSize = 16
    entityName.Font = Enum.Font.GothamBold
    entityName.TextXAlignment = Enum.TextXAlignment.Left
    entityName.TextTruncate = Enum.TextTruncate.AtEnd
    entityName.Parent = entityHeader
    entityName.Position = UDim2.new(0.02, 0, 0, 0)
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(0.96, 0, 0.15, 0)
    healthBar.Position = UDim2.new(0.02, 0, 0.35, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = entityTemplate
    
    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBar
    
    local healthText = Instance.new("TextLabel")
    healthText.Name = "HealthText"
    healthText.Size = UDim2.new(1, 0, 1, 0)
    healthText.BackgroundTransparency = 1
    healthText.Text = "100/100"
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.TextSize = 14
    healthText.Font = Enum.Font.GothamSemibold
    healthText.Parent = healthBar
    
    local infoContainer = Instance.new("Frame")
    infoContainer.Name = "InfoContainer"
    infoContainer.Size = UDim2.new(0.98, 0, 0.4, 0)
    infoContainer.Position = UDim2.new(0.01, 0, 0.55, 0)
    infoContainer.BackgroundTransparency = 1
    infoContainer.Parent = entityTemplate
    
    -- Info Text
    local infoText = Instance.new("TextLabel")
    infoText.Name = "InfoText"
    infoText.Size = UDim2.new(1, 0, 1, 0)
    infoText.BackgroundTransparency = 1
    infoText.Text = "Position: 0, 0, 0 | Drops: None | Resistances: None"
    infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoText.TextSize = 12
    infoText.Font = Enum.Font.Gotham
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.TextYAlignment = Enum.TextYAlignment.Top
    infoText.TextWrapped = true
    infoText.Parent = infoContainer
    
    -- Return GUI elements to be used for updating
    return {
        ScreenGui = screenGui,
        SearchBox = searchBox,
        ScrollFrame = scrollFrame,
        EntityTemplate = entityTemplate,
        CloseButton = closeButton
    }
end

-- Function to update entities in the GUI
local function updateEntities(guiElements, searchText)
    searchText = searchText or ""
    searchText = searchText:lower()
    
    -- Clear existing entries
    for _, child in ipairs(guiElements.ScrollFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "EntityTemplate" then
            child:Destroy()
        end
    end
    
    -- Get updated entity data
    local entities = getEntityDataFunction()
    local yOffset = 0
    
    -- Add entity entries
    for i, entity in ipairs(entities) do
        -- Filter by search text if provided
        if searchText == "" or string.find(entity.Name:lower(), searchText) then
            local clone = guiElements.EntityTemplate:Clone()
            clone.Name = "Entity_" .. entity.Name
            clone.Visible = true
            clone.Position = UDim2.new(0.01, 0, 0, yOffset)
            
            -- Set entity name
            clone.Header.EntityName.Text = entity.Name
            
            -- Set health bar
            local healthPercent = entity.Health / entity.MaxHealth
            clone.HealthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
            clone.HealthText.Text = math.floor(entity.Health) .. "/" .. math.floor(entity.MaxHealth)
            
            -- Format position
            local posX = math.floor(entity.Position.X * 10) / 10
            local posY = math.floor(entity.Position.Y * 10) / 10
            local posZ = math.floor(entity.Position.Z * 10) / 10
            
            -- Set info text
            local infoText = "Position: " .. posX .. ", " .. posY .. ", " .. posZ
            
            -- Add drops info
            if entity.Drops and entity.Drops.Coins then
                infoText = infoText .. "\nDrops: " .. entity.Drops.Coins .. " coins (" .. 
                            entity.Drops.CoinsChance .. "%), XP: " .. entity.Drops.Experience
                
                if #entity.Drops.Items > 0 then
                    infoText = infoText .. ", Items: "
                    for i, item in ipairs(entity.Drops.Items) do
                        infoText = infoText .. item
                        if i < #entity.Drops.Items then
                            infoText = infoText .. ", "
                        end
                    end
                end
            end
            
            -- Add resistances
            if entity.Resistances and next(entity.Resistances) then
                infoText = infoText .. "\nResistances: "
                local resistanceCount = 0
                local totalResistances = 0
                
                for _, _ in pairs(entity.Resistances) do
                    totalResistances = totalResistances + 1
                end
                
                for type, value in pairs(entity.Resistances) do
                    resistanceCount = resistanceCount + 1
                    infoText = infoText .. type .. ": " .. value
                    if resistanceCount < totalResistances then
                        infoText = infoText .. ", "
                    end
                end
            end
            
            -- Set the info text
            clone.InfoContainer.InfoText.Text = infoText
            
            clone.Parent = guiElements.ScrollFrame
            yOffset = yOffset + clone.Size.Y.Offset + 5
        end
    end
end

-- Main function to setup the GUI
local function setupInfoGUI()
    -- Create a copy of Info.lua script to use for retrieving data
    local infoScript = script.Parent:WaitForChild("Info"):Clone()
    infoScript.Parent = script
    
    local function onPlayerAdded(player)
        local guiElements = createInfoGUI(player)
        guiElements.ScreenGui.Parent = player.PlayerGui
        
        -- Setup close button
        guiElements.CloseButton.MouseButton1Click:Connect(function()
            guiElements.ScreenGui.Enabled = not guiElements.ScreenGui.Enabled
        end)
        
        -- Setup search functionality
        guiElements.SearchBox.Changed:Connect(function(property)
            if property == "Text" then
                updateEntities(guiElements, guiElements.SearchBox.Text)
            end
        end)
        
        -- Update entities regularly
        local updateConnection
        updateConnection = RunService.Heartbeat:Connect(function()
            if guiElements.ScreenGui.Enabled then
                updateEntities(guiElements, guiElements.SearchBox.Text)
            end
        end)
        
        -- Clean up when player leaves
        player.AncestryChanged:Connect(function(_, parent)
            if parent == nil then
                updateConnection:Disconnect()
            end
        end)
        
        -- Initial update
        updateEntities(guiElements)
    end
    
    -- Handle existing players
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(function()
            onPlayerAdded(player)
        end)
    end
    
    -- Handle future players
    Players.PlayerAdded:Connect(onPlayerAdded)
end

-- Run the setup
setupInfoGUI()
