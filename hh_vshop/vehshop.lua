QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


PlayerJob = {}
onDuty = false
print("HH Framework ")
print("Join @ discord.gg/b94NvSyqjR ")

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
	PlayerJob = PlayerData.job
	onDuty = PlayerData.job.onduty
	Citizen.Wait(2000)
	TriggerServerEvent("lund:CheckFinanceStatus")
end)


RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)


RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)


RegisterNetEvent('FinishMoneyCheckForVeh')
RegisterNetEvent('vehshop:spawnVehicle')
local vehshop_blips = {}
local financedPlates = {}
local buyPlate = {}
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false
local vehicle_price = 0
local backlock = false
local firstspawn = 0
local commissionbuy = 0

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
local currentCarSpawnLocation = 0
local ownerMenu = false

local vehshopDefault = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
				{name = "Cycles", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {
				{name = "Job Vehicles", description = ''},
			}
		},
		["jobvehicles"] = {
			title = "job vehicles",
			name = "job vehicles",
			buttons = {
				{name = "Taxi Cab", costs = 5000, description = {}, model = "taxi"},
				{name = "News Rumpo", costs = 8000, description = {}, model = "rumpo"},
				{name = "Taco Van", costs = 15000, description = {}, model = "taco"},
			}
		},
		["cycles"] = {
			title = "cycles",
			name = "cycles",
			buttons = {
				{name = "BMX", costs = 550, description = {}, model = "bmx"},
				{name = "Cruiser", costs = 500, description = {}, model = "cruiser"},
				{name = "Fixter", costs = 650, description = {}, model = "fixter"},
				{name = "Scorcher", costs = 1000, description = {}, model = "scorcher"},
				{name = "Pro 1", costs = 2500, description = {}, model = "tribike"},
				{name = "Pro 2", costs = 2600, description = {}, model = "tribike2"},
				{name = "Pro 3", costs = 2900, description = {}, model = "tribike3"},
			}
		},		
	}
}

