--[[
    I do noy quite understadn the question
    I assume the naming issue relate with do_sth_with_PlayerParty which indicates nothing in terms of what the function does
    also replaced player and party with mPlayer and mParty to reduce confusion with Player and Party
]]

function partyRemoveMember(playerId, membername)
    local mPlayer = Player(playerId)
    local mParty = mPlayer:getParty()

    --removed k since it is not used
    for _,v in pairs(mParty:getMembers()) do
        if v == Player(membername) then
            mParty:removeMember(v)
        end
    end
end