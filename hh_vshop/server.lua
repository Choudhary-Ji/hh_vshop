QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


local carTable = {
	[1] = { ["model"] = "Krieger", ["baseprice"] = 375000, ["commission"] = 20 }, 
	[2] = { ["model"] = "issi3", ["baseprice"] = 35000, ["commission"] = 20 },
	[3] = { ["model"] = "sanctus", ["baseprice"] = 35000, ["commission"] = 20 },
	[4] = { ["model"] = "kuruma", ["baseprice"] = 110000, ["commission"] = 20 },
	[5] = { ["model"] = "feltzer3", ["baseprice"] = 120000, ["commission"] = 20 },
	[6] = { ["model"] = "taipan", ["baseprice"] = 378000, ["commission"] = 20 },
	[7] = { ["model"] = "gburrito", ["baseprice"] = 85000, ["commission"] = 20 },
}

-- Update car table to server
RegisterServerEvent('carshop:table')
AddEventHandler('carshop:table', function(table)
    if table ~= nil then
        carTable = table
        TriggerClientEvent('veh_shop:returnTable', -1, carTable)
        updateDisplayVehicles()
    end
end)

-- Enables finance for 60 seconds
RegisterServerEvent('finance:enable')
AddEventHandler('finance:enable', function(plate)
    if plate ~= nil then
        TriggerClientEvent('finance:enableOnClient', -1, plate)
    end
end)
-- Enables Buy for 60 seconds
RegisterServerEvent('buy:enable')
AddEventHandler('buy:enable', function(plate)
    if plate ~= nil then
        TriggerClientEvent('buy:enableOnClient', -1, plate)
    end
end)

-- return table
-- TODO (return db table)
RegisterServerEvent('carshop:requesttable')
AddEventHandler('carshop:requesttable', function()
    local src = source
    local user = QBCore.Functions.GetPlayer(source)
    local display = QBCore.Functions.ExecuteSql(false, "SELECT * FROM vehicles_display")
    for k,v in pairs(display) do
        carTable[v.ID] = v
        v.price = carTable[v.ID].baseprice
    end
    TriggerClientEvent('veh_shop:returnTable', source, carTable)
end)

-- Check if player has enough money
RegisterServerEvent('CheckMoneyForVeh')
AddEventHandler('CheckMoneyForVeh', function(name, model, price, financed)
	local user = QBCore.Functions.GetPlayer(source)
    local money = user.PlayerData.money["cash"]
    if financed then
        local financedPrice = math.ceil(price / 3)
        if money >= financedPrice then
            user.Functions.RemoveMoney('cash', financedPrice, "vehicle-bought-in-shop")
            TriggerClientEvent('FinishMoneyCheckForVeh', source, name, model, price, financed)
        else
            TriggerClientEvent("QBCore:Notify", source, "You dont have enough Money", "error", 4000)
            TriggerClientEvent('carshop:failedpurchase', source)
        end
    else
        if money >= price then
        --    user.Functions.RemoveMoney('cash', price) 
            user.Functions.RemoveMoney('cash', price, "vehicle-bought-in-shop")
            TriggerClientEvent('FinishMoneyCheckForVeh', source, name, model, price, financed)
        else
            TriggerClientEvent("QBCore:Notify", source, "You dont have enough Money", "error", 4000)
            TriggerClientEvent('carshop:failedpurchase', source)
        end
    end
end)

function updateDisplayVehicles()
    for i=1, #carTable do
        QBCore.Functions.ExecuteSql(false, "UPDATE `vehicles_display` SET `model`='"..carTable[i]["model"].."', `commission`='"..carTable[i]["commission"].."', `baseprice`='"..carTable[i]["baseprice"].."' WHERE `ID`='"..i.."'")
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        updateDisplayVehicles()
    end
end)