vehshop = vehshopDefault
local vehshopOwner = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
				{name = "Motorcycles", description = ""},
				{name = "Cycles", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {
				{name = "Job Vehicles", description = ''},
				{name = "Compacts", description = ''},
				{name = "Coupes", description = ''},
				{name = "Sedans", description = ''},
				{name = "Sports", description = ''},
				{name = "Sports Classics", description = ''},
				{name = "Super", description = ''},
				{name = "Muscle", description = ''},
				{name = "Off-Road", description = ''},
				{name = "SUVs", description = ''},
				{name = "Vans", description = ''},
			}
		},
		["jobvehicles"] = {
			title = "job vehicles",
			name = "job vehicles",
			buttons = {
				{name = "Taxi Cab", costs = 5000, description = {}, model = "taxi"},
				{name = "News Rumpo", costs = 8000, description = {}, model = "rumpo"},
				{name = "Taco Van", costs = 15000, description = {}, model = "taco"},
			}
		},
		["compacts"] = {
			title = "compacts",
			name = "compacts",
			buttons = {			
				{name = "Blista", costs = 28500, description = {}, model = "blista"},
				{name = "Blista Compact", costs = 36000, description = {}, model = "blista2"},
				{name = "Brioso R/A", costs = 35000, description = {}, model = "brioso"},
				{name = "Rhapsody", costs = 25000, description = {}, model = "rhapsody"},
				{name = "Dilettante", costs = 30000, description = {}, model = "dilettante"},
				{name = "Issi", costs = 15000, description = {}, model = "issi2"},
				{name = "Issi Classic", costs = 35000, description = {}, model = "issi3"},
				{name = "Prairie", costs = 36000, description = {}, model = "prairie"},
				{name = "Panto", costs = 40000, description = {}, model = "panto"},
			}
		},
		["coupes"] = {
			title = "coupes",
			name = "coupes",
			buttons = {
				{name = "Cognoscenti Cabrio", costs = 85000, description = {}, model = "cogcabrio"},
				{name = "Exemplar", costs = 45000, description = {}, model = "exemplar"},
				{name = "Futo", costs = 35000, description = {}, model = "futo"},
				{name = "F620", costs = 70000, description = {}, model = "f620"},
				{name = "Felon", costs = 60000, description = {}, model = "felon"},
				{name = "Felon GT", costs = 75000, description = {}, model = "felon2"},
				{name = "Jackal", costs = 55000, description = {}, model = "jackal"},
				{name = "Oracle", costs = 60000, description = {}, model = "oracle"},
				{name = "Oracle XS", costs = 72000, description = {}, model = "oracle2"},
				{name = "Sentinel", costs = 53000, description = {}, model = "sentinel"},
				{name = "Sentinel XS", costs = 61000, description = {}, model = "sentinel2"},
				{name = "Windsor", costs = 165000, description = {}, model = "windsor"},
				{name = "Windsor Drop", costs = 179000, description = {}, model = "windsor2"},
				{name = "Zion", costs = 85000, description = {}, model = "zion"},
				{name = "Zion Cabrio", costs = 94000, description = {}, model = "zion2"},
			}
		},
		["sports"] = {
			title = "sports",
			name = "sports",
			buttons = {
				{name = "9F", costs = 90000, description = {}, model = "ninef"},
				{name = "9F Cabrio", costs = 97000, description = {}, model = "ninef2"},
				{name = "Alpha", costs = 90000, description = {}, model = "alpha"},
				{name = "Banshee", costs = 85000, description = {}, model = "banshee"},
				{name = "Banshee 900R", costs = 100000, description = {}, model = "banshee2"},
				{name = "Bestia GTS", costs = 95000, description = {}, model = "bestiagts"},
				{name = "Buffalo", costs = 100000, description = {}, model = "buffalo"},
				{name = "Buffalo S", costs = 150000, description = {}, model = "buffalo2"},
				{name = "Carbonizzare", costs = 175000, description = {}, model = "carbonizzare"},
				{name = "Comet", costs = 200000, description = {}, model = "comet2"},
				{name = "Comet Retro Custom", costs = 240000, description = {}, model = "comet3"},
				{name = "Comet SR", costs = 280000, description = {}, model = "comet5"},
				{name = "Coquette", costs = 177000, description = {}, model = "coquette"},
				{name = "Feltzer", costs = 75000, description = {}, model = "feltzer2"},
				{name = "Furore GT", costs = 90000, description = {}, model = "furoregt"},
				{name = "Fusilade", costs = 55000, description = {}, model = "fusilade"},
				{name = "Jester", costs = 120000, description = {}, model = "jester"},
				{name = "Kuruma", costs = 110000, description = {}, model = "kuruma"},
				{name = "Lynx", costs = 97000, description = {}, model = "lynx"},
				{name = "Massacro", costs = 85000, description = {}, model = "massacro"},
				{name = "Omnis", costs = 99000, description = {}, model = "omnis"},
				{name = "Penumbra", costs = 86000, description = {}, model = "penumbra"},
				{name = "Rapid GT", costs = 85000, description = {}, model = "rapidgt"},
				{name = "Rapid GT Convertible", costs = 90000, description = {}, model = "rapidgt2"},
				{name = "Schafter V12", costs = 65000, description = {}, model = "schafter3"},
				{name = "Sultan", costs = 75000, description = {}, model = "sultan"},
				{name = "Sultan RS", costs = 95000, description = {}, model = "sultanrs"},
				{name = "Surano", costs = 92000, description = {}, model = "surano"},
				{name = "Verkierer", costs = 95000, description = {}, model = "verlierer2"},
				{name = "Streiter", costs = 93000, description = {}, model = "streiter"},
				{name = "Pariah", costs = 155000, description = {}, model = "pariah"},
				{name = "Neon", costs = 245000, description = {}, model = "neon"},
				{name = "Elegy", costs = 78000, description = {}, model = "elegy2"},
				{name = "Schlagen", costs = 180000, description = {}, model = "schlagen"},
			}
		},
		["sportsclassics"] = {
			title = "sports classics",
			name = "sportsclassics",
			buttons = {
				{name = "Casco", costs = 97000, description = {}, model = "casco"},
				{name = "Coquette Classic", costs = 90000, description = {}, model = "coquette2"},
				{name = "Pigalle", costs = 59000, description = {}, model = "pigalle"},
				{name = "Stinger", costs = 85000, description = {}, model = "stinger"},
				{name = "Stinger GT", costs = 100000, description = {}, model = "stingergt"},
				{name = "Stirling GT", costs = 120000, description = {}, model = "feltzer3"},
				{name = "Rapid GT Classic", costs = 88500, description = {}, model = "rapidgt3"},
				{name = "Retinue", costs = 85000, description = {}, model = "retinue"},
				{name = "Viseris", costs = 140000, description = {}, model = "viseris"}, 
				{name = "190z", costs = 170000, description = {}, model = "z190"},
				{name = "GT500", costs = 97000, description = {}, model = "gt500"},
				{name = "Elegy Retro Custom", costs = 70000, description = {}, model = "elegy"},
			}
		},
		["super"] = {
			title = "Super",
			name = "super",
			buttons = {
				{name = "Adder", costs = 320000, description = {}, model = "adder"},
				{name = "Bullet", costs = 300000, description = {}, model = "bullet"},
				{name = "Cheetah", costs = 340000, description = {}, model = "cheetah"},
				{name = "Cheetah Classic", costs = 250000, description = {}, model = "cheetah2"},
				{name = "Entity XF", costs = 335000, description = {}, model = "entityxf"},
				{name = "FMJ", costs = 340000, description = {}, model = "fmj"},
				{name = "Infernus", costs = 250000, description = {}, model = "infernus"},
				{name = "Pfister 811", costs = 380000, description = {}, model = "pfister811"},
				{name = "Reaper", costs = 250000, description = {}, model = "reaper"}, 
				{name = "T20", costs = 300000, description = {}, model = "t20"},
				{name = "Turismo R", costs = 310000, description = {}, model = "turismor"},
				{name = "Vacca", costs = 220000, description = {}, model = "vacca"},
				{name = "Voltic", costs = 240000, description = {}, model = "voltic"},
				{name = "X80 Proto", costs = 450000, description = {}, model = "prototipo"},
				{name = "Zentorno", costs = 300000, description = {}, model = "zentorno"},
				{name = "Cyclone", costs = 300000, description = {}, model = "cyclone"},
				{name = "SC1", costs = 360000, description = {}, model = "sc1"},
				{name = "Autarch", costs = 356000, description = {}, model = "autarch"},
				{name = "GP1", costs = 340000, description = {}, model = "gp1"},
				{name = "Tempesta", costs = 320000, description = {}, model = "tempesta"},
				{name = "Vagner", costs = 280000, description = {}, model = "vagner"},
				{name = "Itali GTB", costs = 260000, description = {}, model = "italigtb"},
				{name = "XA-21", costs = 310000, description = {}, model = "xa21"},
				{name = "Tezeract", costs = 350000, description = {}, model = "tezeract"},
				{name = "Entity XXR", costs = 375000, description = {}, model = "entity2"},
				{name = "Nero", costs = 380000, description = {}, model = "nero"},
				{name = "Taipan", costs = 370000, description = {}, model = "taipan"},
				{name = "Tyrant", costs = 378000, description = {}, model = "tyrant"},
				{name = "Osiris", costs = 260000, description = {}, model = "osiris"},
				{name = "Emerus", costs = 320000, description = {}, model = "emerus"},
				{name = "Krieger", costs = 375000, description = {}, model = "krieger"},
			--	{name = "Thrax", costs = 340000, description = {}, model = "thrax"},
				{name = "Zorrusso", costs = 300000, description = {}, model = "zorrusso"},
			}
		},
		["muscle"] = {
			title = "muscle",
			name = "muscle",
			buttons = {
				{name = "Blade", costs = 85000, description = {}, model = "blade"},
				{name = "Buccaneer", costs = 34000, description = {}, model = "buccaneer"},
				{name = "Chino", costs = 68000, description = {}, model = "chino"},
				{name = "Coquette BlackFin", costs = 120000, description = {}, model = "coquette3"},
				{name = "Dominator", costs = 90000, description = {}, model = "dominator"},
				{name = "Dukes", costs = 30000, description = {}, model = "dukes"},
				{name = "Gauntlet", costs = 50000, description = {}, model = "gauntlet"},
				{name = "Faction", costs = 60000, description = {}, model = "faction"},
				{name = "Faction Rider", costs = 88000, description = {}, model = "faction2"},
				{name = "Picador", costs = 38000, description = {}, model = "picador"},
				{name = "Sabre Turbo", costs = 44000, description = {}, model = "sabregt"},
				{name = "Tampa", costs = 29000, description = {}, model = "tampa"},
				{name = "Drift Tampa", costs = 77000, description = {}, model = "tampa2"},
				{name = "Virgo", costs = 75000, description = {}, model = "virgo"},
				{name = "Vigero", costs = 64000, description = {}, model = "vigero"},
				{name = "Phoenix", costs = 40000, description = {}, model = "phoenix"},
				{name = "Slam Van", costs = 60000, description = {}, model = "slamvan"},
				{name = "Dominator GTX", costs = 175000, description = {}, model = "dominator3"},
				{name = "Yosemite", costs = 61000, description = {}, model = "yosemite"},  
				{name = "Hustler", costs = 110000, description = {}, model = "hustler"},  
			}
		},
		["offroad"] = {
			title = "off-road",
			name = "off-road",
			buttons = {
				{name = "Bifta", costs = 42000, description = {}, model = "bifta"},
				{name = "Blazer", costs = 16500, description = {}, model = "blazer"},
				{name = "Brawler", costs = 98000, description = {}, model = "brawler"},
				{name = "Rebel", costs = 65000, description = {}, model = "rebel2"},
				{name = "Hellion", costs = 75000, description = {}, model = "hellion"},
				{name = "Kamacho", costs = 180000, description = {}, model = "kamacho"},
				{name = "Dubsta 6x6", costs = 275000, description = {}, model = "dubsta3"},
				{name = "Freecrawler", costs = 105000, description = {}, model = "freecrawler"},
				{name = "Riata", costs = 80000, description = {}, model = "riata"},
			}
		},
		["suvs"] = {
			title = "suvs",
			name = "suvs",
			buttons = {
				{name = "Cavalcade", costs = 70000, description = {}, model = "cavalcade2"},
				{name = "Granger", costs = 95000, description = {}, model = "granger"},
				{name = "Huntley S", costs = 65000, description = {}, model = "huntley"},
				{name = "Landstalker", costs = 85000, description = {}, model = "landstalker"},
				{name = "Radius", costs = 20000, description = {}, model = "radi"},
				{name = "Rocoto", costs = 64000, description = {}, model = "rocoto"},
				{name = "Seminole", costs = 52000, description = {}, model = "seminole"},
				{name = "XLS", costs = 71000, description = {}, model = "xls"},
				{name = "Dubsta Luxuary", costs = 77000, description = {}, model = "dubsta2"},
				{name = "Patriot", costs = 97000, description = {}, model = "patriot"},
				{name = "Gresley", costs = 90000, description = {}, model = "gresley"},
				{name = "Toros", costs = 110000, description = {}, model = "toros"},
				{name = "Habanero", costs = 850000, description = {}, model = "habanero"},
			}
		},
		["vans"] = {
			title = "vans",
			name = "vans",
			buttons = {
				{name = "Bison", costs = 55000, description = {}, model = "bison"},
				{name = "Bobcat XL", costs = 62000, description = {}, model = "bobcatxl"},
				{name = "Gang Burrito", costs = 85000, description = {}, model = "gburrito"},
				{name = "Gang Burrito Custom", costs = 90000, description = {}, model = "gburrito2"},
				{name = "Burrito", costs = 50000, description = {}, model = "burrito3"},
				{name = "Moonbeam", costs = 35000, description = {}, model = "moonbeam"},
				{name = "Moonbeam Custom", costs = 85000, description = {}, model = "moonbeam2"},
			}
		},
		["sedans"] = {
			title = "sedans",
			name = "sedans",
			buttons = {
				{name = "Emperor", costs = 14000, description = {}, model = "emperor"},
				{name = "Asea", costs = 34000, description = {}, model = "asea"},
				{name = "Glendale", costs = 11500, description = {}, model = "glendale"},
				{name = "Intruder", costs = 9500, description = {}, model = "intruder"},
				{name = "Premier", costs = 26000, description = {}, model = "premier"},
				{name = "Regina", costs = 12000, description = {}, model = "regina"},
				{name = "Schafter", costs = 30000, description = {}, model = "schafter2"},
				{name = "Super Diamond", costs = 65000, description = {}, model = "superd"},
				{name = "Washington", costs = 40000, description = {}, model = "washington"},
				{name = "Tailgater", costs = 50000, description = {}, model = "tailgater"},
				{name = "Cognoscenti", costs = 85000, description = {}, model = "cognoscenti"},
			}
		},
		["motorcycles"] = {
			title = "MOTORCYCLES",
			name = "motorcycles",
			buttons = {		
				{name = "Akuma", costs = 10500, description = {}, model = "AKUMA"},
				{name = "Bagger", costs = 14500, description = {}, model = "bagger"},
				{name = "Bati 801", costs = 25000, description = {}, model = "bati"},
				{name = "Carbon RS", costs = 33000, description = {}, model = "carbonrs"},
				{name = "Daemon", costs = 38000, description = {}, model = "daemon"},
				{name = "Hakuchou", costs = 50000, description = {}, model = "hakuchou"},
				{name = "Hakuchou Sport", costs = 75000, description = {}, model = "hakuchou2"},
				{name = "Faggio", costs = 4000, description = {}, model = "faggio"},
				{name = "Hexer", costs = 45000, description = {}, model = "hexer"},
				{name = "Nemesis", costs = 10000, description = {}, model = "nemesis"},
				{name = "PCJ-600", costs = 7200, description = {}, model = "pcj"},
				{name = "Ruffian", costs = 16800, description = {}, model = "ruffian"},
				{name = "Gargoyle", costs = 40000, description = {}, model = "gargoyle"},
				{name = "Faggio Mod", costs = 8200, description = {}, model = "faggio3"},
				{name = "Avarus", costs = 28000, description = {}, model = "avarus"},
				{name = "Esskey", costs = 19200, description = {}, model = "esskey"},
				{name = "Defiler", costs = 50000, description = {}, model = "defiler"},
				{name = "Chimera", costs = 63000, description = {}, model = "chimera"},
				{name = "Daemon", costs = 36000, description = {}, model = "daemon"},
				{name = "Sanchez", costs = 13000, description = {}, model = "sanchez2"},
				{name = "Sanctus", costs = 35000, description = {}, model = "sanctus"}, 
				{name = "Sovereign", costs = 95000, description = {}, model = "sovereign"}, 
			}
		},
		["cycles"] = {
			title = "cycles",
			name = "cycles",
			buttons = {
				{name = "BMX", costs = 550, description = {}, model = "bmx"},
				{name = "Cruiser", costs = 500, description = {}, model = "cruiser"},
				{name = "Fixter", costs = 650, description = {}, model = "fixter"},
				{name = "Scorcher", costs = 1000, description = {}, model = "scorcher"},
				{name = "Pro 1", costs = 2500, description = {}, model = "tribike"},
				{name = "Pro 2", costs = 2600, description = {}, model = "tribike2"},
				{name = "Pro 3", costs = 2900, description = {}, model = "tribike3"},
			}
		},
	}
}




