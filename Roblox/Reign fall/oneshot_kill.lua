-- OneShot Kill Script using hookmetamethod
-- This script intercepts remote event calls and modifies weapon parameters to ensure instant kills

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    -- Check if it's the RegisterHit remote event being called
    if method == "FireServer" and self.Name == "RegisterHit" and args[1] and args[3] then
        -- Modify weapon parameters for instant kills
        if type(args[3]) == "table" then
            -- Maximize damage
            args[3]["damage"] = 9999
            args[3]["headshot_multiplier"] = 10
            args[3]["explosion_damage"] = 9999
            args[3]["explosion_range"] = 50
            args[3]["explosion_size"] = 30
            args[3]["explosive_rounds"] = true
            args[3]["health_damage_multiplier"] = 10
            args[3]["armor_damage_multiplier"] = 10
            args[3]["downed_damage_multiplier"] = 10
            args[3]["ignores_armor"] = true
            args[3]["max_piercings"] = 10
            args[3]["melee_damage"] = 9999
            args[3]["pellet_amount"] = 10
            args[3]["knockback"] = 100
            args[3]["apply_effects_thru_armor"] = true
        end
        
        return old(self, unpack(args))
    end
    
    return old(self, ...)
end)

print("OneShot kill script loaded successfully!") 