-- Add the car to database when completed purchase
RegisterServerEvent('lundlele:server:SaveCar')
AddEventHandler('lundlele:server:SaveCar', function(mods, vehicle, hash, plate, price, financed)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local date = os.date('%Y-%m-%d')
    if financed then
        local repayTime = 168 -- Hours
        local downPay = math.ceil(price / 3)
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
            if result[1] == nil then
                QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `buy_price`, `finance`, `repaytime`, `date`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicle.model.."', '"..vehicle.hash.."', '"..json.encode(mods).."', '"..plate.."', '"..price.."', '"..(price - downPay).."', '"..repayTime.."', '"..date.."', ' 0')")
                TriggerClientEvent('QBCore:Notify', src, 'Congratulations! Your vehicle is deliverd ', 'success', 6000)
                TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehiclebought", {model=vehicle.model, moneyType="cash", price=downPay, plate=plate})
                TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Vehicle bought on Finance", "**"..GetPlayerName(src) .. "** Bought a " .. vehicle.model .. " for Downpayement of $" .. downPay)
            else
                TriggerClientEvent('QBCore:Notify', src, 'This vehicle is already registered..', 'error', 4000)
            end
        end)
    else
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
            if result[1] == nil then
                QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `buy_price`, `date`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicle.model.."', '"..vehicle.hash.."', '"..json.encode(mods).."', '"..plate.."', '"..price.."', '"..date.."', ' 0')")
                TriggerClientEvent('QBCore:Notify', src, 'Congratulations! Your vehicle is deliverd ', 'success', 6000)
                TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehiclebought", {model=vehicle.model, moneyType="cash", price=price, plate=plate})
                TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Vehicle bought", "**"..GetPlayerName(src) .. "** Bought a " .. vehicle.model .. " for $" .. price)
            else
                TriggerClientEvent('QBCore:Notify', src, 'This vehicle is already registered..', 'error', 4000)
            end
        end)
    end
end)

-----------Finance Nai Gand Marli-----------

local timer = ((60 * 1000) * 60) -- 60 minute timer -- 1 Hour
function updateFinance()
    exports['ghmattimysql']:execute('SELECT repaytime, plate FROM player_vehicles WHERE repaytime > @repaytime', {
        ['@repaytime'] = 0
    }, function(result)
        for i=1, #result do
            local financeTimer = result[i].repaytime
            local plate = result[i].plate
            local newTimer = financeTimer - 1  ---1 Hour Cut
            if financeTimer ~= nil then
                QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `repaytime`='"..newTimer.."'  WHERE `plate`='"..plate.."'")
            end
        end
    end)
    SetTimeout(timer, updateFinance)
end
SetTimeout(timer, updateFinance)



-- Event to check finance status on player login:
RegisterNetEvent('lund:CheckFinanceStatus')
AddEventHandler('lund:CheckFinanceStatus', function()
    local src = source
	local xPlayer = QBCore.Functions.GetPlayer(source)

	local foundOwedVeh = false
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..xPlayer.PlayerData.citizenid.."'", function(results)
		-- Looping through results:
		for k,v in pairs(results) do
			if v.repaytime < 1 and v.finance > 1 then
				foundOwedVeh = true
			end	
            if v.finance <  1 then
                QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `repaytime`='0' WHERE `plate`='"..v.plate.."'")
            end
		end
		
		if foundOwedVeh then
            -- Editing found vehicle:
			TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "SBI: Last Warning Clear Vehicle Finance Before 10 Minutes", "error", 7000) 
			Citizen.Wait(600000)
            exports['ghmattimysql']:execute("SELECT * FROM player_vehicles WHERE citizenid = @citizenid", {['@citizenid'] = xPlayer.PlayerData.citizenid}, function(vehData)
				-- loop through vehicles again and delete:
				for k,v in pairs(vehData) do
					if v.repaytime < 1 and v.finance > 1 then
						local vehPlate = v.plate
						local vehModel = v.vehicle
                        QBCore.Functions.ExecuteSql(true, "DELETE FROM `player_vehicles` WHERE `plate` = '"..vehPlate.."' AND `vehicle` = '"..vehModel.."'")
                        QBCore.Functions.ExecuteSql(true, "DELETE FROM `trunkitemsnew` WHERE `plate` = '"..vehPlate.."'")
                        QBCore.Functions.ExecuteSql(true, "DELETE FROM `gloveboxitemsnew` WHERE `plate` = '"..vehPlate.."'")
                        TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "SBI: We Have Taken Your Vehicle", "error", 7000) 
					end
				end
            end)
        end
	end)
end)


--------Finance Repayments---------


QBCore.Functions.CreateCallback('lund:GetOwnedVehByPlate',function(source, cb, plate)	
	local xPlayer = QBCore.Functions.GetPlayer(source)
	local vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime = nil, 0, nil, 0, 0
	
	exports['ghmattimysql']:execute("SELECT * FROM player_vehicles WHERE citizenid = @citizenid", {['@citizenid'] = xPlayer.PlayerData.citizenid}, function(vehData) 
		local vehFound = false
		for k,v in pairs(vehData) do
			if plate == v.plate then
				vehHash 		= v.hash
				vehPrice 		= v.buy_price
				vehPlate 		= v.plate
				vehFinance 		= v.finance
				vehRepaytime 	= v.repaytime
				vehFound 		= true
			end
		end
		
		if not vehFound then
            TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, "You don't own a vehicle with that plate", "error", 7000) 
		end
		
		if vehFound then
			cb(vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime)
		end
	end)
	
