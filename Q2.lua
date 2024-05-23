function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
    
    --This is just extra, but I feel safer with a ~= false check
    if resultId ~= false then
        local guildName = result.getString(resultId, "name")
        --[[
            This is probably the only major issue in the function. The results was trying to fetch "name" from nowhere
            I have never used sql with lua before and was lucky that I found some codes online for reference
            I was even contemplating on how to run a loop through the results for printing
        ]]--
        print(guildName)
    else
        print("No Guild matches the Criteria")
    end
end

--[[
    Additon:
    I am not sure about this one. I checked the guilds table from sql db from the TFS and there was no memberCount max_members column,
    I proceeded with the assumption that you added this column on your guilds table variant
]]--