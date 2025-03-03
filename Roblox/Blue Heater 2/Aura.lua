local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Load the Info.lua module using loadstring
local InfoModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/k1nnx/Cursor/refs/heads/main/Roblox/Blue%20Heater%202/Info.lua?token=GHSAT0AAAAAAC74ORH36H2ZNEQV5PPIDAV4Z6GCGMQ"))()

-- Get the closest entity and its info using the imported module
local closestEntity, entityInfo = InfoModule.GetClosestEntityInfo()

if closestEntity then
    -- Display the info for debugging
    InfoModule.PrintEntityInfo()
    
    -- Store the entity info in a global variable for later use
    _G.CurrentTargetInfo = entityInfo
    
    -- Attack the entity
    local args = {
        [1] = closestEntity
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("PlayerEvents"):WaitForChild("EntityHit"):FireServer(unpack(args))
end
