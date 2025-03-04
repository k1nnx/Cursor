-- Script to list and access all cinematics in the game
-- Using the decompiled cinematic function provided by the user

-- Load the cinematic function from ReplicatedStorage
local GetCinematic = require(game.ReplicatedStorage.Functions.Game.Cinematic.GetCinematic)

-- Print header
print("===========================")
print("ALL AVAILABLE CINEMATICS")
print("===========================")

-- Get the path to the cinematics list directly
local cinematicsList = game:GetService("ReplicatedStorage").Assets.Game.Cinematics.List

-- Function to list all available cinematics and their details
local function listAllCinematics()
    local count = 0
    
    -- Iterate through all children in the cinematics list
    for _, cinematic in pairs(cinematicsList:GetChildren()) do
        count = count + 1
        
        -- Get cinematic details
        local hasVideos = cinematic:FindFirstChild("Videos") ~= nil
        local hasThumbnail = cinematic:FindFirstChild("Thumbnail") ~= nil
        
        -- Print basic info
        print("\n" .. count .. ". " .. cinematic.Name)
        print("   Videos: " .. (hasVideos and "✓" or "✗"))
        print("   Thumbnail: " .. (hasThumbnail and "✓" or "✗"))
        
        -- Try to get full cinematic data using the function
        local success, result, cinematicData, videos, thumbnail = pcall(function()
            return GetCinematic(cinematic.Name)
        end)
        
        if success and cinematicData then
            print("   Successfully retrieved cinematic data!")
            
            -- Print additional details if available
            local properties = {}
            for _, child in pairs(cinematic:GetChildren()) do
                if child.Name ~= "Videos" and child.Name ~= "Thumbnail" then
                    table.insert(properties, child.Name)
                end
            end
            
            if #properties > 0 then
                print("   Additional Properties: " .. table.concat(properties, ", "))
            end
        else
            print("   Failed to retrieve cinematic data: " .. tostring(result))
        end
    end
    
    -- Print summary
    print("\nTotal Cinematics Found: " .. count)
end

-- Execute the function
pcall(function()
    listAllCinematics()
end)

-- Function to attempt to get a specific cinematic by name
local function getCinematicByName(name)
    print("\nTrying to get cinematic: " .. name)
    
    local success, hasVideos, cinematicData, videos, thumbnail = pcall(function()
        return GetCinematic(name)
    end)
    
    if success and cinematicData then
        print("Successfully retrieved cinematic: " .. name)
        print("Has Videos: " .. tostring(hasVideos ~= nil))
        print("Has Thumbnail: " .. tostring(thumbnail ~= nil))
        
        -- Get video count if videos exist
        if videos then
            local videoCount = 0
            pcall(function()
                videoCount = #videos:GetChildren()
            end)
            print("Number of videos: " .. videoCount)
        end
    else
        print("Failed to retrieve cinematic: " .. tostring(hasVideos))
    end
end

-- Try to get the first cinematic in the list if any exist
local firstCinematic = cinematicsList:GetChildren()[1]
if firstCinematic then
    getCinematicByName(firstCinematic.Name)
end

print("\nCinematics listing complete!") 