-- EntityInfoGUI.lua
-- A GUI for viewing entity information in BlueHeater2

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Create or get the BlueHeaterAPI
if not _G.BlueHeaterAPI then
    -- Try to load the API if not already present
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/k1nnx/Cursor/refs/heads/main/Roblox/BlueHeater2/Info.lua?token=GHSAT0AAAAAAC74ORH2WILUTATNVZHDTJJAZ6GIVUA"))()
    end)
    
    if not _G.BlueHeaterAPI then
        _G.BlueHeaterAPI = {}
        _G.BlueHeaterAPI.EntityInfo = {
            GetAllEntities = function() return {} end,
            FindEntityByName = function() return nil end
        }
        warn("BlueHeater2 API not loaded. GUI may not work properly.")
    end
end

local EntityInfo = _G.BlueHeaterAPI.EntityInfo

-- GUI Settings
local settings = {
    guiTitle = "BlueHeater2 Entity Info",
    backgroundColor = Color3.fromRGB(30, 30, 30),
    textColor = Color3.fromRGB(255, 255, 255),
    accentColor = Color3.fromRGB(0, 120, 215),
    warningColor = Color3.fromRGB(230, 126, 34),
    fontSize = 14,
    updateInterval = 1, -- seconds
    maxEntitiesShown = 10,
    toggleKey = Enum.KeyCode.RightControl
}

-- Create main GUI
local gui = {}
local selectedEntity = nil -- Track the selected entity

