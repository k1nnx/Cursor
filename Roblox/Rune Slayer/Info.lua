function GetAlive()
    local alive = {}
    for i, v in pairs(workspace:WaitForChild("Alive"):GetChildren()) do
        if not game:GetService("Players"):GetPlayerFromCharacter(v) then
            table.insert(alive, v)
        end
    end
    return alive
end

function gethumanoid()
    local humanoid = {}
    for i, v in pairs(GetAlive()) do
        table.insert(humanoid, v:WaitForChild("Humanoid"))
    end
    return humanoid
end