local fakecar = {model = '', car = nil}
local vehshop_locations = {
	{
		entering = {-33.737,-1102.322,26.422},
		inside = {-61.166320800781,-1107.8854980469,26.43579864502,76.141090393066},
		outside = {-61.166320800781,-1107.8854980469,26.43579864502,76.141090393066},
	}
}

local carspawns = {
	[1] =  { ['x'] = -38.25,['y'] = -1104.18,['z'] = 26.43,['h'] = 14.46, ['info'] = ' Car Spot 1' },
	[2] =  { ['x'] = -36.36,['y'] = -1097.3,['z'] = 26.43,['h'] = 109.4, ['info'] = ' Car Spot 2' },
	[3] =  { ['x'] = -43.11,['y'] = -1095.02,['z'] = 26.43,['h'] = 67.77, ['info'] = ' Car Spot 3' },
	[4] =  { ['x'] = -50.45,['y'] = -1092.66,['z'] = 26.43,['h'] = 116.33, ['info'] = ' Car Spot 4' },
	[5] =  { ['x'] = -56.24,['y'] = -1094.33,['z'] = 26.43,['h'] = 157.08, ['info'] = ' Car Spot 5' },
	[6] =  { ['x'] = -49.73,['y'] = -1098.63,['z'] = 26.43,['h'] = 240.99, ['info'] = ' Car Spot 6' },
	[7] =  { ['x'] = -45.58,['y'] = -1101.4,['z'] = 26.43,['h'] = 287.3, ['info'] = ' Car Spot 7' },
}

