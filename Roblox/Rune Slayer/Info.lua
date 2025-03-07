local Plugin = {
	["PluginName"] = "Left",
	["PluginDescription"] = "Left",
	["Commands"] = {
		["Left"] = {
			["ListName"] = "Left",
			["Description"] = "Left the left",
			["Aliases"] = { "Left" },
			["Function"] = function(args, speaker)
                spawn(function()
                    -- Get player's screen size to allow for relative positioning
                    local player = game.Players.LocalPlayer
                    if not player then
                        warn("LocalPlayer not found")
                        return
                    end
                    
                    local screenGui = player:FindFirstChildOfClass("PlayerGui"):FindFirstChildOfClass("ScreenGui")
                    if not screenGui then
                        warn("ScreenGui not found")
                        return
                    end
                    
                    local viewportSize = screenGui.AbsoluteSize
                    
                    if Holder then
                        -- Position on the left side of the screen with relative positioning
                        Holder.Position = UDim2.new(0, 10, 0.8, 0) -- Left side, 80% down from top
                        
                        if Notification then
                            -- Position notification appropriately with relative scaling
                            Notification.Position = UDim2.new(0, 10, 0.05, 0) -- Left side, 5% down from top
                        end
                    else
                        warn("Holder is nil. Make sure it's defined before running this command.")
                    end
                end)
			end,
		},
	},
}
return Plugin
