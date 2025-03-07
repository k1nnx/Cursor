function getAlive()
    local alive = workspace:WaitForChild('Alive')
    for _, alive in alive:GetChildren() do
        if not game:GetService('Players'):GetPlayerFromCharacter(alive) then
            table.insert(getAlive, alive)
        end
    end
    return getAlive
end