local carTable = {
	[1] = { ["model"] = "Krieger", ["baseprice"] = 375000, ["commission"] = 20 }, 
	[2] = { ["model"] = "issi3", ["baseprice"] = 35000, ["commission"] = 20 },
	[3] = { ["model"] = "sanctus", ["baseprice"] = 35000, ["commission"] = 20 },
	[4] = { ["model"] = "kuruma", ["baseprice"] = 110000, ["commission"] = 20 },
	[5] = { ["model"] = "feltzer3", ["baseprice"] = 120000, ["commission"] = 20 },
	[6] = { ["model"] = "taipan", ["baseprice"] = 378000, ["commission"] = 20 },
	[7] = { ["model"] = "gburrito", ["baseprice"] = 85000, ["commission"] = 20 },
}

function updateCarTable(model,price,name)
	carTable[currentCarSpawnLocation]["model"] = model
	carTable[currentCarSpawnLocation]["baseprice"] = price
	carTable[currentCarSpawnLocation]["name"] = name
	TriggerServerEvent("carshop:table",carTable)
end

local myspawnedvehs = {}

RegisterNetEvent("car:testdrive")
AddEventHandler("car:testdrive", function()

	local pData = QBCore.Functions.GetPlayerData()
	if pData.job.name ~= 'cardealer' or #(vector3(-51.51, -1077.96, 26.92) - GetEntityCoords(PlayerPedId())) > 30.0 then
		return
	end

	local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
	if not DoesEntityExist(veh) then
		--exports['hh_notification']:SendAlert('error', 'Could not locate vehicle!')
		return
	end

	local model = GetEntityModel(veh)
	local veh = GetClosestVehicle(-51.51, -1077.96, 26.92, 3.000, 0, 70)

	if not DoesEntityExist(veh) then

		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model,-51.51, -1077.96, 26.92,80.0,true,false)
		local vehplate = "TEST"
		SetVehicleNumberPlateText(veh, vehplate)
		local plate = GetVehicleNumberPlateText(veh, vehplate)
		Citizen.Wait(100)
		TriggerServerEvent('garage:addKeys', plate)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)

		TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
		myspawnedvehs[veh] = true
	else
		QBCore.Functions.Notify("A car is already on the spawn point", "error")
	end
end)

RegisterNetEvent("finance")
AddEventHandler("finance", function()
	if #(vector3(-51.51, -1077.96, 26.92) - GetEntityCoords(PlayerPedId())) > 50.0 then
		return
	end

	local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
	if not DoesEntityExist(veh) then
	--	exports['hh_notification']:SendAlert('error', 'Could not locate vehicle!')
		return
	end
	local vehplate = GetVehicleNumberPlateText(veh)
	TriggerServerEvent("finance:enable",vehplate)
end)

RegisterNetEvent("buyEnable")
AddEventHandler("buyEnable", function()
	local pData = QBCore.Functions.GetPlayerData()
	if #(vector3(-51.51, -1077.96, 26.92) - GetEntityCoords(PlayerPedId())) > 50.0 and pData.job.name == 'cardealer' then
		return
	end

	local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
	if not DoesEntityExist(veh) then
	--	exports['hh_notification']:SendAlert('error', 'Could not locate vehicle!')
		return
	end
	local vehplate = GetVehicleNumberPlateText(veh)
	TriggerServerEvent("buy:enable",vehplate)
end)

RegisterNetEvent("finance:enableOnClient")
AddEventHandler("finance:enableOnClient", function(addplate)
	financedPlates[addplate] = true
	Citizen.Wait(60000)
	financedPlates[addplate] = nil
end)

RegisterNetEvent("buy:enableOnClient")
AddEventHandler("buy:enableOnClient", function(addplate)
	buyPlate[addplate] = true
	Citizen.Wait(60000)
	buyPlate[addplate] = nil
end)

RegisterNetEvent("commission")
AddEventHandler("commission", function(newAmount)
	local pData = QBCore.Functions.GetPlayerData()
	if pData.job.name ~= 'cardealer' or #(vector3(-51.51, -1077.96, 26.92) - GetEntityCoords(PlayerPedId())) > 50.0 then
		return
	end

	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			carTable[i]["commission"] = tonumber(newAmount)
			TriggerServerEvent("carshop:table",carTable)

		end
	end
end)

RegisterNetEvent("veh_shop:returnTable")
AddEventHandler("veh_shop:returnTable", function(newTable)
	carTable = newTable
	DespawnSaleVehicles()
	SpawnSaleVehicles()
end)

local hasspawned = false
local spawnedvehicles = {}
local vehicles_spawned = false

function BuyMenu()
	for i = 1, #carspawns do

		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			local veh = GetClosestVehicle(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], 3.000, 0, 70)
			local addplate = GetVehicleNumberPlateText(veh)
			if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= nil and GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then
				ClearPedTasksImmediately(PlayerPedId())
			end
			DisableControlAction(0,23)
			if IsControlJustReleased(0,47) and buyPlate[addplate] ~= nil then
			--	exports['hh_notification']:SendAlert('inform', 'Attempting Purchase')

				AttemptBuy(i,false)
			end

			if IsControlJustReleased(0,23) or IsDisabledControlJustReleased(0,23) then
				if financedPlates[addplate] ~= nil then
				--	exports['hh_notification']:SendAlert('inform', 'Attempting Purchase')
					AttemptBuy(i,true)
				end
			end
		end
	end
