function mobtab()
    for _, mob in getMob() do
        local mobList = MobsTab:TreeNode({
            Title = mob.Name,
            NoAnimatio = false,
        })

        local attributesList = mobList:TreeNode({
            Title = "Attributes",
            NoAnimatio = false,
        })

        -- Display mob attributes
        for attributeName, attributeValue in pairs(mob:GetAttributes()) do
            if typeof(attributeValue) == "number" then
                attributesList:Label({
                    Text = attributeName .. ": " .. math.round(attributeValue)
                })
            else
                attributesList:Label({
                    Text = attributeName .. ": " .. tostring(attributeValue)
                })
            end
        end
    end
end

mobtab()