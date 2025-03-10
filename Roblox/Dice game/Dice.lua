-- Dice Game Module based on Kingdom Come: Deliverance
-- This module handles the core game mechanics for the dice game

local DiceGame = {}
DiceGame.__index = DiceGame

-- Constants
local WINNING_SCORE = 2000 -- Default winning score
local DEFAULT_DICE_COUNT = 6 -- Number of dice per player

-- Scoring rules based on Kingdom Come: Deliverance
local SCORE_VALUES = {
    SINGLE_ONE = 100,   -- Single 1 is worth 100 points
    SINGLE_FIVE = 50,   -- Single 5 is worth 50 points
    
    -- Three of a kind values
    THREE_ONES = 1000,  -- Three 1s
    THREE_TWOS = 200,   -- Three 2s
    THREE_THREES = 300, -- Three 3s
    THREE_FOURS = 400,  -- Three 4s
    THREE_FIVES = 500,  -- Three 5s
    THREE_SIXES = 600,  -- Three 6s
    
    -- Straights
    STRAIGHT_1_TO_5 = 500,    -- 1,2,3,4,5
    STRAIGHT_2_TO_6 = 750,    -- 2,3,4,5,6
    STRAIGHT_1_TO_6 = 1500,   -- 1,2,3,4,5,6
}

-- Create a new game instance
function DiceGame.new(winningScore)
    local self = setmetatable({}, DiceGame)
    
    self.winningScore = winningScore or WINNING_SCORE
    self.players = {}
    self.currentPlayerIndex = 1
    self.gameState = "waiting" -- waiting, playing, finished
    self.currentRoll = {}
    self.heldDice = {}
    self.currentScore = 0
    self.turnScore = 0
    
    return self
end

-- Add a player to the game
function DiceGame:AddPlayer(player)
    table.insert(self.players, {
        player = player,
        score = 0,
        diceTypes = {} -- For custom dice types
    })
    return #self.players
end

-- Roll the dice
function DiceGame:RollDice(diceCount)
    local results = {}
    diceCount = diceCount or (DEFAULT_DICE_COUNT - #self.heldDice)
    
    for i = 1, diceCount do
        table.insert(results, math.random(1, 6))
    end
    
    self.currentRoll = results
    return results
end

-- Calculate score for a set of dice
function DiceGame:CalculateScore(dice)
    local score = 0
    local diceCount = {}
    
    -- Count occurrences of each value
    for i = 1, 6 do
        diceCount[i] = 0
    end
    
    for _, value in ipairs(dice) do
        diceCount[value] = diceCount[value] + 1
    end
    
    -- Check for straights
    if #dice >= 5 then
        if diceCount[1] >= 1 and diceCount[2] >= 1 and diceCount[3] >= 1 and diceCount[4] >= 1 and diceCount[5] >= 1 then
            if diceCount[6] >= 1 and #dice >= 6 then
                return SCORE_VALUES.STRAIGHT_1_TO_6
            else
                return SCORE_VALUES.STRAIGHT_1_TO_5
            end
        elseif diceCount[2] >= 1 and diceCount[3] >= 1 and diceCount[4] >= 1 and diceCount[5] >= 1 and diceCount[6] >= 1 then
            return SCORE_VALUES.STRAIGHT_2_TO_6
        end
    end
    
    -- Check for three of a kind and additional dice
    for i = 1, 6 do
        if diceCount[i] >= 3 then
            if i == 1 then
                score = score + SCORE_VALUES.THREE_ONES
                diceCount[i] = diceCount[i] - 3
            else
                score = score + (i * 100)
                diceCount[i] = diceCount[i] - 3
            end
            
            -- Additional dice beyond three of a kind double the score
            if diceCount[i] > 0 then
                local multiplier = 2 ^ diceCount[i]
                score = score * multiplier
            end
        end
    end
    
    -- Add single 1s and 5s
    score = score + (diceCount[1] * SCORE_VALUES.SINGLE_ONE)
    score = score + (diceCount[5] * SCORE_VALUES.SINGLE_FIVE)
    
    return score
end

-- Hold specific dice from the current roll
function DiceGame:HoldDice(indices)
    local newHeldDice = {}
    
    for _, index in ipairs(indices) do
        if self.currentRoll[index] then
            table.insert(newHeldDice, self.currentRoll[index])
            self.currentRoll[index] = nil
        end
    end
    
    -- Add to held dice
    for _, value in ipairs(newHeldDice) do
        table.insert(self.heldDice, value)
    end
    
    -- Calculate score for held dice
    local potentialScore = self:CalculateScore(self.heldDice)
    self.turnScore = potentialScore
    
    -- Check if all dice are held
    local allHeld = true
    for _, _ in pairs(self.currentRoll) do
        allHeld = false
        break
    end
    
    return {
        heldDice = self.heldDice,
        turnScore = self.turnScore,
        allHeld = allHeld
    }
end

-- End the current player's turn and bank their score
function DiceGame:EndTurn()
    if self.turnScore > 0 then
        self.players[self.currentPlayerIndex].score = self.players[self.currentPlayerIndex].score + self.turnScore
        
        -- Check if player has won
        if self.players[self.currentPlayerIndex].score >= self.winningScore then
            self.gameState = "finished"
            return {
                winner = self.players[self.currentPlayerIndex],
                gameState = self.gameState
            }
        end
    end
    
    -- Move to next player
    self.currentPlayerIndex = self.currentPlayerIndex % #self.players + 1
    
    -- Reset turn
    self.currentRoll = {}
    self.heldDice = {}
    self.turnScore = 0
    
    return {
        nextPlayer = self.players[self.currentPlayerIndex],
        gameState = self.gameState
    }
end

-- Start the game
function DiceGame:StartGame()
    if #self.players < 1 then
        return false, "Need at least one player"
    end
    
    self.gameState = "playing"
    self.currentPlayerIndex = 1
    
    return true
end

-- Get current game state
function DiceGame:GetGameState()
    return {
        players = self.players,
        currentPlayerIndex = self.currentPlayerIndex,
        gameState = self.gameState,
        currentRoll = self.currentRoll,
        heldDice = self.heldDice,
        turnScore = self.turnScore
    }
end

return DiceGame