end

function AttemptBuy(tableid,financed)

	local veh = GetClosestVehicle(carspawns[tableid]["x"],carspawns[tableid]["y"],carspawns[tableid]["z"], 3.000, 0, 70)
	if not DoesEntityExist(veh) then
	--	exports['hh_notification']:SendAlert('error', 'Could not locate vehicle!')
		return
	end

	if financed then
		print("Financed on client side (#Haters Be Like Ye Kse Ho gya xD)")
	end

	local model = carTable[tableid]["model"]
	local commission = carTable[tableid]["commission"]
	local baseprice = carTable[tableid]["baseprice"]
	local name = carTable[tableid]["name"]
	local price = baseprice + (baseprice * commission/ 100)


	local vehProps = QBCore.Functions.GetVehicleProperties(veh)
	local hash = vehProps.model
	if QBCore.Shared.VehicleModels[hash] ~= nil and next(QBCore.Shared.VehicleModels[hash]) ~= nil then
		currentlocation = vehshop_blips[1]
		TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
		TriggerServerEvent('CheckMoneyForVeh',name, model, price, financed)
		commissionbuy = (baseprice * commission / 200)
	else
		QBCore.Functions.Notify('You cant buy this vehicle', 'error')
	end
--	TriggerServerEvent('CheckMoneyForVeh',name, model, price, financed)
end

function OwnerMenu()
	if not vehshop.opened then
		currentCarSpawnLocation = 0
		ownerMenu = false
	end
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			ownerMenu = true
			currentCarSpawnLocation = i
			if IsControlJustReleased(0,38) then
				--exports['hh_notification']:SendAlert('inform', 'We Opened')
				if vehshop.opened then
					CloseCreator()
				else
					OpenCreator()
				end
			end
		end
	end
end

function DrawPrices()
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.5 then
			local commission = carTable[i]["commission"]
			local baseprice = carTable[i]["baseprice"]
			local name = carTable[i]["model"]
			local price = baseprice + (baseprice * commission/100)
			local pData = QBCore.Functions.GetPlayerData()
			local veh = GetClosestVehicle(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], 3.000, 0, 70)
			local addplate = GetVehicleNumberPlateText(veh)
			if pData.job.name == 'cardealer' then
				if financedPlates[addplate] ~= nil and buyPlate[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Commission: %" ..commission.. " | [E] Change | [G] Buy | [F] Finance ")
				elseif financedPlates[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], "$" .. math.ceil(price/3) .. " DownPay, $" .. math.ceil(price) .. " | Commission: %" ..commission.. " | [E] Change | [F] Finance ")
				elseif buyPlate[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Commission: %" ..commission.. " | [E] Change | [G] Buy ")
				else
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Commission: %" ..commission.. " | [E] Change")
				end
			else
				if financedPlates[addplate] ~= nil and buyPlate[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " [G] Buy | $" .. math.ceil(price/3) .. " DownPay, $" .. math.ceil(price) .. " over 1 week, [F] Finance. ")
				elseif financedPlates[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], "$" .. math.ceil(price/3) .. " DownPay, $" .. math.ceil(price) .. " over 1 week, [F] Finance. ")
				elseif buyPlate[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " [G] Buy. ")
				else
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"Buy Price: $" .. math.ceil(price) .. " ")
				end
			end
		end
	end
end

function DrawText3D(x,y,z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function SpawnSaleVehicles()
	if not hasspawned then
		TriggerServerEvent("carshop:requesttable")
--		print("requesting table")
		Citizen.Wait(1500)
	end
	DespawnSaleVehicles()
	hasspawned = true
	for i = 1, #carTable do
		local model = GetHashKey(carTable[i]["model"])
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		local veh = CreateVehicle(model,carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]-1,carspawns[i]["h"],false,false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)

		FreezeEntityPosition(veh,true)
		spawnedvehicles[#spawnedvehicles+1] = veh
		SetVehicleNumberPlateText(veh, "PDM ".. i)
	end
	vehicles_spawned = true
end

function DespawnSaleVehicles()
	for i = 1, #spawnedvehicles do
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(spawnedvehicles[i]))
	end
	vehicles_spawned = false
end

Controlkey = {["generalUse"] = {38,"E"},["generalUseSecondary"] = {191,"Enter"}}
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["generalUse"] = table["generalUse"]
	Controlkey["generalUseSecondary"] = table["generalUseSecondary"]
end)

--[[Functions]]--

function LocalPed()
	return PlayerPedId()
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function IsPlayerInRangeOfVehshop()
	return inrangeofvehshop
end

