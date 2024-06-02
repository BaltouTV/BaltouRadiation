ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('checkAntiRadiationMask', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = exports.ox_inventory:GetItem(source, 'antiradiationmask')

    if item and item.count and item.count > 0 then
        cb(true)
    else
        cb(false)
    end
end)
