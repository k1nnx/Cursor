-- Function that collects and returns all entity data
local function GetEntityData()
    local entityData = {}
    local children = workspace:WaitForChild("SpawnedEntities"):GetChildren()

    for _, entity in ipairs(children) do
        local humanoid = entity:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local entityInfo = {
                Name = entity.Name,
                Health = humanoid.Health,
                MaxHealth = humanoid.MaxHealth,
                Position = entity.WorldPivot,
                Drops = {},
                Resistances = {},
                Values = {}
            }
            
            local info = entity:FindFirstChild("Info")
            if info then
                local drops = info:FindFirstChild("Drops")
                local resistances = info:FindFirstChild("Resistances")
                local values = info:FindFirstChild("Values")
                
                if drops then
                    entityInfo.Drops = {
                        Coins = drops:GetAttribute("Coins"),
                        CoinsChance = drops:GetAttribute("CoinsChance"),
                        Experience = drops:GetAttribute("Experience"),
                        Level = drops:GetAttribute("Level"),
                        Items = {}
                    }
                    
                    for _, drop in ipairs(drops:GetChildren()) do
                        table.insert(entityInfo.Drops.Items, drop.Name)
                    end
                end
                
                if resistances then
                    for _, resistance in ipairs(resistances:GetChildren()) do
                        entityInfo.Resistances[resistance.Name] = resistance.Value
                    end
                end
            
                if values then
                    for _, value in ipairs(values:GetChildren()) do
                        entityInfo.Values[value.Name] = value.Value
                    end
                end
            end
            
            table.insert(entityData, entityInfo)
        end
    end
    
    return entityData
end

-- Return the function so it can be called from loadstring
return GetEntityData
