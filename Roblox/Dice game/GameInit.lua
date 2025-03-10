-- GameInit.lua
-- Main script to initialize the dice game

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

-- First, let's make sure our modules are in ReplicatedStorage
local function EnsureModulesExist()
    -- Check if modules already exist in ReplicatedStorage
    if not ReplicatedStorage:FindFirstChild("Dice") and script.Parent:FindFirstChild("Dice") then
        -- Copy the Dice module to ReplicatedStorage
        local diceModule = script.Parent.Dice:Clone()
        diceModule.Parent = ReplicatedStorage
    end
    
    if not ReplicatedStorage:FindFirstChild("DiceUI") and script.Parent:FindFirstChild("DiceUI") then
        -- Copy the DiceUI module to ReplicatedStorage
        local diceUIModule = script.Parent.DiceUI:Clone()
        diceUIModule.Parent = ReplicatedStorage
    end
    
    -- Create client module if it doesn't exist
    if not ReplicatedStorage:FindFirstChild("DiceGameClient") then
        local clientModule = Instance.new("ModuleScript")
        clientModule.Name = "DiceGameClient"
        clientModule.Source = [[
-- DiceGameClient.lua
-- This should be a ModuleScript in ReplicatedStorage

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Constants
local TABLE_MODEL_NAME = "DiceTable"
local NPC_MODEL_NAME = "DicePlayer"
local WAIT_TIME = 5 -- Maximum time to wait for objects

-- Module table
local DiceGameClient = {}

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
    -- Load modules from ReplicatedStorage
    local DiceGame = require(ReplicatedStorage:WaitForChild("Dice"))
    local DiceUI = require(ReplicatedStorage:WaitForChild("DiceUI"))
    
    -- Find game objects with timeout
    local diceTable = SafeWaitForChild(workspace, TABLE_MODEL_NAME, WAIT_TIME)
    if not diceTable then
        warn("Could not find dice table in workspace")
        return
    end
    
    local npc = SafeWaitForChild(workspace, NPC_MODEL_NAME, WAIT_TIME)
    if not npc then
        warn("Could not find NPC in workspace")
        return
    end
    
    -- Find the ClickDetector with timeout
    local clickDetector
    if npc:FindFirstChild("HumanoidRootPart") then
        clickDetector = SafeWaitForChild(npc.HumanoidRootPart, "ClickDetector", WAIT_TIME)
    end
    
    if not clickDetector then
        clickDetector = SafeWaitForChild(npc, "ClickDetector", WAIT_TIME)
    end
    
    if not clickDetector then
        warn("Could not find ClickDetector on NPC")
        return
    end
    
    -- Initialize game when NPC is clicked
    clickDetector.MouseClick:Connect(function()
        -- Create game instance
        local game = DiceGame.new(2000) -- 2000 points to win
        
        -- Add players
        local playerIndex = game:AddPlayer(player)
        local npcIndex = game:AddPlayer(npc)
        
        -- Create UI
        local ui = DiceUI.new(game, diceTable)
        ui:Initialize()
        
        -- Start game
        game:StartGame()
        ui:StartGame()
        
        -- Show welcome message
        local welcomeMessage = "Welcome to the Dice Game! Click 'Roll Dice' to start your turn."
        ui.uiElements.statusLabel.Text = welcomeMessage
    end)
end

return DiceGameClient
]]
        clientModule.Parent = ReplicatedStorage
    end
end

-- Ensure modules exist in ReplicatedStorage
EnsureModulesExist()

-- Load modules from ReplicatedStorage
local DiceGame = require(ReplicatedStorage:WaitForChild("Dice"))
local DiceUI = require(ReplicatedStorage:WaitForChild("DiceUI"))

-- Constants
local TABLE_MODEL_NAME = "DiceTable"
local NPC_MODEL_NAME = "DicePlayer"

