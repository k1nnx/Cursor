local function placeBlocksAroundPlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)
    if not player then return end

    local character = player.Character
    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Place blocks in a spiral pattern
    local radius = 3
    local height = 0
    
    for i = 1, 16 do
        local angle = (i * math.pi) / 8
        local offsetX = math.cos(angle) * radius
        local offsetZ = math.sin(angle) * radius
        
        local position = rootPart.Position + Vector3.new(offsetX, height, offsetZ)
        
        local args = {
            [1] = {
                ["Direction"] = Vector3.new(0, -1, 0),
                ["HitPosition"] = position,
                ["Origin"] = position + Vector3.new(0, 2, 0),
                ["Distance"] = 2,
                ["CastSuccessful"] = {
                    ["Instance"] = workspace:WaitForChild("Terrain"),
                    ["CFrame"] = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                    ["Normal"] = Vector3.yAxis
                }
            }
        }
        
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("CurrentGame"):WaitForChild("Tools"):WaitForChild("ToolHandlers_o"):WaitForChild("Blocks"):WaitForChild("Placer"):WaitForChild("BlockPlacer_m"):WaitForChild("PlaceBlock"):InvokeServer(unpack(args))
        end)
    end
end

-- Main loop with error handling
spawn(function()
    while true do
        pcall(function()
            placeBlocksAroundPlayer("lequuis")
        end)
        task.wait(0.05)
    end
end)