end)


QBCore.Functions.CreateCallback('lund:RepayAmount', function(source, cb, plate, amount)
	local xPlayer = QBCore.Functions.GetPlayer(source)

	local paid
	
	if xPlayer.PlayerData.money["bank"] >= amount then
        xPlayer.Functions.RemoveMoney('bank', amount) 
		paid = true
	else
		paid = false
	end
	local setTime
	if paid then 
        exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE plate = @plate', {['@plate'] = plate}, function(curVeh)
            if curVeh[1] ~= nil then
                local financeAmount = curVeh[1].finance
                if financeAmount - amount <= 0 or financeAmount - amount <= 0.0 then
                    setTime = 0
                --else
                --	setTime = (1 * 60) --Hours
                end
                if financeAmount < amount then
                    QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `finance`='0' WHERE `plate`='"..plate.."'")
                    QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `repaytime`='0' WHERE `plate`='"..plate.."'")
                else
                    QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `finance`='"..(financeAmount - amount).."' WHERE `plate`='"..plate.."'")
                  --  QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `repaytime`='"..setTime.."' WHERE `plate`='"..plate.."'")
                end
            end
        end)
	end
	cb(paid)
end)








-- Open Registration Paper

RegisterServerEvent('lund:openRC')
AddEventHandler('lund:openRC', function(player, target, plate)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(player)
    local tPlayer    = QBCore.Functions.GetPlayer(target).source
    local vehFound   = false

   -- MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM players WHERE citizenid = @citizenid', {['@citizenid'] = xPlayer.PlayerData.citizenid}, function (user)
        local regPlate = nil
        local regDate
        local regFinance = 0
        local regModel = 0
       -- if (user[1] ~= nil) then
            exports['ghmattimysql']:execute("SELECT * FROM player_vehicles WHERE citizenid = @citizenid", {['@citizenid'] = xPlayer.PlayerData.citizenid}, function(vehData)
                for k,v in pairs(vehData) do
                    if plate == v.plate then
                        regPlate = v.plate
                        regDate = v.date
                        regFinance = v.finance
                        regModel = v.vehicle
                        vehFound = true
                    end
                end
                if vehFound then
                    local label
                    if regFinance > 0 then
                        label = 'Financed'
                    else
                        label = 'Cash'
                    end
                    local info = {
                       -- user = user,
                        regPlate = regPlate,
                        regDate = regDate,
                        regPayment = label,
                        regModel = regModel,
                    }
                    TriggerClientEvent('lund:openRegCL', target, info, regPlate)
                else
                    TriggerClientEvent("QBCore:Notify", src, "You dont own this vehicle", "error", 6000)
                end
            end)
       -- end
    --end)
end)





-------------Transfer Vehicle-------------


RegisterServerEvent('lund:GiveRC')
AddEventHandler('lund:GiveRC', function(player, target, plate)
    local src = source
	local xPlayer = QBCore.Functions.GetPlayer(player)
	local tPlayer = QBCore.Functions.GetPlayer(target)

    local date = os.date('%Y-%m-%d')
    
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."' AND `citizenid` = '"..xPlayer.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil and next(result[1]) ~= nil then
            if plate == result[1].plate then
                if result[1].repaytime == 0 and result[1].finance == 0 then
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `player_vehicles` WHERE `plate` = '"..plate.."' AND `vehicle` = '"..result[1].vehicle.."'")
                    QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `buy_price`, `finance`, `repaytime`, `date`, `state`) VALUES ('"..tPlayer.PlayerData.steam.."', '"..tPlayer.PlayerData.citizenid.."', '"..result[1].vehicle.."', '"..GetHashKey(result[1].vehicle).."', '"..json.encode(result[1].mods).."', '"..result[1].plate.."', '"..result[1].buy_price.."', '"..result[1].finance.."', '"..result[1].repaytime.."', '"..date.."', '0')")

                    TriggerClientEvent("QBCore:Notify", player, "You gave registration paper to "..tPlayer.PlayerData.charinfo.firstname.." "..tPlayer.PlayerData.charinfo.lastname, "error", 8000)
                    TriggerClientEvent("QBCore:Notify", target, "You received registration paper from "..xPlayer.PlayerData.charinfo.firstname.." "..xPlayer.PlayerData.charinfo.lastname, "success", 8000)     
                else
                    TriggerClientEvent("QBCore:Notify", src, "SBI: This vehicle has remaining financial payments", "error", 8000)
                end 
            else
                TriggerClientEvent("QBCore:Notify", src, "You dont't own this vehicle", "error", 5000)
            end
        end
    end)
end)