function gui:Create()
    -- Check if GUI already exists and remove it
    if LocalPlayer.PlayerGui:FindFirstChild("BlueHeaterEntityGUI") then
        LocalPlayer.PlayerGui:FindFirstChild("BlueHeaterEntityGUI"):Destroy()
    end
    
    -- Create main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlueHeaterEntityGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer.PlayerGui
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(1, -310, 0.5, -200)
    mainFrame.BackgroundColor3 = settings.backgroundColor
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Create corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = settings.accentColor
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    -- Title bar corner
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Fix corner overlap
    local fixFrame = Instance.new("Frame")
    fixFrame.Name = "FixCorner"
    fixFrame.Size = UDim2.new(1, 0, 0.5, 0)
    fixFrame.Position = UDim2.new(0, 0, 0.5, 0)
    fixFrame.BackgroundColor3 = settings.accentColor
    fixFrame.BorderSizePixel = 0
    fixFrame.Parent = titleBar
    
    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = settings.textColor
    titleText.TextSize = settings.fontSize + 2
    titleText.Font = Enum.Font.SourceSansBold
    titleText.Text = settings.guiTitle
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.TextColor3 = settings.textColor
    closeButton.TextSize = settings.fontSize
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Text = "X"
    closeButton.Parent = titleBar
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)
    
    -- Content container
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -40)
    content.Position = UDim2.new(0, 10, 0, 35)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame
    
    -- Tab buttons
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabButtons"
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = content
    
    local tabs = {}
    local tabContents = {}
    
    local function createTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Size = UDim2.new(1/4, -2, 1, 0)
        tabButton.Position = UDim2.new((#tabs)*(1/4), 1, 0, 0)
        tabButton.BackgroundColor3 = settings.backgroundColor
        tabButton.BorderColor3 = settings.accentColor
        tabButton.BorderSizePixel = 1
        tabButton.TextColor3 = settings.textColor
        tabButton.TextSize = settings.fontSize
        tabButton.Font = Enum.Font.SourceSans
        tabButton.Text = name
        tabButton.Parent = tabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 4)
        tabCorner.Parent = tabButton
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, -35)
        tabContent.Position = UDim2.new(0, 0, 0, 35)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.Visible = #tabs == 0 -- First tab visible by default
        tabContent.Parent = content
        
        table.insert(tabs, tabButton)
        tabContents[name] = tabContent
        
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tab contents
            for _, v in pairs(tabContents) do
                v.Visible = false
            end
            -- Show this tab's content
            tabContent.Visible = true
            
            -- Update tab button appearances
            for _, v in ipairs(tabs) do
                v.BackgroundColor3 = settings.backgroundColor
            end
            tabButton.BackgroundColor3 = settings.accentColor
        end)
        
        if #tabs == 1 then
            tabButton.BackgroundColor3 = settings.accentColor
        end
        
        return tabContent
    end
    
    -- Create All Entities Tab
    local allEntitiesTab = createTab("All Entities")
    
    -- Create layout for entity list
    local entityListLayout = Instance.new("UIListLayout")
    entityListLayout.Padding = UDim.new(0, 2)
    entityListLayout.Parent = allEntitiesTab
    
    -- Create Closest Entity Tab
    local closestTab = createTab("Closest")
    
    -- Create Selected Entity Tab
    local selectedTab = createTab("Selected")
    
    -- Selected entity info container
    local selectedInfo = Instance.new("Frame")
    selectedInfo.Name = "SelectedInfo"
    selectedInfo.Size = UDim2.new(1, 0, 1, 0)
    selectedInfo.BackgroundTransparency = 1
    selectedInfo.Parent = selectedTab
    
    local selectedInfoTitle = Instance.new("TextLabel")
    selectedInfoTitle.Name = "InfoTitle"
    selectedInfoTitle.Size = UDim2.new(1, 0, 0, 25)
    selectedInfoTitle.BackgroundTransparency = 1
    selectedInfoTitle.TextColor3 = settings.accentColor
    selectedInfoTitle.TextSize = settings.fontSize + 2
    selectedInfoTitle.Font = Enum.Font.SourceSansBold
    selectedInfoTitle.Text = "Selected Entity"
    selectedInfoTitle.Parent = selectedInfo
    
    local selectedNameLabel = Instance.new("TextLabel")
    selectedNameLabel.Name = "NameLabel"
    selectedNameLabel.Size = UDim2.new(1, 0, 0, 20)
    selectedNameLabel.Position = UDim2.new(0, 0, 0, 30)
    selectedNameLabel.BackgroundTransparency = 1
    selectedNameLabel.TextColor3 = settings.textColor
    selectedNameLabel.TextSize = settings.fontSize
    selectedNameLabel.Font = Enum.Font.SourceSans
    selectedNameLabel.Text = "Name: N/A"
    selectedNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedNameLabel.Parent = selectedInfo
    
    local selectedHealthLabel = Instance.new("TextLabel")
    selectedHealthLabel.Name = "HealthLabel"
    selectedHealthLabel.Size = UDim2.new(1, 0, 0, 20)
    selectedHealthLabel.Position = UDim2.new(0, 0, 0, 50)
    selectedHealthLabel.BackgroundTransparency = 1
    selectedHealthLabel.TextColor3 = settings.textColor
    selectedHealthLabel.TextSize = settings.fontSize
    selectedHealthLabel.Font = Enum.Font.SourceSans
    selectedHealthLabel.Text = "Health: N/A"
    selectedHealthLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedHealthLabel.Parent = selectedInfo
    
    local selectedDistanceLabel = Instance.new("TextLabel")
    selectedDistanceLabel.Name = "DistanceLabel"
    selectedDistanceLabel.Size = UDim2.new(1, 0, 0, 20)
    selectedDistanceLabel.Position = UDim2.new(0, 0, 0, 70)
    selectedDistanceLabel.BackgroundTransparency = 1
    selectedDistanceLabel.TextColor3 = settings.textColor
    selectedDistanceLabel.TextSize = settings.fontSize
    selectedDistanceLabel.Font = Enum.Font.SourceSans
    selectedDistanceLabel.Text = "Distance: N/A"
    selectedDistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedDistanceLabel.Parent = selectedInfo
    
    local selectedDetailsContainer = Instance.new("Frame")
    selectedDetailsContainer.Name = "Details"
    selectedDetailsContainer.Size = UDim2.new(1, 0, 1, -100)
    selectedDetailsContainer.Position = UDim2.new(0, 0, 0, 100)
    selectedDetailsContainer.BackgroundTransparency = 1
    selectedDetailsContainer.Parent = selectedInfo
    
    local selectedDetailsLayout = Instance.new("UIListLayout")
    selectedDetailsLayout.Padding = UDim.new(0, 2)
    selectedDetailsLayout.Parent = selectedDetailsContainer
    
    local selectedTpButton = Instance.new("TextButton")
    selectedTpButton.Name = "TPButton"
    selectedTpButton.Size = UDim2.new(0.8, 0, 0, 30)
    selectedTpButton.Position = UDim2.new(0.1, 0, 1, -40)
    selectedTpButton.BackgroundColor3 = settings.accentColor
    selectedTpButton.BorderSizePixel = 0
    selectedTpButton.TextColor3 = settings.textColor
    selectedTpButton.TextSize = settings.fontSize
    selectedTpButton.Font = Enum.Font.SourceSansBold
    selectedTpButton.Text = "Teleport to Entity"
    selectedTpButton.Parent = selectedInfo
    
    local selectedTpCorner = Instance.new("UICorner")
    selectedTpCorner.CornerRadius = UDim.new(0, 4)
    selectedTpCorner.Parent = selectedTpButton
    
    -- Closest entity info container
    local closestInfo = Instance.new("Frame")
    closestInfo.Name = "ClosestInfo"
    closestInfo.Size = UDim2.new(1, 0, 1, 0)
    closestInfo.BackgroundTransparency = 1
    closestInfo.Parent = closestTab
    
    local infoTitle = Instance.new("TextLabel")
    infoTitle.Name = "InfoTitle"
    infoTitle.Size = UDim2.new(1, 0, 0, 25)
    infoTitle.BackgroundTransparency = 1
    infoTitle.TextColor3 = settings.accentColor
    infoTitle.TextSize = settings.fontSize + 2
    infoTitle.Font = Enum.Font.SourceSansBold
    infoTitle.Text = "Closest Entity"
    infoTitle.Parent = closestInfo
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, 30)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = settings.textColor
    nameLabel.TextSize = settings.fontSize
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.Text = "Name: N/A"
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = closestInfo
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0, 20)
    healthLabel.Position = UDim2.new(0, 0, 0, 50)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = settings.textColor
    healthLabel.TextSize = settings.fontSize
    healthLabel.Font = Enum.Font.SourceSans
    healthLabel.Text = "Health: N/A"
    healthLabel.TextXAlignment = Enum.TextXAlignment.Left
    healthLabel.Parent = closestInfo
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.Position = UDim2.new(0, 0, 0, 70)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = settings.textColor
    distanceLabel.TextSize = settings.fontSize
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.Text = "Distance: N/A"
    distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
    distanceLabel.Parent = closestInfo
    
    local detailsContainer = Instance.new("Frame")
    detailsContainer.Name = "Details"
    detailsContainer.Size = UDim2.new(1, 0, 1, -100)
    detailsContainer.Position = UDim2.new(0, 0, 0, 100)
    detailsContainer.BackgroundTransparency = 1
    detailsContainer.Parent = closestInfo
    
    local detailsLayout = Instance.new("UIListLayout")
    detailsLayout.Padding = UDim.new(0, 2)
    detailsLayout.Parent = detailsContainer
    
    local tpButton = Instance.new("TextButton")
    tpButton.Name = "TPButton"
    tpButton.Size = UDim2.new(0.8, 0, 0, 30)
    tpButton.Position = UDim2.new(0.1, 0, 1, -40)
    tpButton.BackgroundColor3 = settings.accentColor
    tpButton.BorderSizePixel = 0
    tpButton.TextColor3 = settings.textColor
    tpButton.TextSize = settings.fontSize
    tpButton.Font = Enum.Font.SourceSansBold
    tpButton.Text = "Teleport to Entity"
    tpButton.Parent = closestInfo
    
    local tpCorner = Instance.new("UICorner")
    tpCorner.CornerRadius = UDim.new(0, 4)
    tpCorner.Parent = tpButton
    
    -- Create Search Tab
    local searchTab = createTab("Search")
    
    -- Search box
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, 0, 0, 30)
    searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    searchBox.BorderSizePixel = 0
    searchBox.TextColor3 = settings.textColor
    searchBox.TextSize = settings.fontSize
    searchBox.Font = Enum.Font.SourceSans
    searchBox.PlaceholderText = "Search entities..."
    searchBox.Text = ""
    searchBox.Parent = searchTab
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 4)
    searchCorner.Parent = searchBox
    
    -- Search results container
    local searchResultsContainer = Instance.new("ScrollingFrame")
    searchResultsContainer.Name = "SearchResults"
    searchResultsContainer.Size = UDim2.new(1, 0, 1, -40)
    searchResultsContainer.Position = UDim2.new(0, 0, 0, 40)
    searchResultsContainer.BackgroundTransparency = 1
    searchResultsContainer.BorderSizePixel = 0
    searchResultsContainer.ScrollBarThickness = 4
    searchResultsContainer.Parent = searchTab
    
    local searchResultsLayout = Instance.new("UIListLayout")
    searchResultsLayout.Padding = UDim.new(0, 2)
    searchResultsLayout.Parent = searchResultsContainer
    
    -- GUI Functions
    local closestEntity = nil
    
    -- Create entity card
    local function createEntityCard(entity, parent)
        local card = Instance.new("Frame")
        card.Name = entity.Name .. "Card"
        card.Size = UDim2.new(1, 0, 0, 60)
        card.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        card.BorderSizePixel = 0
        card.Parent = parent
        
        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 4)
        cardCorner.Parent = card
        
        local entityName = Instance.new("TextLabel")
        entityName.Name = "EntityName"
        entityName.Size = UDim2.new(1, -10, 0, 20)
        entityName.Position = UDim2.new(0, 10, 0, 5)
        entityName.BackgroundTransparency = 1
        entityName.TextColor3 = settings.accentColor
        entityName.TextSize = settings.fontSize
        entityName.Font = Enum.Font.SourceSansBold
        entityName.Text = entity.Name
        entityName.TextXAlignment = Enum.TextXAlignment.Left
        entityName.Parent = card
        
        local healthBar = Instance.new("Frame")
        healthBar.Name = "HealthBar"
        healthBar.Size = UDim2.new(1, -20, 0, 10)
        healthBar.Position = UDim2.new(0, 10, 0, 30)
        healthBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        healthBar.BorderSizePixel = 0
        healthBar.Parent = card
        
        local healthBarCorner = Instance.new("UICorner")
        healthBarCorner.CornerRadius = UDim.new(0, 2)
        healthBarCorner.Parent = healthBar
        
        local healthFill = Instance.new("Frame")
        healthFill.Name = "HealthFill"
        healthFill.Size = UDim2.new(entity.Health / entity.MaxHealth, 0, 1, 0)
        healthFill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        healthFill.BorderSizePixel = 0
        healthFill.Parent = healthBar
        
        local healthFillCorner = Instance.new("UICorner")
        healthFillCorner.CornerRadius = UDim.new(0, 2)
        healthFillCorner.Parent = healthFill
        
        local healthText = Instance.new("TextLabel")
        healthText.Name = "HealthText"
        healthText.Size = UDim2.new(1, -10, 0, 15)
        healthText.Position = UDim2.new(0, 10, 0, 42)
        healthText.BackgroundTransparency = 1
        healthText.TextColor3 = settings.textColor
        healthText.TextSize = settings.fontSize - 2
        healthText.Font = Enum.Font.SourceSans
        healthText.Text = string.format("Health: %d / %d", entity.Health, entity.MaxHealth)
        healthText.TextXAlignment = Enum.TextXAlignment.Left
        healthText.Parent = card
        
        -- Click to view details
        card.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- Switch to Selected tab and show this entity's details
                for _, v in pairs(tabContents) do
                    v.Visible = false
                end
                tabContents["Selected"].Visible = true
                for _, v in ipairs(tabs) do
                    v.BackgroundColor3 = settings.backgroundColor
                end
                tabs[3].BackgroundColor3 = settings.accentColor
                
                -- Update selected entity information
                gui:UpdateSelectedInfo(entity)
                selectedEntity = entity -- Store the selected entity
            end
        end)
        
        return card
    end
    
    -- Update selected entity information
    function gui:UpdateSelectedInfo(entity)
        if not entity then return end
        
        selectedNameLabel.Text = "Name: " .. entity.Name
        selectedHealthLabel.Text = string.format("Health: %d / %d", entity.Health, entity.MaxHealth)
        
        -- Calculate distance
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local distance = (character.HumanoidRootPart.Position - entity.Position.Position).Magnitude
            selectedDistanceLabel.Text = string.format("Distance: %.1f studs", distance)
        else
            selectedDistanceLabel.Text = "Distance: N/A"
        end
        
        -- Clear previous details
        for _, child in ipairs(selectedDetailsContainer:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        
        -- Add drops info
        if next(entity.Drops) then
            local dropsTitle = Instance.new("TextLabel")
            dropsTitle.Size = UDim2.new(1, 0, 0, 20)
            dropsTitle.BackgroundTransparency = 1
            dropsTitle.TextColor3 = settings.accentColor
            dropsTitle.TextSize = settings.fontSize
            dropsTitle.Font = Enum.Font.SourceSansBold
            dropsTitle.Text = "Drops:"
            dropsTitle.TextXAlignment = Enum.TextXAlignment.Left
            dropsTitle.Parent = selectedDetailsContainer
            
            if entity.Drops.Coins then
                local coinsText = Instance.new("TextLabel")
                coinsText.Size = UDim2.new(1, 0, 0, 20)
                coinsText.BackgroundTransparency = 1
                coinsText.TextColor3 = settings.textColor
                coinsText.TextSize = settings.fontSize - 2
                coinsText.Font = Enum.Font.SourceSans
                coinsText.Text = string.format("  • Coins: %d-%d (%.0f%% chance)", 
                    entity.Drops.Coins.Min, 
                    entity.Drops.Coins.Max,
                    entity.Drops.Coins.Chance * 100)
                coinsText.TextXAlignment = Enum.TextXAlignment.Left
                coinsText.Parent = selectedDetailsContainer
            end
            
            if entity.Drops.Experience then
                local xpText = Instance.new("TextLabel")
                xpText.Size = UDim2.new(1, 0, 0, 20)
                xpText.BackgroundTransparency = 1
                xpText.TextColor3 = settings.textColor
                xpText.TextSize = settings.fontSize - 2
                xpText.Font = Enum.Font.SourceSans
                xpText.Text = string.format("  • XP: %d-%d", 
                    entity.Drops.Experience.Min, 
                    entity.Drops.Experience.Max)
                xpText.TextXAlignment = Enum.TextXAlignment.Left
                xpText.Parent = selectedDetailsContainer
            end
            
            if entity.Drops.Items and #entity.Drops.Items > 0 then
                local itemsText = Instance.new("TextLabel")
                itemsText.Size = UDim2.new(1, 0, 0, 20)
                itemsText.BackgroundTransparency = 1
                itemsText.TextColor3 = settings.textColor
                itemsText.TextSize = settings.fontSize - 2
                itemsText.Font = Enum.Font.SourceSans
                itemsText.Text = "  • Items: " .. table.concat(entity.Drops.Items, ", ")
                itemsText.TextXAlignment = Enum.TextXAlignment.Left
                itemsText.Parent = selectedDetailsContainer
            end
        end
        
        -- Add resistances
        if next(entity.Resistances) then
            local resistancesTitle = Instance.new("TextLabel")
            resistancesTitle.Size = UDim2.new(1, 0, 0, 20)
            resistancesTitle.BackgroundTransparency = 1
            resistancesTitle.TextColor3 = settings.accentColor
            resistancesTitle.TextSize = settings.fontSize
            resistancesTitle.Font = Enum.Font.SourceSansBold
            resistancesTitle.Text = "Resistances:"
            resistancesTitle.TextXAlignment = Enum.TextXAlignment.Left
            resistancesTitle.Parent = selectedDetailsContainer
            
            for name, value in pairs(entity.Resistances) do
                local resistanceText = Instance.new("TextLabel")
                resistanceText.Size = UDim2.new(1, 0, 0, 20)
                resistanceText.BackgroundTransparency = 1
                resistanceText.TextColor3 = settings.textColor
                resistanceText.TextSize = settings.fontSize - 2
                resistanceText.Font = Enum.Font.SourceSans
                resistanceText.Text = string.format("  • %s: %.0f%%", name, value * 100)
                resistanceText.TextXAlignment = Enum.TextXAlignment.Left
                resistanceText.Parent = selectedDetailsContainer
            end
        end
    end
    
    -- Update closest entity information
    function gui:UpdateClosestInfo(entity)
        if not entity then return end
        
        nameLabel.Text = "Name: " .. entity.Name
        healthLabel.Text = string.format("Health: %d / %d", entity.Health, entity.MaxHealth)
        
        -- Calculate distance
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local distance = (character.HumanoidRootPart.Position - entity.Position.Position).Magnitude
            distanceLabel.Text = string.format("Distance: %.1f studs", distance)
        else
            distanceLabel.Text = "Distance: N/A"
        end
        
        -- Clear previous details
        for _, child in ipairs(detailsContainer:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        
        -- Add drops info
        if next(entity.Drops) then
            local dropsTitle = Instance.new("TextLabel")
            dropsTitle.Size = UDim2.new(1, 0, 0, 20)
            dropsTitle.BackgroundTransparency = 1
            dropsTitle.TextColor3 = settings.accentColor
            dropsTitle.TextSize = settings.fontSize
            dropsTitle.Font = Enum.Font.SourceSansBold
            dropsTitle.Text = "Drops:"
            dropsTitle.TextXAlignment = Enum.TextXAlignment.Left
            dropsTitle.Parent = detailsContainer
            
            if entity.Drops.Coins then
                local coinsText = Instance.new("TextLabel")
                coinsText.Size = UDim2.new(1, 0, 0, 20)
                coinsText.BackgroundTransparency = 1
                coinsText.TextColor3 = settings.textColor
                coinsText.TextSize = settings.fontSize - 2
                coinsText.Font = Enum.Font.SourceSans
                coinsText.Text = string.format("  • Coins: %d-%d (%.0f%% chance)", 
                    entity.Drops.Coins.Min, 
                    entity.Drops.Coins.Max,
                    entity.Drops.Coins.Chance * 100)
                coinsText.TextXAlignment = Enum.TextXAlignment.Left
                coinsText.Parent = detailsContainer
            end
            
            if entity.Drops.Experience then
                local xpText = Instance.new("TextLabel")
                xpText.Size = UDim2.new(1, 0, 0, 20)
                xpText.BackgroundTransparency = 1
                xpText.TextColor3 = settings.textColor
                xpText.TextSize = settings.fontSize - 2
                xpText.Font = Enum.Font.SourceSans
                xpText.Text = string.format("  • XP: %d-%d", 
                    entity.Drops.Experience.Min, 
                    entity.Drops.Experience.Max)
                xpText.TextXAlignment = Enum.TextXAlignment.Left
                xpText.Parent = detailsContainer
            end
            
            if entity.Drops.Items and #entity.Drops.Items > 0 then
                local itemsText = Instance.new("TextLabel")
                itemsText.Size = UDim2.new(1, 0, 0, 20)
                itemsText.BackgroundTransparency = 1
                itemsText.TextColor3 = settings.textColor
                itemsText.TextSize = settings.fontSize - 2
                itemsText.Font = Enum.Font.SourceSans
                itemsText.Text = "  • Items: " .. table.concat(entity.Drops.Items, ", ")
                itemsText.TextXAlignment = Enum.TextXAlignment.Left
                itemsText.Parent = detailsContainer
            end
        end
        
        -- Add resistances
        if next(entity.Resistances) then
            local resistancesTitle = Instance.new("TextLabel")
            resistancesTitle.Size = UDim2.new(1, 0, 0, 20)
            resistancesTitle.BackgroundTransparency = 1
            resistancesTitle.TextColor3 = settings.accentColor
            resistancesTitle.TextSize = settings.fontSize
            resistancesTitle.Font = Enum.Font.SourceSansBold
            resistancesTitle.Text = "Resistances:"
            resistancesTitle.TextXAlignment = Enum.TextXAlignment.Left
            resistancesTitle.Parent = detailsContainer
            
            for name, value in pairs(entity.Resistances) do
                local resistanceText = Instance.new("TextLabel")
                resistanceText.Size = UDim2.new(1, 0, 0, 20)
                resistanceText.BackgroundTransparency = 1
                resistanceText.TextColor3 = settings.textColor
                resistanceText.TextSize = settings.fontSize - 2
                resistanceText.Font = Enum.Font.SourceSans
                resistanceText.Text = string.format("  • %s: %.0f%%", name, value * 100)
                resistanceText.TextXAlignment = Enum.TextXAlignment.Left
                resistanceText.Parent = detailsContainer
            end
        end
        
        -- Store for teleport
        closestEntity = entity
    end
    
    -- Update entity list - Modify to preserve selected tab
    function gui:UpdateEntities()
        -- Remember which tab was visible
        local currentVisibleTab = nil
        for name, tab in pairs(tabContents) do
            if tab.Visible then
                currentVisibleTab = name
                break
            end
        end
        
        -- Clear existing entities
        for _, child in ipairs(allEntitiesTab:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        -- Get entities
        local entities = EntityInfo.GetAllEntities()
        if #entities == 0 then
            local noEntitiesLabel = Instance.new("TextLabel")
            noEntitiesLabel.Size = UDim2.new(1, 0, 0, 30)
            noEntitiesLabel.BackgroundTransparency = 1
            noEntitiesLabel.TextColor3 = settings.warningColor
            noEntitiesLabel.TextSize = settings.fontSize
            noEntitiesLabel.Font = Enum.Font.SourceSans
            noEntitiesLabel.Text = "No entities found"
            noEntitiesLabel.Parent = allEntitiesTab
            return
        end
        
        -- Find closest entity
        local closestEntityData = nil
        local closestDistance = math.huge
        local character = LocalPlayer.Character
        
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPos = character.HumanoidRootPart.Position
            
            for _, entity in ipairs(entities) do
                local distance = (rootPos - entity.Position.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestEntityData = entity
                end
            end
        end
        
        -- Limit to max entities shown
        local shownEntities = {}
        for i = 1, math.min(#entities, settings.maxEntitiesShown) do
            table.insert(shownEntities, entities[i])
        end
        
        -- Create entity cards
        for _, entity in ipairs(shownEntities) do
            createEntityCard(entity, allEntitiesTab)
        end
        
        -- Update closest entity info if found
        if closestEntityData then
            gui:UpdateClosestInfo(closestEntityData)
        end
        
        -- Update selected entity info if exists
        if selectedEntity then
            -- Find the entity in the updated list
            for _, entity in ipairs(entities) do
                if entity.Name == selectedEntity.Name then
                    gui:UpdateSelectedInfo(entity)
                    selectedEntity = entity
                    break
                end
            end
        end
        
        -- Update layout
        allEntitiesTab.CanvasSize = UDim2.new(0, 0, 0, entityListLayout.AbsoluteContentSize.Y + 10)
        
        -- Restore the previously visible tab
        if currentVisibleTab and currentVisibleTab ~= "All Entities" then
            for _, tab in pairs(tabContents) do
                tab.Visible = false
            end
            tabContents[currentVisibleTab].Visible = true
            
            -- Update tab button colors
            for i, v in ipairs(tabs) do
                v.BackgroundColor3 = settings.backgroundColor
            end
            
            -- Set the correct tab button color
            if currentVisibleTab == "All Entities" then
                tabs[1].BackgroundColor3 = settings.accentColor
            elseif currentVisibleTab == "Closest" then
                tabs[2].BackgroundColor3 = settings.accentColor
            elseif currentVisibleTab == "Selected" then
                tabs[3].BackgroundColor3 = settings.accentColor
            elseif currentVisibleTab == "Search" then
                tabs[4].BackgroundColor3 = settings.accentColor
            end
        end
    end
    
    -- Search function
    local function updateSearch()
        -- Clear search results
        for _, child in ipairs(searchResultsContainer:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        local searchTerm = string.lower(searchBox.Text)
        if searchTerm == "" then return end
        
        -- Get entities
        local entities = EntityInfo.GetAllEntities()
        local results = {}
        
        -- Filter entities by search term
        for _, entity in ipairs(entities) do
            if string.find(string.lower(entity.Name), searchTerm) then
                table.insert(results, entity)
            end
        end
        
        if #results == 0 then
            local noResultsLabel = Instance.new("TextLabel")
            noResultsLabel.Size = UDim2.new(1, 0, 0, 30)
            noResultsLabel.BackgroundTransparency = 1
            noResultsLabel.TextColor3 = settings.warningColor
            noResultsLabel.TextSize = settings.fontSize
            noResultsLabel.Font = Enum.Font.SourceSans
            noResultsLabel.Text = "No results found"
            noResultsLabel.Parent = searchResultsContainer
            return
        end
        
        -- Create entity cards for search results
        for _, entity in ipairs(results) do
            createEntityCard(entity, searchResultsContainer)
        end
        
        -- Update layout
        searchResultsContainer.CanvasSize = UDim2.new(0, 0, 0, searchResultsLayout.AbsoluteContentSize.Y + 10)
    end
    
    searchBox.Changed:Connect(function(property)
        if property == "Text" then
            updateSearch()
        end
    end)
    
    -- Teleport button functionality for both closest and selected
    tpButton.MouseButton1Click:Connect(function()
        if closestEntity and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Calculate safe position (slightly above the entity)
            local targetPos = closestEntity.Position.Position + Vector3.new(0, 5, 0)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
        end
    end)
    
    selectedTpButton.MouseButton1Click:Connect(function()
        if selectedEntity and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Calculate safe position (slightly above the entity)
            local targetPos = selectedEntity.Position.Position + Vector3.new(0, 5, 0)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
        end
    end)
    
    -- Toggle GUI with key
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == settings.toggleKey then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)
    
    -- Initial update
    gui:UpdateEntities()
    
    -- Set up recurring updates
    spawn(function()
        while true do
            wait(settings.updateInterval)
            pcall(function() gui:UpdateEntities() end)
        end
    end)
end

-- Create and show the GUI
gui:Create()

-- Return the module
return {
    ToggleGui = function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("BlueHeaterEntityGUI")
        if gui then
            gui.Enabled = not gui.Enabled
        else
            -- Re-create GUI if not found
            pcall(function() gui:Create() end)
        end
    end
} 