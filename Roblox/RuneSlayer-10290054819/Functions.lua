function getAlive()
    local aliveTable = {}  -- Create a table to store results
    local alive = workspace:WaitForChild('Alive')
    for _, model in alive:GetChildren() do
        if not game:GetService('Players'):GetPlayerFromCharacter(model) then
            table.insert(aliveTable, model)
        end
    end
    return aliveTable
end
