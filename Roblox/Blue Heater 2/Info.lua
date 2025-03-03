-- Function to get the closest entity with Humanoid and its info
local function GetClosestEntityInfo()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        warn("Character or HumanoidRootPart not found")
        return nil
    end
    
    local playerPosition = character.HumanoidRootPart.Position
    local entitiesWithHumanoids = {}
    local spawnedEntities = workspace:WaitForChild("SpawnedEntities")
    
    -- Find all entities with Humanoids
    for _, entity in pairs(spawnedEntities:GetChildren()) do
        if entity:FindFirstChildOfClass("Humanoid") then
            table.insert(entitiesWithHumanoids, entity)
        end
    end
    
    if #entitiesWithHumanoids == 0 then
        warn("No entities with Humanoids found")
        return nil
    end
    
    -- Find the closest entity
    local closestEntity = nil
    local closestDistance = math.huge
    
    for _, entity in ipairs(entitiesWithHumanoids) do
        if entity:FindFirstChild("HumanoidRootPart") then
            local distance = (entity.HumanoidRootPart.Position - playerPosition).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestEntity = entity
            end
        end
    end
    
    if not closestEntity then
        warn("No entities with HumanoidRootPart found")
        return nil
    end
    
    -- Extract info from closest entity
    local entityInfo = {
        Name = closestEntity.Name,
        Distance = closestDistance,
        Health = closestEntity.Humanoid.Health,
        MaxHealth = closestEntity.Humanoid.MaxHealth,
        Drops = {},
        Resistances = {}
    }
    
    -- Get Info.Drops and Info.Resistances
    local infoModule = closestEntity:FindFirstChild("Info")
    if infoModule then
        -- Get drops information
        local dropsInstance = infoModule:FindFirstChild("Drops")
        if dropsInstance then
            local dropChildren = dropsInstance:GetChildren()
            for _, dropChild in ipairs(dropChildren) do
                local value = "N/A"
                if dropChild:IsA("StringValue") or dropChild:IsA("NumberValue") or 
                   dropChild:IsA("IntValue") or dropChild:IsA("BoolValue") then
                    value = dropChild.Value
                end
                entityInfo.Drops[dropChild.Name] = value
            end
        end
        
        -- Get resistances information
        local resistancesInstance = infoModule:FindFirstChild("Resistances")
        if resistancesInstance then
            local resistanceChildren = resistancesInstance:GetChildren()
            for _, resistanceChild in ipairs(resistanceChildren) do
                local value = "N/A"
                if resistanceChild:IsA("StringValue") or resistanceChild:IsA("NumberValue") or 
                   resistanceChild:IsA("IntValue") or resistanceChild:IsA("BoolValue") then
                    value = resistanceChild.Value
                end
                entityInfo.Resistances[resistanceChild.Name] = value
            end
        end
    end
    
    return closestEntity, entityInfo
end

-- For debugging - prints out the info after finding it
local function PrintEntityInfo()
    local entity, info = GetClosestEntityInfo()
    if not entity or not info then
        warn("No entity found or error occurred")
        return
    end
    
    print("Closest Entity:", info.Name, "Distance:", info.Distance)
    print("Health:", info.Health, "/", info.MaxHealth)
    
    print("Drops:")
    for dropName, dropValue in pairs(info.Drops) do
        print("  " .. dropName .. ": " .. tostring(dropValue))
    end
    
    print("Resistances:")
    for resistName, resistValue in pairs(info.Resistances) do
        print("  " .. resistName .. ": " .. tostring(resistValue))
    end
end

-- For loadstring usage, return the GetClosestEntityInfo function
return {
    GetClosestEntityInfo = GetClosestEntityInfo,
    PrintEntityInfo = PrintEntityInfo
}

-- Original code for reference (Commented out)
--[[
local args = {
    [1] = workspace:WaitForChild("SpawnedEntities")
}

-- Get all entities with Humanoids
local entitiesWithHumanoids = {}
local spawnedEntities = workspace:WaitForChild("SpawnedEntities")
for _, entity in pairs(spawnedEntities:GetChildren()) do
    if entity:FindFirstChildOfClass("Humanoid") then
        table.insert(entitiesWithHumanoids, entity)
    end
end

-- Now you can use entitiesWithHumanoids table which contains all entities with Humanoids
-- For example, to print them:
for _, entity in ipairs(entitiesWithHumanoids) do
    print("Entity with Humanoid:", entity.Name)
    
    -- Get Info.Drops and Info.Resistances for each entity
    local infoModule = entity:FindFirstChild("Info")
    if infoModule then
        -- Get drops information
        local dropsInstance = infoModule:FindFirstChild("Drops")
        if dropsInstance then
            print("  Drops:")
            -- Get children of the Drops instance
            local dropChildren = dropsInstance:GetChildren()
            if #dropChildren > 0 then
                for _, dropChild in ipairs(dropChildren) do
                    local value = "N/A"
                    if dropChild:IsA("StringValue") or dropChild:IsA("NumberValue") or 
                       dropChild:IsA("IntValue") or dropChild:IsA("BoolValue") then
                        value = tostring(dropChild.Value)
                    end
                    print("    " .. dropChild.Name .. ": " .. value)
                end
            else
                print("    No drop children found")
            end
        else
            print("  No drops information found.")
        end
        
        -- Get resistances information
        local resistancesInstance = infoModule:FindFirstChild("Resistances")
        if resistancesInstance then
            print("  Resistances:")
            -- Get children of the Resistances instance
            local resistanceChildren = resistancesInstance:GetChildren()
            if #resistanceChildren > 0 then
                for _, resistanceChild in ipairs(resistanceChildren) do
                    local value = "N/A"
                    if resistanceChild:IsA("StringValue") or resistanceChild:IsA("NumberValue") or 
                       resistanceChild:IsA("IntValue") or resistanceChild:IsA("BoolValue") then
                        value = tostring(resistanceChild.Value)
                    end
                    print("    " .. resistanceChild.Name .. ": " .. value)
                end
            else
                print("    No resistance children found")
            end
        else
            print("  No resistances information found.")
        end
    else
        print("  No Info module found for this entity.")
    end
    
    print("") -- Empty line for better readability
end

game:GetService("ReplicatedStorage"):WaitForChild("PlayerEvents"):WaitForChild("EntityHit"):FireServer(unpack(args))
]]--