-- Create dice table and NPC in the workspace
local function CreateGameEnvironment()
    -- Create dice table
    local diceTable = Instance.new("Model")
    diceTable.Name = TABLE_MODEL_NAME
    
    local tablePart = Instance.new("Part")
    tablePart.Name = "TableTop"
    tablePart.Size = Vector3.new(10, 1, 10)
    tablePart.Position = Vector3.new(0, 0.5, 0)
    tablePart.Anchored = true
    tablePart.CanCollide = true
    tablePart.Color = Color3.fromRGB(139, 69, 19) -- Brown color for table
    tablePart.Material = Enum.Material.Wood
    tablePart.Parent = diceTable
    
    -- Create table legs
    local legPositions = {
        Vector3.new(4, -1.5, 4),
        Vector3.new(-4, -1.5, 4),
        Vector3.new(4, -1.5, -4),
        Vector3.new(-4, -1.5, -4)
    }
    
    for i, pos in ipairs(legPositions) do
        local leg = Instance.new("Part")
        leg.Name = "TableLeg" .. i
        leg.Size = Vector3.new(1, 3, 1)
        leg.Position = pos
        leg.Anchored = true
        leg.CanCollide = true
        leg.Color = Color3.fromRGB(101, 67, 33) -- Darker brown for legs
        leg.Material = Enum.Material.Wood
        leg.Parent = diceTable
    end
    
    -- Set primary part
    diceTable.PrimaryPart = tablePart
    diceTable.Parent = workspace
    
    -- Create NPC
    local npc = Instance.new("Model")
    npc.Name = NPC_MODEL_NAME
    
    -- Create HumanoidRootPart
    local npcRoot = Instance.new("Part")
    npcRoot.Name = "HumanoidRootPart"
    npcRoot.Size = Vector3.new(2, 2, 1)
    npcRoot.Position = Vector3.new(0, 3, -7)
    npcRoot.Anchored = true
    npcRoot.CanCollide = true
    npcRoot.Color = Color3.fromRGB(150, 150, 150)
    npcRoot.Parent = npc
    
    -- Add Humanoid
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = npc
    
    local npcHead = Instance.new("Part")
    npcHead.Name = "Head"
    npcHead.Shape = Enum.PartType.Ball
    npcHead.Size = Vector3.new(1.2, 1.2, 1.2)
    npcHead.Position = Vector3.new(0, 4.6, -7)
    npcHead.Anchored = true
    npcHead.CanCollide = true
    npcHead.Color = Color3.fromRGB(255, 213, 170) -- Skin tone
    npcHead.Parent = npc
    
    -- Add face
    local face = Instance.new("Decal")
    face.Name = "Face"
    face.Texture = "rbxassetid://209712379" -- Default Roblox face
    face.Face = Enum.NormalId.Front
    face.Parent = npcHead
    
    -- Add name label
    local nameLabel = Instance.new("BillboardGui")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(0, 200, 0, 50)
    nameLabel.StudsOffset = Vector3.new(0, 2, 0)
    nameLabel.AlwaysOnTop = true
    nameLabel.Parent = npcHead
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Name"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Dice Master"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 20
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = nameLabel
    
    -- Set primary part and parent first
    npc.PrimaryPart = npcRoot
    npc.Parent = workspace
    
    -- Add click detector to start game (after parenting)
    local clickDetector = Instance.new("ClickDetector")
    clickDetector.Name = "ClickDetector"
    clickDetector.MaxActivationDistance = 10
    clickDetector.Parent = npcRoot
    
    -- Verify ClickDetector was created
    if not npcRoot:FindFirstChild("ClickDetector") then
        warn("Failed to create ClickDetector, retrying...")
        clickDetector = Instance.new("ClickDetector")
        clickDetector.Name = "ClickDetector"
        clickDetector.MaxActivationDistance = 10
        clickDetector.Parent = npcRoot
        wait() -- Give it a frame to process
    end
    
    print("Created NPC with ClickDetector in HumanoidRootPart")
    
    return diceTable, npc, clickDetector
end

-- Create game environment if it doesn't exist
local diceTable = workspace:FindFirstChild(TABLE_MODEL_NAME)
local npc = workspace:FindFirstChild(NPC_MODEL_NAME)

if not diceTable or not npc then
    print("Creating new game environment...")
    diceTable, npc = CreateGameEnvironment()
else
    print("Found existing game environment")
    -- Verify ClickDetector exists and recreate if needed
    local npcRoot = npc:FindFirstChild("HumanoidRootPart")
    if npcRoot then
        if not npcRoot:FindFirstChild("ClickDetector") then
            print("ClickDetector missing, recreating...")
            local clickDetector = Instance.new("ClickDetector")
            clickDetector.Name = "ClickDetector"
            clickDetector.MaxActivationDistance = 10
            clickDetector.Parent = npcRoot
            print("Recreated ClickDetector in HumanoidRootPart")
        else
            print("Found existing ClickDetector")
        end
    else
        warn("HumanoidRootPart not found in NPC, recreating game environment...")
        npc:Destroy()
        diceTable:Destroy()
        diceTable, npc = CreateGameEnvironment()
    end
end

-- Verify everything is set up correctly
local verifySetup = function()
    local success = true
    
    -- Check table
    if not workspace:FindFirstChild(TABLE_MODEL_NAME) then
        warn("Dice table missing from workspace")
        success = false
    end
    
    -- Check NPC and its components
    local npcModel = workspace:FindFirstChild(NPC_MODEL_NAME)
    if not npcModel then
        warn("NPC missing from workspace")
        success = false
    else
        -- Check HumanoidRootPart
        local root = npcModel:FindFirstChild("HumanoidRootPart")
        if not root then
            warn("HumanoidRootPart missing from NPC")
            success = false
        else
            -- Check ClickDetector
            local detector = root:FindFirstChild("ClickDetector")
            if not detector then
                warn("ClickDetector missing from HumanoidRootPart")
                success = false
            end
        end
    end
    
    return success
end

-- Verify and retry if needed
if not verifySetup() then
    warn("Initial setup incomplete, retrying...")
    -- Clean up existing objects
    if workspace:FindFirstChild(TABLE_MODEL_NAME) then
        workspace[TABLE_MODEL_NAME]:Destroy()
    end
    if workspace:FindFirstChild(NPC_MODEL_NAME) then
        workspace[NPC_MODEL_NAME]:Destroy()
    end
    -- Recreate environment
    diceTable, npc = CreateGameEnvironment()
    -- Verify again
    if not verifySetup() then
        error("Failed to create game environment properly")
    end
end

print("Game environment setup complete")

-- Create a message to inform about the game
local message = Instance.new("Message")
message.Text = "Welcome to the Dice Game! Find and click on the Dice Master NPC to start playing."
message.Parent = workspace

-- Remove message after 5 seconds
wait(5)
if message and message.Parent then
    message:Destroy()
end 