function ShowVehshopBlips(bool)
	if bool and #vehshop_blips == 0 then
		for station,pos in pairs(vehshop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			-- 60 58 137
			SetBlipSprite(blip,326)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Vehicle Shop')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			SetBlipScale(blip, 0.8)
			SetBlipColour(blip, 3)
			vehshop_blips[#vehshop_blips+1]= {blip = blip, pos = loc}
		end
		Citizen.CreateThread(function()
			while #vehshop_blips > 0 do
				Citizen.Wait(1)
				local inrange = false

				if #(vector3(-45.98,-1082.97, 26.27) - GetEntityCoords(LocalPed())) < 5.0 then
					local veh = GetVehiclePedIsUsing(LocalPed())
					if myspawnedvehs[veh] ~= nil then
						DrawText3D(-45.98,-1082.97, 26.27,"["..Controlkey["generalUse"][2].."] Return Test Vehicle")
						if IsControlJustReleased(0,Controlkey["generalUse"][1]) then
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
						end
					end
				end

				for i,b in ipairs(vehshop_blips) do
					if #(vector3(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]) - GetEntityCoords(LocalPed())) < 100 then
						currentlocation = b
						if not vehicles_spawned then
--							print("Spawning Display Vehicles?")
							SpawnSaleVehicles()
						end
						if #(vector3(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]) - GetEntityCoords(LocalPed())) < 25 then
							DrawPrices()
						end

						local pData = QBCore.Functions.GetPlayerData()
						if pData.job.name == 'cardealer' then
							OwnerMenu()
						end
						BuyMenu()
					else
						if vehicles_spawned then
--							print("Despawning Display ?")
							DespawnSaleVehicles()
						end
						Citizen.Wait(1000)
					end
				end
				inrangeofvehshop = inrange
			end
		end)
	elseif bool == false and #vehshop_blips > 0 then
		for i,b in ipairs(vehshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		vehshop_blips = {}
	end
end

function f(n)
	return n + 0.0001
end

function try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function OpenCreator()
	boughtcar = false
	if ownerMenu then
		vehshop = vehshopOwner
	else
		vehshop = vehshopDefault
	end

	local ped = LocalPed()
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])

	vehshop.currentmenu = "main"
	vehshop.opened = true
	vehshop.selectedbutton = 0
end

function CloseCreator(name, veh, price, financed)
	Citizen.CreateThread(function()
		local ped = LocalPed()
		local pPrice = price
		if not boughtcar then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
		else
			local name = name
			local vehicle = veh
			local price = price
			local veh = GetVehiclePedIsUsing(ped)
			local model = GetEntityModel(veh)
			local colors = table.pack(GetVehicleColours(veh))
			local extra_colors = table.pack(GetVehicleExtraColours(veh))

			local mods = {}
			for i = 0,24 do
				mods[i] = GetVehicleMod(veh,i)
			end
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
			local pos = currentlocation.pos.outside

			FreezeEntityPosition(ped,false)
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end
			personalvehicle = CreateVehicle(model,pos[1],pos[2],pos[3],pos[4],true,false)
			SetModelAsNoLongerNeeded(model)

			if name == "rumpo" then
				SetVehicleLivery(personalvehicle,0)
			end

			if name == "taxi" then
				SetVehicleExtra(personalvehicle, 8, 0)
				SetVehicleExtra(personalvehicle, 9, 0)
				SetVehicleExtra(personalvehicle, 5, 1)
			end

			for i,mod in pairs(mods) do
				SetVehicleModKit(personalvehicle,0)
				SetVehicleMod(personalvehicle,i,mod)
			end

			SetVehicleOnGroundProperly(personalvehicle)

			local plate = GetVehicleNumberPlateText(personalvehicle)
			TriggerServerEvent('garage:addKeys', plate)

			SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
			local id = NetworkGetNetworkIdFromEntity(personalvehicle)
			SetNetworkIdCanMigrate(id, true)
			Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
			SetVehicleColours(personalvehicle,colors[1],colors[2])
			SetVehicleExtraColours(personalvehicle,extra_colors[1],extra_colors[2])
			TaskWarpPedIntoVehicle(PlayerPedId(),personalvehicle,-1)
			SetEntityVisible(ped,true)
			local vehProps = QBCore.Functions.GetVehicleProperties(personalvehicle)
			local hash = vehProps.model
			if QBCore.Shared.VehicleModels[hash] ~= nil and next(QBCore.Shared.VehicleModels[hash]) ~= nil then
				TriggerServerEvent('lundlele:server:SaveCar', vehProps, QBCore.Shared.VehicleModels[hash], GetHashKey(personalvehicle), plate, pPrice, financed)
			else
				QBCore.Functions.Notify('You cant buy this vehicle', 'error')
			end
			DespawnSaleVehicles()
			SpawnSaleVehicles()
		end
		vehshop.opened = false
		vehshop.menu.from = 1
		vehshop.menu.to = 10
	end)
end


RegisterNetEvent("carshop:failedpurchase")
AddEventHandler("carshop:failedpurchase", function()
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	TaskLeaveVehicle(PlayerPedId(),veh,0)
end)


function drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,255,55,55,220)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,250)
	DrawText(0.255, 0.254)
end

function drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.2, 0.2)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(250,250,250, 255)
	end

	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 + 0.025, y - menu.height/3 + 0.0002)

	if selected then
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,0,255,255,255)
	else
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255,55,55,220)
	end
end

function drawMenuTitle(txt,x,y)
	local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)

	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,250)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function ButtonSelected(button)
	local ped = PlayerPedId()
	local this = vehshop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Vehicles" then
			OpenMenu('vehicles')
		elseif btn == "Motorcycles" then
			OpenMenu('motorcycles')
		elseif btn == "Cycles" then
			OpenMenu('cycles')
		end
	elseif this == "vehicles" then
		if btn == "Sports" then
			OpenMenu('sports')
		elseif btn == "Sedans" then
			OpenMenu('sedans')
		elseif btn == "Job Vehicles" then
			OpenMenu('jobvehicles')
		elseif btn == "Compacts" then
			OpenMenu('compacts')
		elseif btn == "Coupes" then
			OpenMenu('coupes')
		elseif btn == "Sports Classics" then
			OpenMenu("sportsclassics")
		elseif btn == "Super" then
			OpenMenu("super")
		elseif btn == "Muscle" then
			OpenMenu('muscle')
		elseif btn == "Off-Road" then
			OpenMenu('offroad')
		elseif btn == "SUVs" then
			OpenMenu('suvs')
		elseif btn == "Vans" then
			OpenMenu('vans')
		end
	elseif this == "jobvehicles" or this == "compacts" or this == "coupes" or this == "sedans" or this == "sports" or this == "sportsclassics" or this == "super" or this == "muscle" or this == "offroad" or this == "suvs" or this == "vans" or this == "industrial" or this == "cycles" or this == "motorcycles" then
		if ownerMenu then
			updateCarTable(button.model,button.costs,button.name)
		else
			TriggerServerEvent('CheckMoneyForVeh',button.name, button.model, button.costs)
		end
	end
end

