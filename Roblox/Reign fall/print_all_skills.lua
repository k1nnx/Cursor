-- Script to print all skills in the game
-- This accesses the skills list in ReplicatedStorage based on the path seen in the decompiled code

local skillsList = game:GetService("ReplicatedStorage").Assets.GameplayAssets.Skills.List

-- Print header
print("=====================")
print("ALL AVAILABLE SKILLS")
print("=====================")

-- Function to print skills with their icons and any additional info
local function printSkills()
    local count = 0
    
    -- Iterate through all children in the skills list
    for _, skill in pairs(skillsList:GetChildren()) do
        count = count + 1
        
        -- Get icon info if available
        local hasIcon = skill:FindFirstChild("Icon") ~= nil
        local iconStatus = hasIcon and "✓" or "✗"
        
        -- Print skill info
        print(count .. ". " .. skill.Name .. " [Icon: " .. iconStatus .. "]")
        
        -- Print additional details if any
        local properties = {}
        for _, child in pairs(skill:GetChildren()) do
            if child.Name ~= "Icon" then
                table.insert(properties, child.Name)
            end
        end
        
        if #properties > 0 then
            print("   Properties: " .. table.concat(properties, ", "))
        end
    end
    
    -- Print summary
    print("\nTotal Skills Found: " .. count)
end

-- Execute the function
pcall(function()
    printSkills()
end)

print("Skills printing complete!") 