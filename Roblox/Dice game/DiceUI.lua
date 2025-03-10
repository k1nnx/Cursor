-- DiceUI Module
-- Handles the user interface for the dice game

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local DiceUI = {}
DiceUI.__index = DiceUI

-- Constants
local DICE_MODELS = {
    [1] = "Dice1", -- Path to dice model with 1 pip
    [2] = "Dice2", -- Path to dice model with 2 pips
    [3] = "Dice3", -- Path to dice model with 3 pips
    [4] = "Dice4", -- Path to dice model with 4 pips
    [5] = "Dice5", -- Path to dice model with 5 pips
    [6] = "Dice6"  -- Path to dice model with 6 pips
}

local DICE_COLORS = {
    NORMAL = Color3.fromRGB(255, 255, 255),
    SELECTED = Color3.fromRGB(255, 215, 0),
    OPPONENT = Color3.fromRGB(200, 200, 200)
}

-- Create a new DiceUI instance
function DiceUI.new(game, diceTable)
    local self = setmetatable({}, DiceUI)
    
    self.game = game
    self.diceTable = diceTable
    self.diceModels = {}
    self.selectedDice = {}
    self.uiElements = {}
    self.isPlayerTurn = false
    
    return self
end

-- Initialize the UI
function DiceUI:Initialize()
    self:CreateDiceModels()
    self:CreateUI()
end

-- Create dice models on the table
function DiceUI:CreateDiceModels()
    -- Create a model to hold all dice
    local diceContainer = Instance.new("Model")
    diceContainer.Name = "DiceContainer"
    diceContainer.Parent = self.diceTable
    
    -- Create dice
    for i = 1, 6 do
        local dice = Instance.new("Part")
        dice.Name = "Dice" .. i
        dice.Size = Vector3.new(1, 1, 1)
        dice.Anchored = true
        dice.CanCollide = false
        dice.Position = self.diceTable.PrimaryPart.Position + Vector3.new(i - 3, 2, 0)
        dice.Parent = diceContainer
        
        -- Add SurfaceGui for displaying number
        local surfaceGui = Instance.new("SurfaceGui")
        surfaceGui.Name = "NumberDisplay"
        surfaceGui.Face = Enum.NormalId.Front
        surfaceGui.Parent = dice
        
        local numberLabel = Instance.new("TextLabel")
        numberLabel.Name = "Number"
        numberLabel.Size = UDim2.new(1, 0, 1, 0)
        numberLabel.BackgroundTransparency = 1
        numberLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        numberLabel.TextScaled = true
        numberLabel.Font = Enum.Font.SourceSansBold
        numberLabel.Text = "?"
        numberLabel.Parent = surfaceGui
        
        -- Add ProximityPrompt for interaction
        local prompt = Instance.new("ProximityPrompt")
        prompt.ObjectText = "Dice " .. i
        prompt.ActionText = "Roll"
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false
        prompt.Parent = dice
        
        -- Store reference
        self.diceModels[i] = dice
        
        -- Connect prompt triggered event
        prompt.Triggered:Connect(function(player)
            if player == Players.LocalPlayer then
                self:OnDiceClicked(i)
            end
        end)
    end
end

-- Create UI elements
function DiceUI:CreateUI()
    -- Create ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "DiceGameUI"
    
    -- Create roll button
    local rollButton = Instance.new("TextButton")
    rollButton.Name = "RollButton"
    rollButton.Size = UDim2.new(0, 200, 0, 50)
    rollButton.Position = UDim2.new(0.5, -100, 0.9, -25)
    rollButton.Text = "Roll Dice"
    rollButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    rollButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    rollButton.BorderSizePixel = 0
    rollButton.AutoButtonColor = true
    rollButton.Parent = gui
    
    -- Create status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(0, 400, 0, 50)
    statusLabel.Position = UDim2.new(0.5, -200, 0.1, 0)
    statusLabel.Text = "Welcome to Dice Game!"
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.Parent = gui
    
    -- Store UI elements
    self.uiElements = {
        gui = gui,
        rollButton = rollButton,
        statusLabel = statusLabel
    }
    
    -- Connect roll button
    rollButton.MouseButton1Click:Connect(function()
        self:OnRollButtonClicked()
    end)
    
    -- Parent the GUI
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Handle dice click
function DiceUI:OnDiceClicked(diceIndex)
    if not self.isPlayerTurn then return end
    
    local diceModel = self.diceModels[diceIndex]
    if not diceModel then return end
    
    -- Toggle selection
    if self.selectedDice[diceIndex] then
        self.selectedDice[diceIndex] = nil
        diceModel.Color = DICE_COLORS.NORMAL
    else
        self.selectedDice[diceIndex] = true
        diceModel.Color = DICE_COLORS.SELECTED
    end
    
    -- Calculate potential score
    local selectedIndices = {}
    for idx, _ in pairs(self.selectedDice) do
        table.insert(selectedIndices, idx)
    end
    
    -- Update UI with potential score
    -- In a real implementation, this would call the game logic to calculate the score
    self:UpdatePotentialScore(selectedIndices)
end

