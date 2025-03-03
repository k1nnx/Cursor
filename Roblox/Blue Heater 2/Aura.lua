local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local spawnedEntities = workspace:WaitForChild("SpawnedEntities")
local closestEntity = nil
local closestDistance = math.huge
local MAX_DISTANCE = 10 -- Maximum distance to target entities

for _, entity in ipairs(spawnedEntities:GetChildren()) do
    if entity:IsA("Model") then
        local entityHRP = entity:FindFirstChild("HumanoidRootPart")
        local entityHumanoid = entity:FindFirstChild("Humanoid")
        if entityHRP and entityHumanoid then
            local distance = (hrp.Position - entityHRP.Position).Magnitude
            if distance <= MAX_DISTANCE and distance < closestDistance then
                closestDistance = distance
                closestEntity = entity
            end
        end
    end
end

local args = {
    [1] = closestEntity
}

-- Extract info from the closest entity
if closestEntity then
    -- Get the Humanoid directly
    local humanoid = closestEntity:FindFirstChildOfClass("Humanoid")
    
    local entityInfo = {
        Name = closestEntity.Name,
        Distance = closestDistance,
        Health = humanoid and humanoid.Health or "N/A",
        MaxHealth = humanoid and humanoid.MaxHealth or "N/A",
        Drops = {},
        Resistances = {}
    }
    
    -- Get Info.Drops and Info.Resistances
    local infoModule = closestEntity:FindFirstChild("Info")
    if infoModule then
        print("Target Info for:", entityInfo.Name)
        print("Health:", entityInfo.Health, "/", entityInfo.MaxHealth)
        
        -- Get drops information
        local dropsInstance = infoModule:FindFirstChild("Drops")
        if dropsInstance then
            print("  Drops:")
            local dropChildren = dropsInstance:GetChildren()
            if #dropChildren > 0 then
                for _, dropChild in ipairs(dropChildren) do
                    local value = "N/A"
                    if dropChild:IsA("StringValue") or dropChild:IsA("NumberValue") or 
                       dropChild:IsA("IntValue") or dropChild:IsA("BoolValue") then
                        value = dropChild.Value
                    end
                    entityInfo.Drops[dropChild.Name] = value
                    print("    " .. dropChild.Name .. ": " .. tostring(value))
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
            local resistanceChildren = resistancesInstance:GetChildren()
            if #resistanceChildren > 0 then
                for _, resistanceChild in ipairs(resistanceChildren) do
                    local value = "N/A"
                    if resistanceChild:IsA("StringValue") or resistanceChild:IsA("NumberValue") or 
                       resistanceChild:IsA("IntValue") or resistanceChild:IsA("BoolValue") then
                        value = resistanceChild.Value
                    end
                    entityInfo.Resistances[resistanceChild.Name] = value
                    print("    " .. resistanceChild.Name .. ": " .. tostring(value))
                end
            else
                print("    No resistance children found")
            end
        else
            print("  No resistances information found.")
        end
    else
        print("No Info module found for this entity:", closestEntity.Name)
    end
    
    -- You can return entityInfo or use it here
    -- For example, store it in a global variable for later use
    _G.CurrentTargetInfo = entityInfo
    
    game:GetService("ReplicatedStorage"):WaitForChild("PlayerEvents"):WaitForChild("EntityHit"):FireServer(unpack(args))
end
