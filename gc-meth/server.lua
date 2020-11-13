-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 

QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- START TEST
local JobCooldown 		= {}
local ConvertTimer		= {}
local DrugEffectTimer	= {}
local soldAmount 		= {}

RegisterServerEvent("gc-drugs:syncJobsData")
AddEventHandler("gc-drugs:syncJobsData",function(data)
	TriggerClientEvent("gc-drugs:syncJobsData",-1,data)
end)

-- Server side table, to store cooldown for players:
RegisterServerEvent("gc-drugs:addCooldownToSource")
AddEventHandler("gc-drugs:addCooldownToSource",function(source)
	table.insert(JobCooldown,{cooldown = GetPlayerIdentifier(source), time = (Config.CooldownTime * 60000)})
end)

-- Server side table, to store convert timer for players:
RegisterServerEvent("gc-drugs:addConvertingTimer")
AddEventHandler("gc-drugs:addConvertingTimer",function(source,timer)
	table.insert(ConvertTimer,{convertWait = GetPlayerIdentifier(source), timeB = timer})
end)

-- Server side table, to store drug effect timer for players:
RegisterServerEvent("gc-drugs:addDrugEffectTimer")
AddEventHandler("gc-drugs:addDrugEffectTimer",function(source,timer)
	table.insert(DrugEffectTimer,{effectWait = GetPlayerIdentifier(source), timeC = timer})
end)

-- CreateThread Function for timer:
Citizen.CreateThread(function() -- do not touch this thread function!
	while true do
	Citizen.Wait(1000)
		for k,v in pairs(JobCooldown) do
			if v.time <= 0 then
				RemoveCooldown(v.cooldown)
			else
				v.time = v.time - 1000
			end
		end
		for k,v in pairs(ConvertTimer) do
			if v.timeB <= 0 then
				RemoveConvertTimer(v.convertWait)
			else
				v.timeB = v.timeB - 1000
			end
		end
		for k,v in pairs(DrugEffectTimer) do
			if v.timeC <= 0 then
				RemoveDrugEffectTimer(v.effectWait)
			else
				v.timeC = v.timeC - 1000
			end
		end
	end
end)
QBCore.Functions.CreateUseableItem('meth10g', function(source)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	TriggerClientEvent('gc-drugs:meth10g',source)
	Wait(5000)
	xPlayer.Functions.AddItem('meth1g',10)
end)
RegisterServerEvent("gc-drugs:process")
AddEventHandler("gc-drugs:process",function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	xPlayer.Functions.AddItem('meth10g',10)
end)
RegisterServerEvent("gc-drugs:pendrive")
AddEventHandler("gc-drugs:pendrive",function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	xPlayer.Functions.AddItem('drugitem',1)
end)
QBCore.Functions.CreateUseableItem('drugitem', function(source)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	if not HasCooldown(GetPlayerIdentifier(source)) then
		if xPlayer.Functions.GetItemByName('phone') ~= nil then
			TriggerClientEvent("gc-drugs:UsableItem",source)
		else
			TriggerClientEvent('QBCore:Notify', source, "You need a phone to use the ~y~USB~s~", 'error')
		end
	 else
		TriggerClientEvent('QBCore:Notify', source,string.format("~y~USB~s~ is usable in: ~b~%s minutes~s~",GetCooldownTime(GetPlayerIdentifier(source))))
  	end
end)

-- Server Event for Buying Drug Job:
RegisterServerEvent("gc-drugs:GetSelectedJob")
AddEventHandler("gc-drugs:GetSelectedJob", function(drugType,BuyPrice,minReward,maxReward)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local itemLabel = ''
	TriggerEvent("gc-drugs:addCooldownToSource",source)
	TriggerClientEvent("gc-drugs:BrowseAvailableJobs",source, 0, drugType, minReward, maxReward)
	label = "Meth"
end)

-- Server Event for Job Reward:
RegisterServerEvent("gc-drugs:JobReward")
AddEventHandler("gc-drugs:JobReward",function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	xPlayer.Functions.AddItem('methbrick',3)
end)

-- Usable item for drug effects:
Citizen.CreateThread(function()
	for k,v in pairs(Config.DrugEffects) do 
		QBCore.Functions.CreateUseableItem(v.UsableItem, function(source)
			local xPlayer = QBCore.Functions.GetPlayer(source)
			if not DrugEffect(GetPlayerIdentifier(source)) then
				TriggerEvent("gc-drugs:addDrugEffectTimer",source,v.UsableTime)
				xPlayer.Functions.RemoveItem(v.UsableItem,1)
				TriggerClientEvent("gc-drugs:DrugEffects",source,k,v)
			else
				TriggerClientEvent('QBCore:Notify', source, string.format("You are ~b~already~s~ consuming a drug",GetDrugEffectTime(GetPlayerIdentifier(source))), 'error')
			end	
		end)
	end
end)

-- Usable item to convert drugs:


RegisterServerEvent('gc-drugs:DrugJobInProgress')
AddEventHandler('gc-drugs:DrugJobInProgress', function(targetCoords, streetName)
	TriggerClientEvent('gc-drugs:outlawNotify', -1,string.format("^0Shots fired and ongoing grand theft auto at ^5%s^0",streetName))
	TriggerClientEvent('gc-drugs:OutlawBlipEvent', -1, targetCoords)
end)

