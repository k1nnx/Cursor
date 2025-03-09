--[[
    Alive.lua
    Contains functions for getting information about alive entities in the workspace
]]

-- Returns a table of all models in the workspace.Alive folder
function getAlive()
    local aliveTable = {}
    for _, model in workspace.Alive:GetChildren() do
        table.insert(aliveTable, model)
    end
    return aliveTable
end

-- Returns a table of all non-player models (mobs) from alive entities
function getMob()
    local mobinfo = {}
    for _, model in getAlive() do
        if not game:GetService('Players'):GetPlayerFromCharacter(model) then
            table.insert(mobinfo, model)
        end
    end
    return mobinfo
end

-- Returns a table of all player models from alive entities
function getPlayer()
    local playerinfo = {}
    for _, model in getAlive() do
        if game:GetService('Players'):GetPlayerFromCharacter(model) then
            table.insert(playerinfo, model)
        end
    end
    return playerinfo
end

-- Returns a table of attributes for all mob models
function getMobInfo()
    local mobinfo = {}
    for _, model in getMob() do
        local attributes = model:GetAttributes()
        table.insert(mobinfo, attributes)
    end
    return mobinfo
end