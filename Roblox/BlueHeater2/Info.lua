local function GetEntityInfo()
    local entityInfos = {}
    local children = workspace:WaitForChild("SpawnedEntities"):GetChildren()

    for _, entity in ipairs(children) do
        local humanoid = entity:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local entityData = {
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
                    entityData.Drops = {
                        Coins = {
                            Min = drops:GetAttribute("Coins").Min,
                            Max = drops:GetAttribute("Coins").Max,
                            Chance = drops:GetAttribute("CoinsChance")
                        },
                        Experience = {
                            Min = drops:GetAttribute("Experience").Min,
                            Max = drops:GetAttribute("Experience").Max
                        },
                        Level = {
                            Min = drops:GetAttribute("Level").Min,
                            Max = drops:GetAttribute("Level").Max
                        },
                        Items = {}
                    }
                    
                    for _, drop in ipairs(drops:GetChildren()) do
                        table.insert(entityData.Drops.Items, drop.Name)
                    end
                end
                
                if resistances then
                    for _, resistance in ipairs(resistances:GetChildren()) do
                        entityData.Resistances[resistance.Name] = resistance.Value
                    end
                end
            
                if values then
                    for _, value in ipairs(values:GetChildren()) do
                        entityData.Values[value.Name] = value.Value
                    end
                end
            end
            
            table.insert(entityInfos, entityData)
        end
    end
    
    return entityInfos
end

return GetEntityInfo()
