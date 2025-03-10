-- DiceGameClient.lua
-- This should be a ModuleScript in ReplicatedStorage

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Constants
local TABLE_MODEL_NAME = "DiceTable"
local NPC_MODEL_NAME = "DicePlayer"
local WAIT_TIME = 5 -- Maximum time to wait for objects
local CHECK_INTERVAL = 0.5 -- How often to check for the ClickDetector

-- Module table
local DiceGameClient = {}

-- Store game objects
local gameObjects = {
    diceTable = nil,
    npc = nil,
    ui = nil,
    game = nil
}

-- Helper function to safely wait for an object
local function SafeWaitForChild(parent, childName, timeout)
    local startTime = tick()
    local object = parent:FindFirstChild(childName)
    
    while not object and (tick() - startTime) < timeout do
        object = parent:FindFirstChild(childName)
        wait(0.1)
    end
    
    return object
end

function DiceGameClient.Initialize()
    print("Initializing DiceGameClient...")
    
    -- Load modules from ReplicatedStorage
    local DiceGame = require(ReplicatedStorage:WaitForChild("Dice"))
    local DiceUI = require(ReplicatedStorage:WaitForChild("DiceUI"))
    
    -- Function to set up click detection
    local function SetupClickDetection(npc)
        print("Setting up click detection for NPC...")
        
        -- Function to handle NPC clicks
        local function handleNPCClick()
            print("NPC clicked, starting game...")
            -- Create game instance
            gameObjects.game = DiceGame.new(2000) -- 2000 points to win
            
            -- Add players
            local playerIndex = gameObjects.game:AddPlayer(player)
            local npcIndex = gameObjects.game:AddPlayer(npc)
            
            -- Create UI
            gameObjects.ui = DiceUI.new(gameObjects.game, gameObjects.diceTable)
            gameObjects.ui:Initialize()
            
            -- Start game
            gameObjects.game:StartGame()
            gameObjects.ui:StartGame()
            
            -- Show welcome message
            local welcomeMessage = "Welcome to the Dice Game! Click 'Roll Dice' to start your turn."
            gameObjects.ui.uiElements.statusLabel.Text = welcomeMessage
        end
        
        -- Connect click detection
        if npc:FindFirstChild("HumanoidRootPart") then
            local root = npc.HumanoidRootPart
            local clickDetector = root:FindFirstChild("ClickDetector")
            if clickDetector then
                print("Found ClickDetector, connecting...")
                clickDetector.MouseClick:Connect(handleNPCClick)
                return true
            end
        end
        return false
    end
    
    -- Wait for game objects
    local function WaitForGameObjects()
        print("Waiting for game objects...")
        gameObjects.diceTable = workspace:WaitForChild(TABLE_MODEL_NAME, WAIT_TIME)
        gameObjects.npc = workspace:WaitForChild(NPC_MODEL_NAME, WAIT_TIME)
        
        if not gameObjects.diceTable or not gameObjects.npc then
            warn("Could not find required game objects")
            return
        end
        
        -- Try to set up click detection
        local startTime = tick()
        local success = false
        
        -- Keep trying to set up click detection until successful or timeout
        while not success and (tick() - startTime) < WAIT_TIME do
            success = SetupClickDetection(gameObjects.npc)
            if not success then
                wait(CHECK_INTERVAL)
            end
        end
        
        if not success then
            warn("Failed to set up click detection after " .. WAIT_TIME .. " seconds")
        else
            print("Click detection setup successful")
        end
    end
    
    -- Start waiting for objects
    coroutine.wrap(WaitForGameObjects)()
end

return DiceGameClient 