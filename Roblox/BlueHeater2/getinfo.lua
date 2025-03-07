function Spawned()
    return workspace:WaitForChild('SpawnedEntities'):GetChildren()
end

function Health()
    return Spawned():WaitForChild('Humanoid').Health
end

for _, entity in ipairs(Health()) do
    print(entity)
end
