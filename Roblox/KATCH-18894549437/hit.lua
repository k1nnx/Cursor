local nodes = workspace.Scene.ResourceNodes:GetChildren()
local player = game:GetService("Players").LocalPlayer
local character = player.Character
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("AttackStart"):InvokeServer(1)
for _, node in pairs(nodes) do
    local distance = (humanoidRootPart.Position - node.Position).Magnitude
    if distance < 10 then
        local args = {
            [1] = (node:GetAttribute("NodeType")),
            [2] = node.Name
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("OnPlayerHitObject"):InvokeServer(unpack(args))
        wait(0.1)
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PlayerService"):WaitForChild("RF"):WaitForChild("AttackEnd"):InvokeServer(1)
    end
end