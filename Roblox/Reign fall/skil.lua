-- Decompiler will be improved soon!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-03-03 17:48:51
-- Luau version 6, Types version 3
-- Time taken: 0.000655 seconds

local CreateFullSkillset_upvr = require(game.ReplicatedStorage.Functions.Skills.Skillsets.CreateFullSkillset)
return function(arg1) -- Line 11
	--[[ Upvalues[1]:
		[1]: CreateFullSkillset_upvr (readonly)
	]]
	local var4 = arg1
	if var4 then
		var4 = game.ReplicatedStorage.Assets.GameplayAssets.Skills.List:FindFirstChild(arg1)
	end
	if var4 then
		local Icon = var4:FindFirstChild("Icon")
		local CreateFullSkillset_upvr_result1 = CreateFullSkillset_upvr(arg1)
		return Icon and CreateFullSkillset_upvr_result1, Icon, CreateFullSkillset_upvr_result1
	end
end
