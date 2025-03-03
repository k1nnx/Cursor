local children = workspace:WaitForChild("SpawnedEntities"):GetChildren()

for _, entity in ipairs(children) do
    local humanoid = entity:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local info = entity:FindFirstChild("Info")
        local position = entity.WorldPivot
        
        print("Entity:", entity.Name)
        print("Health:", humanoid.Health .. "/" .. humanoid.MaxHealth)
        print("Position:", tostring(position))
        
        if info then
            local drops = info:FindFirstChild("Drops")
            local resistances = info:FindFirstChild("Resistances")
            local values = info:FindFirstChild("Values")
            
            if drops then
                local coins = drops:GetAttribute("Coins")
                local coinsChance = drops:GetAttribute("CoinsChance")
                local experience = drops:GetAttribute("Experience")
                local level = drops:GetAttribute("Level")
                local dropItems = drops:GetChildren()
                
                print("----")
                print("CoinsMin:", coins.Min)
                print("CoinsMax:", coins.Max)
                print("CoinsChance:", coinsChance)
                print("----")
                print("ExperienceMin:", experience.Min)
                print("ExperienceMax:", experience.Max)
                print("----")
                print("LevelMin:", level.Min)
                print("LevelMax:", level.Max)
                print("----")
                
                print("Drops:")
                for _, drop in ipairs(dropItems) do
                    print(drop.Name)
                end
                print("----")
            end
            
            if resistances then
                print("Resistances:")
                for _, resistance in ipairs(resistances:GetChildren()) do
                    print(resistance.Name .. ": " .. resistance.Value)
                end
                print("----")
            end
        
            if values then
                print("Values:")
                for _, value in ipairs(values:GetChildren()) do
                    print(value.Name .. ": " .. tostring(value.Value))
                end
            end
        end
        print("--------------------------------")
    end
end
