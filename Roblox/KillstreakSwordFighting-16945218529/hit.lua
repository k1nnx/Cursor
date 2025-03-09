local function findlocal(Name)
    for i,v in pairs(getgc()) do
        if type(v) == "function" then and not 
            for i2,v2 in pairs(getupvalues(v)) do
                if i2 == Name then return v2 end
            end
        end
    end
end


local network = findlocal("Network")

print(network)
