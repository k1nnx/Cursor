-- EntityNameTags.lua
-- Creates floating name tags above entities in BlueHeater2

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Create or get the BlueHeaterAPI
if not _G.BlueHeaterAPI then
    -- Try to load the API if not already present
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/k1nnx/Cursor/refs/heads/main/Roblox/BlueHeater2/Info.lua?token=GHSAT0AAAAAAC74ORH3ZPIOFRELBCYCSVO4Z6GJZ7A"))()
    end)
    
    if not _G.BlueHeaterAPI then
        _G.BlueHeaterAPI = {}
        _G.BlueHeaterAPI.EntityInfo = {
            GetAllEntities = function() return {} end,
            FindEntityByName = function() return nil end
        }
        warn("BlueHeater2 API not loaded. Name tags may not work properly.")
    end
end

local EntityInfo = _G.BlueHeaterAPI.EntityInfo

-- Configuration
local config = {
    updateInterval = 0.5, -- How often to update in seconds
    tagHeight = 2.5, -- Height above the entity
    tagWidth = 120, -- Width of the tag
    tagHeight = 50, -- Height of the tag
    maxViewDistance = 100, -- Maximum distance to show tag
    nameColor = Color3.fromRGB(0, 170, 255), -- Color for entity names
    healthBarBgColor = Color3.fromRGB(40, 40, 40), -- Background color for health bar
    healthBarColor = Color3.fromRGB(46, 204, 113), -- Color for health bar
    textColor = Color3.fromRGB(255, 255, 255), -- Color for normal text
    rarityColors = {
        Common = Color3.fromRGB(180, 180, 180),
        Uncommon = Color3.fromRGB(100, 255, 100),
        Rare = Color3.fromRGB(30, 144, 255),
        Epic = Color3.fromRGB(138, 43, 226),
        Legendary = Color3.fromRGB(255, 165, 0),
        Mythic = Color3.fromRGB(255, 0, 0)
    },
    fontSize = 14,
    showDistance = true,
    showLevel = true,
    showHealth = true,
    showResistances = false, -- Set to true to show resistances on the tag
}

-- Namespace
local NameTags = {}
local activeTags = {}

-- Print debug message
local function debugPrint(...)
    if config.debug then
        print("[NameTags]", ...)
    end
end

-- Get rarity color based on entity level
local function getRarityColor(entity)
    if not entity.Drops or not entity.Drops.Level then
        return config.rarityColors.Common
    end
    
    local maxLevel = entity.Drops.Level.Max or 1
    
    if maxLevel >= 50 then
        return config.rarityColors.Mythic
    elseif maxLevel >= 30 then
        return config.rarityColors.Legendary
    elseif maxLevel >= 20 then
        return config.rarityColors.Epic
    elseif maxLevel >= 10 then
        return config.rarityColors.Rare
    elseif maxLevel >= 5 then
        return config.rarityColors.Uncommon
    else
        return config.rarityColors.Common
    end
end

-- Format a value with appropriate suffix (K, M, B)
local function formatValue(value)
    if value >= 1000000000 then
        return string.format("%.1fB", value / 1000000000)
    elseif value >= 1000000 then
        return string.format("%.1fM", value / 1000000)
    elseif value >= 1000 then
        return string.format("%.1fK", value / 1000)
    else
        return tostring(value)
    end
end

