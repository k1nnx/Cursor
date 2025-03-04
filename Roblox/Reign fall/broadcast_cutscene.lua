-- Script to call the broadcast cutscene function
-- Using the decompiled function provided by the user

-- Load the broadcast cutscene function from ReplicatedStorage
local BroadcastCutscene = require(game.ReplicatedStorage.Functions.BroadcastCutscene)

-- Print info about what we're doing
print("Attempting to broadcast cutscene...")

-- Option 1: Broadcast to all players
local function broadcastToAll()
    print("Broadcasting cutscene to ALL players")
    
    -- Create a sample cutscene data table
    local cutsceneData = {
        name = "ForcedCutscene",
        duration = 10,
        camera = {
            position = Vector3.new(0, 10, 0),
            lookAt = Vector3.new(0, 0, 0)
        },
        skipEnabled = false
    }
    
    -- Call the function with nil as first argument to broadcast to all
    BroadcastCutscene(nil, cutsceneData)
    
    print("Cutscene broadcast request sent to all players!")
end

-- Option 2: Broadcast only to local player
local function broadcastToSelf()
    print("Broadcasting cutscene to LOCAL player only")
    
    -- Create a sample cutscene data table
    local cutsceneData = {
        name = "LocalCutscene",
        duration = 5,
        camera = {
            position = Vector3.new(0, 5, 0),
            lookAt = Vector3.new(0, 0, 0)
        },
        skipEnabled = true
    }
    
    -- Call the function with local player as first argument
    local localPlayer = game.Players.LocalPlayer
    BroadcastCutscene(localPlayer, cutsceneData)
    
    print("Cutscene broadcast request sent to local player!")
end

-- Execute both methods with a delay between them
spawn(function()
    broadcastToSelf()
    wait(7) -- Wait to let the first cutscene finish
    broadcastToAll()
end)

print("Cutscene broadcast script executed!") 