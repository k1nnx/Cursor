local zombiesFolder = workspace:WaitForChild("Zombies")
local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent")
local runService = game:GetService("RunService")

-- Unequip weapon first to enable melee attacks
local equipArgs = {
    [1] = "EquipWeapon",
    [2] = 1,
    [3] = false
}

remoteEvent:FireServer(unpack(equipArgs))
print("Unequipped weapon for melee attacks")

-- Get player character
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Configuration
local maxDistance = 20 -- Maximum distance in studs
local hitCooldown = 0.1 -- Time between hits for each zombie
local autoHitEnabled = true -- Toggle for the auto-hit feature
local lastHitTimes = {} -- Table to track last hit time for each zombie

-- Create GUI to toggle auto-hit
local autoHitGui = Instance.new("ScreenGui")
autoHitGui.Name = "AutoHitGui"
autoHitGui.Parent = player.PlayerGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
toggleButton.Text = "Auto-Hit: ON"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18
toggleButton.Parent = autoHitGui

-- Function to toggle auto-hit
toggleButton.MouseButton1Click:Connect(function()
    autoHitEnabled = not autoHitEnabled
    toggleButton.Text = "Auto-Hit: " .. (autoHitEnabled and "ON" or "OFF")
    toggleButton.BackgroundColor3 = autoHitEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- Stats display
local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(0, 200, 0, 30)
statsLabel.Position = UDim2.new(0, 10, 0, 70)
statsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statsLabel.BackgroundTransparency = 0.5
statsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statsLabel.Text = "Zombies hit: 0"
statsLabel.Font = Enum.Font.SourceSans
statsLabel.TextSize = 16
statsLabel.Parent = autoHitGui

-- Counter for total zombies hit
local totalZombiesHit = 0

-- Function to hit a zombie
local function hitZombie(zombie)
    local args = {
        [1] = "MeleeHit",
        [2] = zombie
    }
    
    remoteEvent:FireServer(unpack(args))
    totalZombiesHit = totalZombiesHit + 1
    statsLabel.Text = "Zombies hit: " .. totalZombiesHit
    lastHitTimes[zombie] = tick()
end

-- Main RenderStepped loop
local renderStepConnection
renderStepConnection = runService.RenderStepped:Connect(function()
    if not autoHitEnabled then return end
    
    -- Check if character still exists
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        character = player.Character
        if not character then return end
        humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
    end
    
    -- Get all zombies in the zombies folder
    local zombies = zombiesFolder:GetChildren()
    local zombiesInRange = 0
    
    -- Loop through each zombie and hit it with melee if within range
    for _, zombie in pairs(zombies) do
        -- Check if the zombie has a PrimaryPart to measure distance from
        local zombiePart = zombie:FindFirstChild("HumanoidRootPart") or 
                          zombie:FindFirstChild("Torso") or 
                          zombie:FindFirstChild("UpperTorso") or 
                          zombie.PrimaryPart
        
        if zombiePart then
            -- Calculate distance between player and zombie
            local distance = (humanoidRootPart.Position - zombiePart.Position).Magnitude
            
            -- Only hit zombies within the specified range and not on cooldown
            local currentTime = tick()
            if distance <= maxDistance and (not lastHitTimes[zombie] or currentTime - lastHitTimes[zombie] >= hitCooldown) then
                hitZombie(zombie)
                zombiesInRange = zombiesInRange + 1
            end
        end
    end
    
    -- If no zombies in range, wait a bit to reduce performance impact
    if zombiesInRange == 0 then
        task.wait(0.5)
    end
end)

-- Function to clean up when script is stopped
local function cleanup()
    if renderStepConnection then
        renderStepConnection:Disconnect()
    end
    if autoHitGui then
        autoHitGui:Destroy()
    end
end

-- Allow script to be stopped with a variable
_G.stopAutoHit = cleanup