-- Find entities directly in the workspace
local function findEntitiesInWorkspace()
    local entities = {}
    local function searchFolder(folder)
        for _, child in ipairs(folder:GetChildren()) do
            if child:FindFirstChildOfClass("Humanoid") then
                entities[#entities+1] = child
            end
            if #child:GetChildren() > 0 and not child:FindFirstChildOfClass("Humanoid") then
                searchFolder(child)
            end
        end
    end
    
    -- Check for a SpawnedEntities folder first
    local spawnedEntities = workspace:FindFirstChild("SpawnedEntities")
    if spawnedEntities then
        searchFolder(spawnedEntities)
    else
        -- If no specific folder, search the whole workspace
        searchFolder(workspace)
    end
    
    return entities
end

-- Create a new name tag for an entity model
function NameTags:CreateNameTagForModel(model)
    -- Check if already has a tag
    if activeTags[model.Name] then
        return
    end
    
    -- Find the HumanoidRootPart or primary part to attach to
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local attachPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model.PrimaryPart
    if not attachPart then
        for _, part in ipairs(model:GetChildren()) do
            if part:IsA("BasePart") then
                attachPart = part
                break
            end
        end
    end
    if not attachPart then return end
    
    -- Create entity data from model
    local entityData = {
        Name = model.Name,
        Health = humanoid.Health,
        MaxHealth = humanoid.MaxHealth,
        Position = model:GetPivot(),
        Drops = {},
        Resistances = {}
    }
    
    -- Try to find Info object for additional data
    local infoFolder = model:FindFirstChild("Info")
    if infoFolder then
        local drops = infoFolder:FindFirstChild("Drops")
        if drops then
            entityData.Drops = {
                Level = {
                    Min = drops:GetAttribute("Level") and drops:GetAttribute("Level").Min or 1,
                    Max = drops:GetAttribute("Level") and drops:GetAttribute("Level").Max or 5
                }
            }
        end
        
        local resistances = infoFolder:FindFirstChild("Resistances")
        if resistances then
            for _, resistance in ipairs(resistances:GetChildren()) do
                entityData.Resistances[resistance.Name] = resistance.Value
            end
        end
    end
    
    -- Create Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "EntityNameTag"
    billboard.Size = UDim2.new(0, config.tagWidth, 0, config.tagHeight)
    billboard.StudsOffset = Vector3.new(0, config.tagHeight, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = config.maxViewDistance
    billboard.Adornee = attachPart
    
    -- Container frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = billboard
    
    -- Name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, config.fontSize + 4)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = getRarityColor(entityData)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextSize = config.fontSize + 2
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = entityData.Name
    nameLabel.Parent = mainFrame
    
    -- Health bar background
    local healthBarBg = Instance.new("Frame")
    healthBarBg.Name = "HealthBarBg"
    healthBarBg.Size = UDim2.new(1, 0, 0, 6)
    healthBarBg.Position = UDim2.new(0, 0, 0, config.fontSize + 6)
    healthBarBg.BackgroundColor3 = config.healthBarBgColor
    healthBarBg.BorderSizePixel = 0
    healthBarBg.Parent = mainFrame
    
    -- Health bar
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(entityData.Health / entityData.MaxHealth, 0, 1, 0)
    healthBar.BackgroundColor3 = config.healthBarColor
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBarBg
    
    -- Health text
    local healthText = Instance.new("TextLabel")
    healthText.Name = "HealthText"
    healthText.Size = UDim2.new(1, 0, 0, config.fontSize)
    healthText.Position = UDim2.new(0, 0, 0, config.fontSize + 14)
    healthText.BackgroundTransparency = 1
    healthText.TextColor3 = config.textColor
    healthText.TextStrokeTransparency = 0.5
    healthText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    healthText.TextSize = config.fontSize
    healthText.Font = Enum.Font.SourceSans
    healthText.Text = formatValue(entityData.Health) .. "/" .. formatValue(entityData.MaxHealth)
    healthText.Parent = mainFrame
    
    -- Info text (distance, level, etc.)
    local infoText = Instance.new("TextLabel")
    infoText.Name = "InfoText"
    infoText.Size = UDim2.new(1, 0, 0, config.fontSize)
    infoText.Position = UDim2.new(0, 0, 0, config.fontSize + 26)
    infoText.BackgroundTransparency = 1
    infoText.TextColor3 = config.textColor
    infoText.TextStrokeTransparency = 0.5
    infoText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    infoText.TextSize = config.fontSize - 2
    infoText.Font = Enum.Font.SourceSans
    
    -- Calculate distance
    local distance = "N/A"
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
        local entityPos = attachPart.Position
        distance = string.format("%.1f", (playerPos - entityPos).Magnitude)
    end
    
    -- Update info text
    local infoString = ""
    if config.showDistance then
        infoString = infoString .. distance .. " studs"
    end
    
    if config.showLevel and entityData.Drops and entityData.Drops.Level then
        if infoString ~= "" then infoString = infoString .. " | " end
        infoString = infoString .. "Lvl " .. entityData.Drops.Level.Min .. "-" .. entityData.Drops.Level.Max
    end
    
    infoText.Text = infoString
    infoText.Parent = mainFrame
    
    -- Store in active tags
    activeTags[model.Name] = {
        billboard = billboard,
        nameLabel = nameLabel,
        healthBar = healthBar,
        healthText = healthText,
        infoText = infoText,
        model = model,
        humanoid = humanoid,
        attachPart = attachPart
    }
    
    -- Parent billboard to PlayerGui
    billboard.Parent = LocalPlayer.PlayerGui
    
    debugPrint("Created tag for:", model.Name)
    return billboard
end

-- Update an existing name tag
function NameTags:UpdateNameTag(tag)
    if not tag or not tag.model or not tag.model.Parent then
        -- Model was destroyed
        self:RemoveNameTag(tag.model.Name)
        return
    end
    
    local model = tag.model
    local humanoid = tag.humanoid
    
    if not humanoid or not humanoid.Parent then
        self:RemoveNameTag(model.Name)
        return
    end
    
    -- Update health bar
    local healthRatio = humanoid.Health / humanoid.MaxHealth
    tag.healthBar.Size = UDim2.new(healthRatio, 0, 1, 0)
    tag.healthText.Text = formatValue(humanoid.Health) .. "/" .. formatValue(humanoid.MaxHealth)
    
    -- Update color based on level/rarity
    local entityData = {
        Drops = {}
    }
    
    local infoFolder = model:FindFirstChild("Info")
    if infoFolder then
        local drops = infoFolder:FindFirstChild("Drops")
        if drops then
            entityData.Drops.Level = {
                Min = drops:GetAttribute("Level") and drops:GetAttribute("Level").Min or 1,
                Max = drops:GetAttribute("Level") and drops:GetAttribute("Level").Max or 5
            }
        end
    end
    
    tag.nameLabel.TextColor3 = getRarityColor(entityData)
    
    -- Calculate distance
    local distance = "N/A"
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and tag.attachPart then
        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
        local entityPos = tag.attachPart.Position
        distance = string.format("%.1f", (playerPos - entityPos).Magnitude)
    end
    
    -- Update info text
    local infoString = ""
    if config.showDistance then
        infoString = infoString .. distance .. " studs"
    end
    
    if config.showLevel and entityData.Drops and entityData.Drops.Level then
        if infoString ~= "" then infoString = infoString .. " | " end
        infoString = infoString .. "Lvl " .. entityData.Drops.Level.Min .. "-" .. entityData.Drops.Level.Max
    end
    
    tag.infoText.Text = infoString
end

-- Remove a name tag
function NameTags:RemoveNameTag(entityName)
    if activeTags[entityName] then
        pcall(function()
            activeTags[entityName].billboard:Destroy()
        end)
        activeTags[entityName] = nil
    end
end

-- Main update function
function NameTags:Update()
    -- Find all entity models in the workspace
    local entityModels = findEntitiesInWorkspace()
    local modelCount = #entityModels
    
    if modelCount == 0 then
        print("No entity models found in workspace")
        return
    end
    
    -- Track entities that still exist to remove old ones
    local existingEntities = {}
    local tagsCreated = 0
    
    -- Create or update tags for each model
    for _, model in ipairs(entityModels) do
        existingEntities[model.Name] = true
        
        -- Create tag if it doesn't exist
        if not activeTags[model.Name] then
            self:CreateNameTagForModel(model)
            tagsCreated = tagsCreated + 1
        end
        
        -- Update existing tag
        if activeTags[model.Name] then
            self:UpdateNameTag(activeTags[model.Name])
        end
    end
    
    -- Remove tags for entities that no longer exist
    for entityName in pairs(activeTags) do
        if not existingEntities[entityName] then
            self:RemoveNameTag(entityName)
        end
    end
    
    -- Output debug info once
    if self.firstUpdate then
        print("Name Tags Debug:")
        print("- Entity models found: " .. modelCount)
        print("- Tags created: " .. tagsCreated)
        self.firstUpdate = false
    end
end

-- Toggle name tags on/off
function NameTags:Toggle()
    self.enabled = not self.enabled
    
    if self.enabled then
        -- Start updating
        if not self.updateConnection then
            self.updateConnection = RunService.Heartbeat:Connect(function()
                if os.clock() - (self.lastUpdate or 0) >= config.updateInterval then
                    self.lastUpdate = os.clock()
                    pcall(function() self:Update() end)
                end
            end)
        end
        
        -- Show existing tags
        for _, tag in pairs(activeTags) do
            tag.billboard.Enabled = true
        end
        
        print("Name tags enabled")
    else
        -- Hide existing tags
        for _, tag in pairs(activeTags) do
            tag.billboard.Enabled = false
        end
        
        print("Name tags disabled")
    end
    
    return self.enabled
end

-- Clean up all tags
function NameTags:CleanUp()
    -- Disconnect update loop
    if self.updateConnection then
        self.updateConnection:Disconnect()
        self.updateConnection = nil
    end
    
    -- Remove all tags
    for entityName in pairs(activeTags) do
        self:RemoveNameTag(entityName)
    end
end

-- Initialize
NameTags.enabled = false
NameTags.lastUpdate = 0
NameTags.firstUpdate = true  -- For debug info

-- Add keyboard toggle (press N to toggle name tags)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.N then
        local status = NameTags:Toggle()
        -- Notify player of current status
        game.StarterGui:SetCore("SendNotification", {
            Title = "Entity Name Tags",
            Text = status and "Enabled" or "Disabled",
            Duration = 2
        })
    end
end)

-- Force a direct update call to debug any issues
spawn(function()
    wait(1) -- Wait a second for everything to load
    print("EntityNameTags: Starting initial scan...")
    NameTags:Update()
    print("EntityNameTags: Initial scan complete")
    
    -- Start enabled by default
    NameTags:Toggle()
end)

-- Return the module for API access
return NameTags 