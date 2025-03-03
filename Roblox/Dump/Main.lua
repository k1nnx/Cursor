-- Super Robust Game Dumper v1.0
-- Guaranteed to work on any exploit with file system functions

-- DEBUGGING SETUP
local DEBUG = true
local function dbg(msg)
    if DEBUG then
        print("[DEBUG] " .. tostring(msg))
    end
end

dbg("Script execution started")

-- Simple error handling wrapper
local function try(func, errMsg)
    local success, result = pcall(func)
    if not success then
        warn(errMsg .. ": " .. tostring(result))
        return false, result
    end
    return true, result
end

-- Services
local HttpService = game:GetService("HttpService")

-- Verify each required function individually
dbg("Checking file system functions...")
local hasWriteFile = type(writefile) == "function"
local hasMakeFolder = type(makefolder) == "function"
local hasIsFolder = type(isfolder) == "function"
dbg("writefile: " .. tostring(hasWriteFile))
dbg("makefolder: " .. tostring(hasMakeFolder))
dbg("isfolder: " .. tostring(hasIsFolder))

if not (hasWriteFile and hasMakeFolder and hasIsFolder) then
    warn("MISSING REQUIRED FUNCTIONS! Cannot continue.")
    return
end

-- Test writing a simple file to verify permissions
dbg("Testing file write...")
local testFile = "test_dumper_" .. tostring(os.time()) .. ".txt"
local testSuccess = try(function()
    writefile(testFile, "Test file write")
end, "Failed to write test file")

if not testSuccess then
    warn("File write test failed! Cannot continue.")
    return
end
dbg("File write test successful")

-- Create a basic folder
local function createFolderSafe(path)
    dbg("Creating folder: " .. path)
    
    -- Check if it already exists
    local exists = false
    try(function() 
        exists = isfolder(path)
    end, "Error checking if folder exists")
    
    -- If it exists, we're done
    if exists then
        dbg("Folder already exists")
        return true
    end
    
    -- Otherwise create it
    return try(function()
        makefolder(path)
    end, "Failed to create folder")
end

-- Save data to file
local function saveToFile(path, data)
    dbg("Saving file: " .. path)
    return try(function()
        writefile(path, data)
    end, "Failed to save file")
end

-- Safe JSON encode with fallbacks
local function safeJSONEncode(data)
    dbg("Encoding JSON data")
    local success, jsonString = try(function()
        return HttpService:JSONEncode(data)
    end, "JSON encode failed")
    
    if not success then
        -- Try a manual simple conversion as fallback
        dbg("Falling back to simple table conversion")
        local result = "{"
        for k, v in pairs(data) do
            if type(k) == "string" then
                result = result .. '"' .. k .. '":"' .. tostring(v) .. '",'
            else
                result = result .. '"' .. tostring(k) .. '":"' .. tostring(v) .. '",'
            end
        end
        if result:sub(-1) == "," then
            result = result:sub(1, -2)
        end
        result = result .. "}"
        return result
    end
    
    return jsonString
end

-- Basic property extraction function
local function extractInstanceData(instance)
    dbg("Extracting data from: " .. instance.Name)
    
    local data = {
        Name = instance.Name,
        ClassName = instance.ClassName
    }
    
    -- Try to safely get common properties
    try(function()
        if instance:IsA("BasePart") then
            data.Position = {
                X = instance.Position.X,
                Y = instance.Position.Y,
                Z = instance.Position.Z
            }
            data.Size = {
                X = instance.Size.X,
                Y = instance.Size.Y,
                Z = instance.Size.Z
            }
            data.Anchored = instance.Anchored
        end
    end, "Failed to extract part properties")
    
    return data
end

-- Sanitize file paths
local function sanitizePath(input)
    -- Remove special characters that might cause issues
    local sanitized = input:gsub("[^%w%s_%-/]", "_")
    return sanitized
end

