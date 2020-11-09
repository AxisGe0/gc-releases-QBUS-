------------------------------------------
--	iEnsomatic RealisticVehicleFailure  --
------------------------------------------
--
--	Created by Jens Sandalgaard
--
--	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--
--	https://github.com/iEns/RealisticVehicleFailure
--

QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local function checkWhitelist(id)
	for key, value in pairs(RepairWhitelist) do
		if id == value then
			return true
		end
	end	
	return false
end

RegisterCommand('repair', function(source, args, raw)
 TriggerClientEvent('iens:repair',source)
end)
RegisterNetEvent('cash:repair')
AddEventHandler('cash:repair',function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local price = 100
	Player.Functions.RemoveMoney("cash", price, "sold-pawn-items")
end)	


