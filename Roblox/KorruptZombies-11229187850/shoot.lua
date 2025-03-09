local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace:WaitForChild("Camera")

local playerID = player.UserId
local bulletID = playerID .. "-" .. game:GetService("HttpService"):GenerateGUID()
local shootingID = playerID .. "-" .. game:GetService("HttpService"):GenerateGUID()

local function getAllZombies()
    local zombies = workspace:WaitForChild("Zombies"):GetChildren()
    local zombieList = {}
    
    for i, zombie in pairs(zombies) do
        if zombie:IsA("Model") then
            local head = zombie:FindFirstChild("Head")
            local upperTorso = zombie:FindFirstChild("UpperTorso")
            local torso = zombie:FindFirstChild("Torso")
            
            -- Always prioritize the head for maximum damage
            local hitPart = head or upperTorso or torso or zombie:FindFirstChild("HumanoidRootPart") or zombie.PrimaryPart
            
            if hitPart then
                table.insert(zombieList, {
                    zombie = zombie,
                    hitPart = hitPart,
                    hitPartName = hitPart.Name,
                    isHeadshot = hitPart.Name == "Head"
                })
            end
        end
    end
    
    return zombieList
end

function getNil(name, class) 
    for _, v in next, getnilinstances() do 
        if v.ClassName == class and v.Name == name then 
            return v
        end 
    end 
end

local function extractNumberFromFormattedText(text)
    -- Extract the number from text like <font color='rgb(255, 255, 255)'>200</font>
    local number = text:match("<font.->(.-)</font>")
    if number then
        return tonumber(number)
    end
    
    -- Try direct conversion in case it's just a number
    return tonumber(text)
end

local function formatAmmoText(number)
    -- Format the number with the white font color tag
    return string.format("<font color='rgb(255, 255, 255)'>%d</font>", number)
end

local function fireProjectile(zombieList)
    if not zombieList or #zombieList == 0 then
        print("No zombies found to shoot at")
        return nil
    end
    
    local viewModel = camera:FindFirstChild("ViewModel")
    local referenceObjects = viewModel and viewModel:FindFirstChild("ReferenceObjects")
    local firePart = referenceObjects and referenceObjects:FindFirstChild("FirePart")
    
    if not firePart then
        print("FirePart not found, using camera as origin")
    end
    
    local args = {
        [1] = "NewProjectiles",
        [2] = {
            [1] = {
                ["BulletID"] = bulletID,
                ["ShootingID"] = shootingID
            }
        },
        [3] = {
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    
    return zombieList
end

local function hitAllZombies(zombieList)
    if not zombieList or #zombieList == 0 then return end
    
    local zombiesHit = {}
    local hitPosition = camera.CFrame.Position + (camera.CFrame.LookVector * 20)
    local anyHeadshots = false
    
    for i, zombieData in ipairs(zombieList) do
        local zombie = zombieData.zombie
        local hitPart = zombieData.hitPart
        local hitPartName = zombieData.hitPartName
        local isHeadshot = zombieData.isHeadshot
        
        if isHeadshot then
            anyHeadshots = true
        end
        
        -- Calculate distance and look vector
        local distance = math.min(10, (camera.CFrame.Position - hitPart.Position).Magnitude)
        local lookVector = (hitPart.Position - camera.CFrame.Position).Unit
        
        -- Add zombie to hit list - use actual instances
        table.insert(zombiesHit, zombie)
        table.insert(zombiesHit, hitPart)
        
        -- Add hit information
        table.insert(zombiesHit, {
            ["Distance"] = distance,
            ["HitPart"] = hitPartName,
            ["FleshHitIndex"] = isHeadshot and 2 or 1, -- Add FleshHitIndex for proper hit registration
            ["HitLookVector"] = Vector3.new(
                lookVector.X + (math.random() - 0.5) * 0.1,
                lookVector.Y + (math.random() - 0.5) * 0.1,
                lookVector.Z + (math.random() - 0.5) * 0.1
            ).Unit
        })
    end
    
    local args = {
        [1] = "ProjectileHit",
        [2] = bulletID,
        [3] = {
            ["ZombiesHit"] = zombiesHit,
            ["HitPosition"] = hitPosition,
            ["ExtraHit"] = {},
            ["Headshot"] = anyHeadshots -- Add Headshot flag if any headshots occurred
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end

-- Direct hit without projectile
local function directHitZombies()
    local zombieList = getAllZombies()
    if #zombieList == 0 then
        print("No zombies found to hit")
        return
    end
    
    local zombiesHit = {}
    local hitPosition = camera.CFrame.Position + (camera.CFrame.LookVector * 20)
    local anyHeadshots = false
    
    for i, zombieData in ipairs(zombieList) do
        local zombie = zombieData.zombie
        local hitPart = zombieData.hitPart
        local hitPartName = zombieData.hitPartName
        local isHeadshot = zombieData.isHeadshot
        
        if isHeadshot then
            anyHeadshots = true
        end
        
        -- Calculate distance and look vector
        local distance = math.min(10, (camera.CFrame.Position - hitPart.Position).Magnitude)
        local lookVector = (hitPart.Position - camera.CFrame.Position).Unit
        
        -- Add zombie to hit list - use actual instances
        table.insert(zombiesHit, zombie)
        table.insert(zombiesHit, hitPart)
        
        -- Add hit information
        table.insert(zombiesHit, {
            ["Distance"] = distance,
            ["HitPart"] = hitPartName,
            ["FleshHitIndex"] = isHeadshot and 2 or 1, -- Add FleshHitIndex for proper hit registration
            ["HitLookVector"] = Vector3.new(
                lookVector.X + (math.random() - 0.5) * 0.1,
                lookVector.Y + (math.random() - 0.5) * 0.1,
                lookVector.Z + (math.random() - 0.5) * 0.1
            ).Unit
        })
    end
    
    local args = {
        [1] = "ProjectileHit",
        [2] = playerID .. "-" .. game:GetService("HttpService"):GenerateGUID(),
        [3] = {
            ["ZombiesHit"] = zombiesHit,
            ["HitPosition"] = hitPosition,
            ["ExtraHit"] = {},
            ["Headshot"] = anyHeadshots -- Add Headshot flag if any headshots occurred
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    print("Directly hit all zombies!")
end

local function checkAndShoot()
    -- Check if there are zombies to shoot at
    local zombieList = getAllZombies()
    if #zombieList == 0 then
        print("No zombies found to shoot at")
        return
    end
    
    -- Play shooting animation
    local args = {
        [1] = "ChangeAnimation",
        [2] = "Shoot"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    
    -- Try both methods
    -- Method 1: Fire projectile and hit zombies
    local shotZombies = fireProjectile(zombieList)
    if shotZombies then
        hitAllZombies(shotZombies)
        print("Fired projectile and hit all zombies at once!")
    end
    
    -- Method 2: Direct hit without projectile (as fallback)
    wait(0.1)
    directHitZombies()
end

-- Execute the shooting sequence
checkAndShoot()