RegisterServerEvent('gc-drugs:DrugSaleInProgress')
AddEventHandler('gc-drugs:DrugSaleInProgress', function(targetCoords, streetName)
	TriggerClientEvent('gc-drugs:outlawNotify', -1,string.format("^0Possible drug sale at ^5%s^0",streetName))
	TriggerClientEvent('gc-drugs:OutlawBlipEvent', -1, targetCoords)
end)

RegisterServerEvent("gc-drugs:sellDrugs")
AddEventHandler("gc-drugs:sellDrugs", function()
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local weed = xPlayer.Functions.GetItemByName(Config.WeedDrug)
	local meth = xPlayer.Functions.GetItemByName(Config.MethDrug)
	local coke = xPlayer.Functions.GetItemByName(Config.CokeDrug)
	local drugamount = 0
	local price = 0
	local drugType = nil
	
	if weed > 0 then
		drugType = Config.WeedDrug
		if weed == 1 then
			drugamount = 1
		elseif weed == 2 then
			drugamount = math.random(1,2)
		elseif weed == 3 then	
			drugamount = math.random(1,3)
		elseif weed >= 4 then	
			drugamount = math.random(1,4)
		end
		
	elseif meth > 0 then
		drugType = Config.MethDrug
		if meth == 1 then
			drugamount = 1
		elseif meth == 2 then
			drugamount = math.random(1,2)
		elseif meth >= 3 then	
			drugamount = math.random(1,3)
		end
		
	elseif coke > 0 then
		drugType = Config.CokeDrug
		if coke == 1 then
			drugamount = 1
		elseif coke == 2 then
			drugamount = math.random(1,2)
		elseif coke >= 3 then	
			drugamount = math.random(1,3)
		end
	
	else
		TriggerClientEvent('QBCore:Notify', source, "You have ~r~no more~r~ ~y~drugs~s~ on you", 'error')
		return
	end
	
	if drugType==Config.WeedDrug then
		price = math.random(Config.WeedSale.min,Config.WeedSale.max) * 10 * drugamount
	elseif drugType==Config.MethDrug then
		price = math.random(Config.MethSale.min,Config.MethSale.max) * 10 * drugamount
	elseif drugType==Config.CokeDrug then
		price = math.random(Config.CokeSale.min,Config.CokeSale.max) * 10 * drugamount
	end
	
	if drugType ~= nil then
		local drugLabel = ''
		AddToSoldAmount(xPlayer.getIdentifier(),drugamount)
		xPlayer.Functions.RemoveItem(drugType, drugamount)
		if Config.ReceiveDirtyCash then
			xPlayer.addAccountMoney('black_money', price)
		else
			xPlayer.addMoney(price)
		end
		TriggerClientEvent('QBCore:Notify', source,"You sold ~b~"..drugamount.."x~s~ ~y~"..drugLabel.."~s~ for ~r~$"..price.."~s~", 'error')
	end		
end)

RegisterServerEvent("gc-drugs:canSellDrugs")
AddEventHandler("gc-drugs:canSellDrugs", function()
	
end)

function AddToSoldAmount(source,amount)
	for k,v in pairs(soldAmount) do
		if v.id == source then
			v.amount = v.amount + amount
			return
		end
	end
end
function CheckSoldAmount(source)
	for k,v in pairs(soldAmount) do
		if v.id == source then
			return v.amount
		end
	end
	table.insert(soldAmount,{id = source, amount = 0})
	return CheckSoldAmount(source)
end


function RemoveCooldown(source)
	for k,v in pairs(JobCooldown) do
		if v.cooldown == source then
			table.remove(JobCooldown,k)
		end
	end
end
function GetCooldownTime(source)
	for k,v in pairs(JobCooldown) do
		if v.cooldown == source then
			return math.ceil(v.time/60000)
		end
	end
end
function HasCooldown(source)
	for k,v in pairs(JobCooldown) do
		if v.cooldown == source then
			return true
		end
	end
	return false
end
function RemoveDrugEffectTimer(source)
	for k,v in pairs(DrugEffectTimer) do
		if v.effectWait == source then
			table.remove(DrugEffectTimer,k)
		end
	end
end
function GetDrugEffectTime(source)
	for k,v in pairs(DrugEffectTimer) do
		if v.effectWait == source then
			return math.ceil(v.timeC/1000)
		end
	end
end
function DrugEffect(source)
	for k,v in pairs(DrugEffectTimer) do
		if v.effectWait == source then
			return true
		end
	end
	return false
end
function RemoveConvertTimer(source)
	for k,v in pairs(ConvertTimer) do
		if v.convertWait == source then
			table.remove(ConvertTimer,k)
		end
	end
end
function GetConvertTime(source)
	for k,v in pairs(ConvertTimer) do
		if v.convertWait == source then
			return math.ceil(v.timeB/1000)
		end
	end
end
function Converting(source)
	for k,v in pairs(ConvertTimer) do
		if v.convertWait == source then
			return true
		end
	end
	return false
end