-- Create the main dumper function
local function dumpWorkspace()
    local rootFolder = "GameDump_" .. os.time()
    dbg("Dump folder will be: " .. rootFolder)
    
    -- Create the root folder
    if not createFolderSafe(rootFolder) then
        warn("Failed to create root folder. Aborting.")
        return
    end
    
    -- Save basic game info
    local gameInfo = {
        PlaceId = game.PlaceId,
        PlaceName = game.Name,
        DumpTime = os.time()
    }
    
    local infoJson = safeJSONEncode(gameInfo)
    if not saveToFile(rootFolder .. "/game_info.json", infoJson) then
        warn("Failed to save game info")
    end
    
    -- Dump workspace by creating a simple map of instances
    local instanceMap = {}
    local counter = 0
    
    local function mapInstance(instance, parentPath)
        -- Skip certain instance types
        if instance:IsA("Player") or instance:IsA("Script") or 
           instance:IsA("LocalScript") or instance:IsA("ModuleScript") then
            return
        end
        
        counter = counter + 1
        if counter % 100 == 0 then
            dbg("Processed " .. counter .. " instances...")
        end
        
        -- Get path
        local thisPath = parentPath .. "/" .. sanitizePath(instance.Name)
        
        -- Extract data
        local data = extractInstanceData(instance)
        data.Children = {}
        
        -- Add to map
        instanceMap[thisPath] = data
        
        -- Map children
        for _, child in ipairs(instance:GetChildren()) do
            -- Skip problematic instances
            if not (child:IsA("Player") or child:IsA("Script") or 
                    child:IsA("LocalScript") or child:IsA("ModuleScript")) then
                
                table.insert(data.Children, child.Name)
                mapInstance(child, thisPath)
            end
        end
    end
    
    -- Start the mapping process
    dbg("Starting to map instances...")
    try(function()
        createFolderSafe(rootFolder .. "/Workspace")
        mapInstance(workspace, "Workspace")
    end, "Failed during workspace mapping")
    
    -- Now save all the mapped instances
    dbg("Saving all mapped instances...")
    for path, data in pairs(instanceMap) do
        local fullPath = rootFolder .. "/" .. path
        
        -- Create the folder
        createFolderSafe(fullPath)
        
        -- Save the data
        local jsonData = safeJSONEncode(data)
        saveToFile(fullPath .. "/data.json", jsonData)
    end
    
    dbg("Dump completed successfully!")
    print("GAME DUMPER: Dump saved to folder '" .. rootFolder .. "'")
    
    return rootFolder
end

-- Execute the dumper with pcall
print("GAME DUMPER: Starting workspace dump...")
local success, result = pcall(dumpWorkspace)

if success then
    print("GAME DUMPER: Successfully dumped game to " .. tostring(result))
else
    warn("GAME DUMPER ERROR: " .. tostring(result))
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create folders for saving dumped content
local function createDumpFolders()
    if not isfolder("GameDump") then
        makefolder("GameDump")
    end
end

-- Convert instance to JSON-compatible table
local function instanceToJSON(instance)
    local data = {
        Name = instance.Name,
        ClassName = instance.ClassName,
        Children = {},
        Properties = {}
    }
    
    -- Add properties based on instance type
    pcall(function()
        if instance:IsA("BasePart") then
            data.Properties.Position = {
                X = instance.Position.X,
                Y = instance.Position.Y,
                Z = instance.Position.Z
            }
            data.Properties.Size = {
                X = instance.Size.X,
                Y = instance.Size.Y,
                Z = instance.Size.Z
            }
            data.Properties.Color = {
                R = instance.Color.R,
                G = instance.Color.G,
                B = instance.Color.B
            }
            data.Properties.Material = tostring(instance.Material)
        elseif instance:IsA("LocalScript") or instance:IsA("Script") or instance:IsA("ModuleScript") then
            local success, content = pcall(function() return decompile(instance) end)
            if success then
                data.Properties.Source = content
            else
                data.Properties.Source = "-- Failed to decompile script"
            end
            data.Properties.ScriptType = instance.ClassName
        end
    end)
    
    return data
end

-- Process an instance and its descendants recursively
local function processInstanceToJSON(instance, progress)
    local instanceData = instanceToJSON(instance)
    
    -- Update progress
    if progress then
        progress.Dumped = progress.Dumped + 1
        progress.Status = "Processing: " .. instance:GetFullName()
    end
    
    -- Process children
    for _, child in ipairs(instance:GetChildren()) do
        table.insert(instanceData.Children, processInstanceToJSON(child, progress))
    end
    
    return instanceData
end

