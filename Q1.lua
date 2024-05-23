local logoutStoID = 1000
-- I like to declare constants outside like this so that in case there's a need for change, it is easier

local function releaseStorage(player)
    player:setStorageValue(logoutStoID, -1)
end

function onLogout(player)
    --[[
        I am not quite sure why the original branch is a boolean check on = 1, it is a number that have no context for me
        I took the liberty of chaning it to -1 based on the releaseStorage function. Since it is setting the StorageVlaue to -1
        I assume that it is supposed to reset the StorageValue back to -1 on logout so the check that is need is if it is not yet -1
    ]]-- 
    if player:getStorageValue(logoutStoID) ~= -1 then
        addEvent(releaseStorage, 1000, player)
        -- I nearly changed the 1000 here with the declared constant until I found the documentation that it is a delay, not the StorageID
    end
        return true
end