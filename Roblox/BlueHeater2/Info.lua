for _, entity in workspace:WaitForChild("SpawnedEntities"):GetChildren() do
    local primarypart = entity.PrimaryPart
    local position = entity.WorldPivot.Position
    local looking = entity.WorldPivot.LookVector
    if entity:FindFirstChild("Humanoid") then
        local humanoid = entity.Humanoid
        local currenthealth = humanoid.Health
        local maxhealth = humanoid.MaxHealth
    end
    if entity:FindFirstChild("Info") then
        local info = entity.Info
        if info:FindFirstChild("Abilities") then
        for _, abilities in info.Abilities:GetChildren() do
                local ability = abilities.Name
            end
        end
        if info:FindFirstChild("Drops") then
            for _, drops in info.Drops:GetChildren() do
                local drop = drops.Name
            end
        end
    end
end
