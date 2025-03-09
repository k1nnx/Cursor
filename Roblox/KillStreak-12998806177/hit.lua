local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Configuration
local MAX_RANGE = 7
local hitCooldown = 0.1
local hitCounter = 0

-- Function to get the closest player within range
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil, math.huge
    end

    local myRoot = LocalPlayer.Character.HumanoidRootPart
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = player.Character.HumanoidRootPart
                local distance = (targetRoot.Position - myRoot.Position).Magnitude
                
                if distance <= MAX_RANGE and distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    
    return closestPlayer, shortestDistance
end

-- Function to get look vector towards target
local function getLookVector(targetPosition, myPosition)
    local direction = (targetPosition - myPosition).Unit
    return direction
end

-- Main update function
local function update()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local target, distance = getClosestPlayer()
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local myRoot = LocalPlayer.Character.HumanoidRootPart
    local myPosition = myRoot.Position
    local targetPosition = target.Character.HumanoidRootPart.Position

    -- Look at target if within range
    if distance <= MAX_RANGE then
        local lookVector = getLookVector(targetPosition, myPosition)
        myRoot.CFrame = CFrame.new(myPosition, targetPosition)

        -- Only hit if cooldown has passed
        local currentTime = tick()
        if currentTime - lastHitTime >= hitCooldown then
            -- Alternate between normal and empty hits
            local args
            if hitCounter % 5 == 0 then
                args = {
                    [1] = {}
                }
            else
                args = {
                    [1] = {
                        ["havemychilren"] = {
                            ["Victim"] = target,
                            ["Vector"] = lookVector
                        }
                    }
                }
            end
            
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Hit"):FireServer(unpack(args))
            lastHitTime = currentTime
            hitCounter = hitCounter + 1
        end
    end
end

-- Connect update function to RunService
RunService.Heartbeat:Connect(update)

-- Cleanup on script end
game.Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        hitBox:Destroy()
    end
end)