function OpenMenu(menu)
	fakecar = {model = '', car = nil}
	vehshop.lastmenu = vehshop.currentmenu
	if menu == "vehicles" then
		vehshop.lastmenu = "main"
	elseif menu == "bikes"  then
		vehshop.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		vehshop.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		vehshop.lastmenu = "race_create_objects"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		CloseCreator()
	elseif vehshop.currentmenu == "jobvehicles" or vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super"  or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		OpenMenu(vehshop.lastmenu)
	else
		OpenMenu(vehshop.lastmenu)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1, Controlkey["generalUseSecondary"][1]) ) and IsPlayerInRangeOfVehshop() then
			if vehshop.opened then
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if vehshop.opened then

			local ped = LocalPed()
			local menu = vehshop.menu[vehshop.currentmenu]
			local y = vehshop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false
			local pData = QBCore.Functions.GetPlayerData()
			for i,button in pairs(menu.buttons) do
				--local br = button.rank ~= nil and button.rank or 0
				if pData.job.name == 'cardealer' and i >= vehshop.menu.from and i <= vehshop.menu.to then

					if i == vehshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,vehshop.menu.x,y,selected)

					if button.costs ~= nil then
						drawMenuRight("$"..button.costs,vehshop.menu.x,y,selected)
					end

					y = y + 0.04
					if vehshop.currentmenu == "jobvehicles" or vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
						if selected then
							if fakecar.model ~= button.model then
								if DoesEntityExist(fakecar.car) then
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
								end
								local pos = currentlocation.pos.inside
								local hash = GetHashKey(button.model)
								RequestModel(hash)
								while not HasModelLoaded(hash) do
									Citizen.Wait(0)


								end
								local veh = CreateVehicle(hash,pos[1],pos[2],pos[3],pos[4],false,false)
								SetModelAsNoLongerNeeded(hash)
								local timer = 9000
								while not DoesEntityExist(veh) and timer > 0 do
									timer = timer - 1
									Citizen.Wait(1)
								end
								TriggerEvent("vehsearch:disable",veh)

								FreezeEntityPosition(veh,true)
								SetEntityInvincible(veh,true)
								SetVehicleDoorsLocked(veh,4)
								--SetEntityCollision(veh,false,false)
								TaskWarpPedIntoVehicle(LocalPed(),veh,-1)
								for i = 0,24 do
									SetVehicleModKit(veh,0)
									RemoveVehicleMod(veh,i)
								end
								fakecar = { model = button.model, car = veh}
								local topspeed = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel') / 2)
								local handling = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock') * 2)
								local braking = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce') * 100)
								local accel = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce') * 100) 
								if button.model == "rumpo" then
									SetVehicleLivery(veh,2)
								end

								-- not sure why it doesnt refresh itself, but blocks need to be set to their maximum 20 40 60 80 100 before a new number is pushed.
								--for i = 1, 5 do
								-- 	scaleform = resetscaleform(topspeed,handling,braking,accel,"mp_car_stats_01",i)
							    --    x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
							    --    Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x-1,y+1.8,z+7.0, 0.0, 180.0, 90.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0)
								--end

								--scaleform = Initialize("mp_car_stats_01",fakecar.car,fakecar.model)
							end
						end
					end
					if selected and ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1, Controlkey["generalUseSecondary"][1])  ) then
						ButtonSelected(button)
					end
				end
			end

			if DoesEntityExist(fakecar.car) then
				if vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
					daz = 6.0
					if fakecar.model == "Chimera" then
						daz = 8.0
					end
					if fakecar.model == "bmx" then
						daz = 8.0
					end
					 x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, -1.5, daz))
		        	Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x,y,z, 0.0, 180.0, 100.0, 1.0, 1.0, 1.0, 7.0, 7.0, 7.0, 0)
				else
		       		x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, -1.5, 10.0))
		       		Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x,y,z, 0.0, 180.0, 100.0, 1.0, 1.0, 1.0, 10.0, 10.0, 10.0, 0)		
				end
				TaskWarpPedIntoVehicle(LocalPed(),fakecar.car,-1)
		    end

		end
		if vehshop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if vehshop.selectedbutton > 1 then
					vehshop.selectedbutton = vehshop.selectedbutton -1
					if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
						vehshop.menu.from = vehshop.menu.from -1
						vehshop.menu.to = vehshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if vehshop.selectedbutton < buttoncount then
					vehshop.selectedbutton = vehshop.selectedbutton +1
					if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
						vehshop.menu.to = vehshop.menu.to + 1
						vehshop.menu.from = vehshop.menu.from + 1
					end
				end
			end
		end

	end
end)

AddEventHandler('FinishMoneyCheckForVeh', function(name, vehicle, price,financed)
	local name = name
	local vehicle = vehicle
	local price = price
	boughtcar = true
	CloseCreator(name, vehicle, price,financed)
end)

ShowVehshopBlips(true)
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		--326 car blip 227 225
		ShowVehshopBlips(true)
		firstspawn = 1
	end
end)

AddEventHandler('vehshop:spawnVehicle', function(v)
	local car = GetHashKey(v)
	local playerPed = PlayerPedId()
	if playerPed and playerPed ~= -1 then
		RequestModel(car)
		while not HasModelLoaded(car) do
			Citizen.Wait(0)
		end
		local playerCoords = GetEntityCoords(playerPed)
		veh = CreateVehicle(car, playerCoords, 0.0, true, false)
		SetModelAsNoLongerNeeded(car)
		TaskWarpPedIntoVehicle(playerPed, veh, -1)
		SetEntityInvincible(veh, true)
	end
end)

local firstspawn = 0

AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		RemoveIpl('v_carshowroom')
		RemoveIpl('shutter_open')
		RemoveIpl('shutter_closed')
		RemoveIpl('shr_int')
		RemoveIpl('csr_inMission')
		RequestIpl('v_carshowroom')
		RequestIpl('shr_int')
		RequestIpl('shutter_closed')
		firstspawn = 1
	end
end)




-- REGISTRATION PAPER:
local open = false

RegisterNetEvent('lund:openRegCL')
AddEventHandler('lund:openRegCL', function(data, vehPlate)
	open = true
	SendNUIMessage({ 
		action = "open", 
		array  = data, 
		pData = QBCore.Functions.GetPlayerData(),
		plate = vehPlate 
	})
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)


--



-- Chat suggestions:

--[[TriggerEvent('chat:addSuggestion', '/finance', 'Check or Pay a repayment.', {
	{ name="option", help="Type: pay / check" },
	{ name="amount", help="if command pay, then add repayment amount as 2nd arugment, else leave it" }
})

TriggerEvent('chat:addSuggestion', '/rc', 'View or Show or Give Vehicle Registration Paper.', {
	{ name="option", help="choose between: view, show or give" },
})


TriggerEvent('chat:addSuggestion', '/commission', 'To Set commission on nearby vehicle .', {
	{ name="amount", help="Amount of Commissions" }
})

TriggerEvent('chat:addSuggestion', '/enablef', 'To Enable Finance on nearby vehicle')
TriggerEvent('chat:addSuggestion', '/enablebuy', 'To Enable Buy Option on nearby vehicle')
TriggerEvent('chat:addSuggestion', '/testdrive ', 'To take testdrive of nearby vehicles')--]]



