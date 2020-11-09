QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('gc_mining:getItem')
AddEventHandler('gc_mining:getItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local randomItem = Config.Items[math.random(1, #Config.Items)]
    if math.random(0, 100) <= Config.ChanceToGetItem then
        Player.Functions.AddItem(randomItem, 1)
        TriggerClientEvent('QBCore:Notify', src, "You Broke A Stone", "error")
    end
end)

RegisterServerEvent('gc_mining:sell')
AddEventHandler('gc_mining:sell', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    reward = math.random(40,80)
    if Player.Functions.GetItemByName('emerald') then
        Player.Functions.AddMoney("cash", reward+20, "sold-pawn-items")
        Player.Functions.RemoveItem('emerald', 1)
    elseif Player.Functions.GetItemByName('carbon') then
        Player.Functions.AddMoney("cash", reward+30, "sold-pawn-items")
        Player.Functions.RemoveItem('carbon', 1)
    elseif Player.Functions.GetItemByName('ironore') then
        Player.Functions.AddMoney("cash", reward+40, "sold-pawn-items")
        Player.Functions.RemoveItem('ironore', 1)
    elseif Player.Functions.GetItemByName('copperore') then
        Player.Functions.AddMoney("cash", reward+50, "sold-pawn-items")
        Player.Functions.RemoveItem('copperore', 1)
    elseif Player.Functions.GetItemByName('goldore') then
        Player.Functions.AddMoney("cash", reward+60, "sold-pawn-items")
        Player.Functions.RemoveItem('goldore', 1)
    end
end)