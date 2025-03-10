-- DiceGameClientRunner.lua
-- This should be a LocalScript in StarterPlayerScripts

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Wait for player to load
local player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

-- Initialize the game when everything is ready
local function InitializeGame()
    local DiceGameClient = require(ReplicatedStorage:WaitForChild("DiceGameClient"))
    DiceGameClient.Initialize()
end

-- Start initialization
coroutine.wrap(InitializeGame)() 