Citizen.CreateThread(function ()
    while true do
		Citizen.Wait(1)
		if isLoggedIn and QBCore ~= nil then
			if PlayerJob.name == "cardealer" then
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -30.89, -1110.8, 26.42, true) < 1.0 then
					DrawText3D(-30.89, -1110.8, 26.42, '~y~[E]~w~ - Clothing')
					if (IsControlJustReleased(1, 51)) then
						Citizen.Wait(200)
						TriggerEvent('qb-clothing:client:openOutfitMenu')
					end
				elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -30.64, -1106.87, 26.42, true) < 1.5 then
					if not onDuty then
						DrawText3D(-30.64, -1106.87, 26.42, "~g~[E]~w~ - On Duty")
					else
						DrawText3D(-30.64, -1106.87, 26.42, "~r~[E]~w~ - Off Duty")
					end
					if (IsControlJustReleased(1, 51)) then
						RequestAnimDict("anim@narcotics@trash")
						while not HasAnimDictLoaded("anim@narcotics@trash") do
							Citizen.Wait(0)
						end
							print("HH Framework ")
							print("Join @ discord.gg/b94NvSyqjR ")
						TriggerServerEvent("QBCore:ToggleDuty")
						TaskPlayAnim(PlayerPedId(), "anim@narcotics@trash" , "drop_front" ,8.0, -8.0, -1, 1, 0, false, false, false )
						TriggerServerEvent("TokoVoip:removePlayerFromAllRadio",GetPlayerServerId(PlayerId()))
						Citizen.Wait(1500)
						ClearPedTasks(PlayerPedId())
					end
				end
			end
		else
			Citizen.Wait(1500)
		end
    end
end)





RegisterCommand('enablef', function(source, args, raw)
	local pData = QBCore.Functions.GetPlayerData()
	local job = pData.job.name
	if job == 'cardealer' and pData.job.onduty then
		TriggerEvent('finance')
	else
		QBCore.Functions.Notify("You dont have permissions for this!", "error")
	end
end)

RegisterCommand('commission', function(source, args, raw)
	local pData = QBCore.Functions.GetPlayerData()
	local job = pData.job.name
	if job == 'cardealer' and pData.job.onduty then
		local amount = tonumber(args[1])
		if amount >= 10 then
			TriggerEvent('commission', amount)
		else 
			QBCore.Functions.Notify("Invalid amount /commision [amount]", "error")
		end
	else
		QBCore.Functions.Notify("You dont have permissions for this!", "error")
	end
		
end)

RegisterCommand('testdrive', function(source, args, raw)
	local pData = QBCore.Functions.GetPlayerData()
	local job = pData.job.name
	if job == 'cardealer' and pData.job.onduty then
		TriggerEvent('car:testdrive')
	else
		QBCore.Functions.Notify("You dont have permissions for this!", "error")
	end
end)

RegisterCommand('enablebuy', function(source, args, raw)
	local pData = QBCore.Functions.GetPlayerData()
	local job = pData.job.name
	if job == 'cardealer' and pData.job.onduty then
		TriggerEvent('buyEnable')
			print("HH Framework ")
			print("Join @ discord.gg/b94NvSyqjR ")
	else
		QBCore.Functions.Notify("You dont have permissions for this!", "error")
	end
end)








-----------------Finance Commands-----------------

RegisterCommand('finance', function(source, args)
	local option = args[1]
	local ladka = GetPlayerPed(-1)
	local car = GetVehiclePedIsIn(ladka, false)
	local plate = GetVehicleNumberPlateText(car)
	local amount = tonumber(args[2])
	
	if option == "pay" then
		if plate ~= nil or not plate == '' then
			QBCore.Functions.TriggerCallback('qb-garage:server:checkVehicleOwner', function(bsdk)
				if bsdk then
					if amount ~= nil or not amount == '' and amount >= 0 then
						QBCore.Functions.TriggerCallback('lund:GetOwnedVehByPlate', function(vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime)
							local vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime = vehPlate, vehPrice, vehHash, vehFinance
							if vehFinance < 1 then
								QBCore.Functions.Notify("This vehicle is already completely paid", "primary")
							else
								local diffFP = (vehFinance / vehPrice)
								local repayMoney = ((vehPrice * diffFP) / 10)				
								local difference = 0
								if vehFinance > vehPrice then
									difference = (vehFinance - vehPrice) + repayMoney
								else
									difference = repayMoney
								end
								if amount < difference then 
									QBCore.Functions.Notify("Current repayment is at least: $"..math.floor(difference).."", "error")
									return 
								else
									QBCore.Functions.TriggerCallback('lund:RepayAmount', function(hasPaid) 
										if hasPaid then 
											QBCore.Functions.Notify("You paid $"..math.floor(amount).." to the financing", "success")
										else 
											QBCore.Functions.Notify("Not enough Money", "error")
										end
									end, vehPlate, amount)
								end
							end
						end, plate)
						
					else
						QBCore.Functions.Notify("Invalid Amount", "error")
					end
				else
					QBCore.Functions.Notify("You dont own this vehicle", "error")
				end
			end, plate)
		else
			QBCore.Functions.Notify("The plate is not valid...", "error")
		end
		print("HH Framework ")
		print("Join @ discord.gg/b94NvSyqjR ")
	elseif option == "check" then
		if plate ~= nil or not plate == '' then
			QBCore.Functions.TriggerCallback('qb-garage:server:checkVehicleOwner', function(bsdk)
				if bsdk then
					QBCore.Functions.TriggerCallback('lund:GetOwnedVehByPlate', function(vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime)
						local vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime = vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime
						
						if vehFinance < 1 then
							QBCore.Functions.Notify("This vehicle is already completely paid", "primary")
						else
							QBCore.Functions.Notify("Amount Owed: $"..vehFinance..". Pay Next Repayment Before: "..vehRepaytime.."Hours", "error")
						end
						
					end, plate)
				else
					QBCore.Functions.Notify("You dont own this vehicle", "error")
				end
			end, plate)
		else
			QBCore.Functions.Notify("The plate is not valid...", "error")
		end
	end	
end, false)


-----------------Transfer Vehicle Commands-----------------

RegisterCommand('rc', function(source, args)
	local option = args[1]
	local ladka = GetPlayerPed(-1)
	local car = GetVehiclePedIsIn(ladka, false)
	local plate = GetVehicleNumberPlateText(car)	
	-- View Registration Paper:	

	if option == "view" then
		TriggerServerEvent('lund:openRC', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), plate)
			
	-- Show Registration Paper:
	elseif option == "show" then
		local player, distance = GetClosestPlayer()
		if distance ~= -1 and distance <= 2.0 then
			TriggerServerEvent('lund:openRC', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), plate)
		else
			QBCore.Functions.Notify("Nobody Nearby", "error")
		end
	
		-- Give Registration Paper:
	elseif option == "give" then
		local player, distance = GetClosestPlayer()
		if distance ~= -1 and distance <= 2.0 then
			TriggerServerEvent('lund:GiveRC', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), plate)
		else
			QBCore.Functions.Notify("Person Not Nearby", "error")
		end		
	end
end, false)


function GetClosestPlayer()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))
	print("HH Framework ")
	print("Join @ discord.gg/b94NvSyqjR ")
    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end