-- Update the potential score display
function DiceUI:UpdatePotentialScore(selectedIndices)
    -- This is a placeholder - in a real implementation, you would call the game logic
    -- For now, we'll just update the UI with a message
    self.uiElements.statusLabel.Text = "Selected " .. #selectedIndices .. " dice"
end

-- Handle roll button click
function DiceUI:OnRollButtonClicked()
    if not self.isPlayerTurn then
        self.uiElements.statusLabel.Text = "Wait for your turn!"
        return
    end

    -- Disable button during roll by changing its appearance
    local rollButton = self.uiElements.rollButton
    rollButton.AutoButtonColor = false
    rollButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
    rollButton.Text = "Rolling..."
    
    -- Clear previous selections
    for i, dice in pairs(self.diceModels) do
        self.selectedDice[i] = nil
        dice.Color = DICE_COLORS.NORMAL
        -- Reset number display during roll
        local numberDisplay = dice:FindFirstChild("NumberDisplay")
        if numberDisplay and numberDisplay:FindFirstChild("Number") then
            numberDisplay.Number.Text = "?"
        end
    end
    
    -- Roll animation for each dice
    for _, dice in pairs(self.diceModels) do
        -- Create random rotation tween
        local randomRotation = CFrame.Angles(
            math.rad(math.random(0, 360)),
            math.rad(math.random(0, 360)),
            math.rad(math.random(0, 360))
        )
        
        local tweenInfo = TweenInfo.new(
            1, -- Time
            Enum.EasingStyle.Bounce,
            Enum.EasingDirection.Out
        )
        
        local tween = TweenService:Create(dice, tweenInfo, {
            CFrame = dice.CFrame * randomRotation
        })
        
        tween:Play()
    end
    
    -- Wait for animation to complete
    wait(1.1)
    
    -- Generate random values for dice
    local results = {}
    for i = 1, #self.diceModels do
        results[i] = math.random(1, 6)
        local dice = self.diceModels[i]
        -- Update dice appearance based on result
        dice.Color = DICE_COLORS.NORMAL
        -- Update number display with rounded value
        local numberDisplay = dice:FindFirstChild("NumberDisplay")
        if numberDisplay and numberDisplay:FindFirstChild("Number") then
            local value = results[i]
            if typeof(value) == "number" then
                numberDisplay.Number.Text = tostring(math.round(value))
            else
                numberDisplay.Number.Text = tostring(value)
            end
        end
    end
    
    -- Update game state with results
    if self.game and self.game.OnDiceRolled then
        self.game:OnDiceRolled(results)
    end
    
    -- Re-enable button by restoring its appearance
    rollButton.AutoButtonColor = true
    rollButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    rollButton.Text = "Roll Dice"
    
    -- Update status
    self.uiElements.statusLabel.Text = "Select dice to keep or roll again!"
end

-- Show help/rules UI
function DiceUI:ShowHelpUI()
    -- Create help UI
    local helpFrame = Instance.new("Frame")
    helpFrame.Name = "HelpFrame"
    helpFrame.Size = UDim2.new(0.6, 0, 0.8, 0)
    helpFrame.Position = UDim2.new(0.2, 0, 0.1, 0)
    helpFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    helpFrame.BorderSizePixel = 0
    helpFrame.Parent = self.uiElements.gui
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "Dice Game Rules"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = helpFrame
    
    local rulesText = Instance.new("TextLabel")
    rulesText.Name = "RulesText"
    rulesText.Size = UDim2.new(0.95, 0, 0.8, 0)
    rulesText.Position = UDim2.new(0.025, 0, 0.15, 0)
    rulesText.BackgroundTransparency = 1
    rulesText.TextColor3 = Color3.fromRGB(255, 255, 255)
    rulesText.TextSize = 16
    rulesText.Font = Enum.Font.SourceSans
    rulesText.TextWrapped = true
    rulesText.TextXAlignment = Enum.TextXAlignment.Left
    rulesText.TextYAlignment = Enum.TextYAlignment.Top
    rulesText.Text = [[
Dice Game Rules:

1. The goal is to be the first player to reach 2000 points.

2. On your turn, roll six dice and select which dice to keep for points.

3. Scoring:
   - Single 1: 100 points
   - Single 5: 50 points
   - Three 1s: 1000 points
   - Three of a kind (except 1s): Number × 100 points
   - Straight 1-5: 500 points
   - Straight 2-6: 750 points
   - Straight 1-6: 1500 points
   - Four or more of a kind: Double the three of a kind score for each additional die

4. After selecting dice, you can either:
   - Roll the remaining dice to try to score more points
   - Bank your current turn score and end your turn

5. If you roll and cannot score with any dice, you lose all points accumulated during that turn.

6. Strategy is key - knowing when to bank your points and when to push your luck!
    ]]
    rulesText.Parent = helpFrame
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0.2, 0, 0.05, 0)
    closeButton.Position = UDim2.new(0.4, 0, 0.93, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    closeButton.Text = "Close"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = helpFrame
    
    closeButton.MouseButton1Click:Connect(function()
        helpFrame:Destroy()
    end)
end

-- Start a new game
function DiceUI:StartGame()
    self.isPlayerTurn = true
    self.uiElements.statusLabel.Text = "Game started! Click 'Roll Dice' to begin."
end

return DiceUI 