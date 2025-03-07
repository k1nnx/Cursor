--[[
    InfYiffLib
    A modern UI Library for Roblox
    Version: 1.0.0
    Loadstring Version
]]

local InfYiffLib = {}
InfYiffLib.__index = InfYiffLib

-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Constants
local LIBRARY_VERSION = "1.0.0"

-- Utility Functions
local function cloneref(o) 
    if typeof(cloneref) == "function" then
        return cloneref(o)
    end
    return o
end

-- Make frame draggable
local function makeDraggable(frame)
    local dragToggle = nil
    local dragSpeed = 0.1
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
            updateInput(input)
        end
    end)
end

-- Main UI Components
local function createBaseComponents()
    local components = {
        ScaledHolder = Instance.new("Frame"),
        Scale = Instance.new("UIScale"),
        Holder = Instance.new("Frame"),
        Title = Instance.new("TextLabel"),
        Dark = Instance.new("Frame"),
        Cmdbar = Instance.new("TextBox"),
        ScrollFrame = Instance.new("ScrollingFrame"),
        ListLayout = Instance.new("UIListLayout"),
        SettingsBtn = Instance.new("ImageButton"),
        ColorsBtn = Instance.new("ImageButton"),
        Settings = Instance.new("Frame")
    }

    -- Setup ScaledHolder
    components.ScaledHolder.Name = "ScaledHolder"
    components.ScaledHolder.BackgroundTransparency = 1
    components.ScaledHolder.Size = UDim2.new(1, 0, 1, 0)
    components.Scale.Parent = components.ScaledHolder

    -- Setup Holder
    components.Holder.Name = "MainHolder"
    components.Holder.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    components.Holder.BorderSizePixel = 0
    components.Holder.Position = UDim2.new(0.5, -200, 0.5, -135)
    components.Holder.Size = UDim2.new(0, 400, 0, 270)
    components.Holder.Parent = components.ScaledHolder
    components.Holder.Active = true -- Make it interactive

    -- Setup Title (now acts as drag handle)
    components.Title.Name = "Title"
    components.Title.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
    components.Title.BackgroundTransparency = 0
    components.Title.Size = UDim2.new(1, 0, 0, 35)
    components.Title.Font = Enum.Font.SourceSansBold
    components.Title.Text = "InfYiffLib"
    components.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    components.Title.TextSize = 24
    components.Title.Parent = components.Holder

    -- Setup ScrollFrame
    components.ScrollFrame.Name = "ScrollFrame"
    components.ScrollFrame.Parent = components.Holder
    components.ScrollFrame.BackgroundTransparency = 1
    components.ScrollFrame.Position = UDim2.new(0, 0, 0, 35)
    components.ScrollFrame.Size = UDim2.new(1, 0, 1, -35)
    components.ScrollFrame.ScrollBarThickness = 6
    components.ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    
    -- Setup ListLayout
    components.ListLayout.Parent = components.ScrollFrame
    components.ListLayout.Padding = UDim.new(0, 5)
    components.ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Make the UI draggable using the title bar
    makeDraggable(components.Holder)

    return components
end

-- Create new UI instance
function InfYiffLib.new()
    local self = setmetatable({}, InfYiffLib)
    
    -- Initialize components
    self.components = createBaseComponents()
    
    -- Wait for game to load if it hasn't
    if not game:IsLoaded() then
        local notLoaded = Instance.new("Message")
        notLoaded.Parent = CoreGui
        notLoaded.Text = "InfYiffLib is waiting for the game to load"
        game.Loaded:Wait()
        notLoaded:Destroy()
    end
    
    -- Parent the main UI to CoreGui
    self.components.ScaledHolder.Parent = CoreGui
    self.components.ScaledHolder.Visible = true -- Make sure it's visible by default
    
    return self
end

-- Add a button to the UI
function InfYiffLib:AddButton(text, callback)
    local button = Instance.new("TextButton")
    button.Name = text
    button.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Font = Enum.Font.SourceSans
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Parent = self.components.ScrollFrame
    
    -- Add hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(56, 56, 56)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(46, 46, 46)
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Toggle UI visibility
function InfYiffLib:Toggle()
    self.components.ScaledHolder.Visible = not self.components.ScaledHolder.Visible
end

-- Get library version
function InfYiffLib:GetVersion()
    return LIBRARY_VERSION
end

return InfYiffLib 