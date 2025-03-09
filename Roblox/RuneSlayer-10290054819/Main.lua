function load()
loadstring(game:HttpGet('https://raw.githubusercontent.com/k1nnx/Cursor/refs/heads/main/Roblox/RuneSlayer-10290054819/Functions.lua'))()
local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local PrefabsId = `rbxassetid://{ReGui.PrefabsId}`

ReGui:Init({
	Prefabs = game:GetService("InsertService"):LoadLocalAsset(PrefabsId)
})
local TabsWindow = ReGui:TabsWindow({
	Title = "RuneSlayer-10290054819",
	Size = UDim2.fromOffset(600, 400)
})
local Tab = TabsWindow:CreateTab({
	Name="Console"
})
local Console = Tab:Console({
    AutoScroll = true,
    RichText = true,
    ReadOnly = true,
    LineNumbers = true,
})
local Tab = TabsWindow:CreateTab({
	Name="Mobs"
})
local List = Tab:List({
    Padding = 10,
})
for _, mob in getMobInfo() do
    List:Label(mob)
end
for _, mob in getMobInfo() do
    for attributeName, attributeValue in pairs(mob) do
        List:Label(attributeName .. ": " .. tostring(attributeValue))
    end
end
end
load()