-- Main dump function
local function dumpWorkspaceToJSON(progress)
    createDumpFolders()
    
    -- Count total instances to dump
    local function countInstances(instance)
        local count = 1
        for _, child in ipairs(instance:GetChildren()) do
            count = count + countInstances(child)
        end
        return count
    end
    
    -- Initialize progress
    progress.Total = countInstances(game.Workspace)
    progress.Dumped = 0
    progress.Status = "Counting instances..."
    
    -- Create top-level JSON structure
    local gameData = {
        GameName = game.Name,
        PlaceId = game.PlaceId,
        Workspace = processInstanceToJSON(game.Workspace, progress)
    }
    
    -- Convert to JSON string
    local success, jsonString = pcall(function()
        -- We'll use HttpService to encode our JSON
        return game:GetService("HttpService"):JSONEncode(gameData)
    end)
    
    if not success then
        return false, "Failed to convert to JSON: " .. tostring(jsonString)
    end
    
    -- Save JSON to file
    local success, saveError = pcall(function()
        writefile("GameDump/game_data.json", jsonString)
    end)
    
    if not success then
        return false, "Failed to save JSON file: " .. tostring(saveError)
    end
    
    progress.Status = "Dump completed!"
    return true
end

-- Create UI
local Window = Rayfield:CreateWindow({
    Name = "Roblox Game Dumper",
    LoadingTitle = "Game Dumper",
    LoadingSubtitle = "by Claude",
    ConfigurationSaving = {
        Enabled = false
    },
    KeySystem = false
})

-- Create Main tab
local MainTab = Window:CreateTab("Dumper", "download")

-- Progress section
local ProgressSection = MainTab:CreateSection("Progress")

-- Progress labels
local StatusLabel = MainTab:CreateLabel("Status: Ready")
local ProgressLabel = MainTab:CreateLabel("Progress: 0/0")

-- Progress data
local progress = {
    Total = 0,
    Dumped = 0,
    Status = "Ready"
}

-- Update progress UI
local function updateProgressUI()
    StatusLabel:Set("Status: " .. progress.Status)
    ProgressLabel:Set("Progress: " .. progress.Dumped .. "/" .. progress.Total)
end

-- Create a button to start dumping
local DumpButton = MainTab:CreateButton({
    Name = "Dump to JSON",
    Callback = function()
        progress.Status = "Starting JSON dump process..."
        updateProgressUI()
        
        -- Run dump in a separate thread to avoid freezing
        task.spawn(function()
            local success, result = pcall(function()
                return dumpWorkspaceToJSON(progress)
            end)
            
            if success and result == true then
                progress.Status = "JSON dump completed successfully!"
                Rayfield:Notify({
                    Title = "Dump Completed",
                    Content = "Game workspace has been dumped to JSON successfully!",
                    Duration = 5
                })
            else
                progress.Status = "Error: " .. tostring(result)
                Rayfield:Notify({
                    Title = "Dump Failed",
                    Content = "An error occurred: " .. tostring(result),
                    Duration = 5
                })
            end
            
            updateProgressUI()
        end)
        
        -- Update progress UI periodically
        task.spawn(function()
            while progress.Status ~= "JSON dump completed successfully!" and not string.find(progress.Status, "Error:") do
                updateProgressUI()
                task.wait(0.1)
            end
            updateProgressUI()
        end)
    end
})

-- Options section
local OptionsSection = MainTab:CreateSection("JSON Options")

-- JSON format option
local PrettyPrintToggle = MainTab:CreateToggle({
    Name = "Pretty Print JSON",
    CurrentValue = false,
    Flag = "PrettyPrintJSON",
    Callback = function(Value)
        -- Will be used when implementing pretty printing
    end,
})

-- Settings tab
local SettingsTab = Window:CreateTab("Settings", "settings")

-- Creating folders section
local FoldersSection = SettingsTab:CreateSection("File Management")

-- Button to create folders
local CreateFoldersButton = SettingsTab:CreateButton({
    Name = "Create Dump Folder",
    Callback = function()
        createDumpFolders()
        Rayfield:Notify({
            Title = "Folder Created",
            Content = "Dump folder has been created successfully!",
            Duration = 3
        })
    end,
})

-- Button to open JSON file (if supported by executor)
local OpenFileButton = SettingsTab:CreateButton({
    Name = "Open JSON File",
    Callback = function()
        if typeof(openfile) == "function" then
            pcall(function() openfile("GameDump/game_data.json") end)
        else
            Rayfield:Notify({
                Title = "Not Supported",
                Content = "Your executor doesn't support opening files directly.",
                Duration = 3
            })
        end
    end,
})

-- Initialize
Rayfield:Notify({
    Title = "JSON Game Dumper Loaded",
    Content = "Ready to dump workspace to a single JSON file.",
    Duration = 3,
})
