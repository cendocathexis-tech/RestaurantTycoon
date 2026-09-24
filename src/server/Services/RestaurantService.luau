local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Config = require(ReplicatedStorage.Shared.Config)
local DataService = require(script.Parent.DataService)

local RestaurantService = {}
local restaurants = {}

local function ensureRemote(name)
	local remote = ReplicatedStorage:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = ReplicatedStorage
	end
	return remote
end

local SetupRestaurant = ensureRemote("SetupRestaurant")
local RestaurantState = ensureRemote("RestaurantState")
local GuestAction = ensureRemote("GuestAction")

local function defaultTables()
	return {
		{ Id = "Table1", Seats = 2, Occupied = false },
		{ Id = "Table2", Seats = 2, Occupied = false },
	}
end

function RestaurantService:Get(player)
	return restaurants[player]
end

function RestaurantService:Create(player)
	local data = DataService:Get(player)
	local restaurant = {
		Owner = player,
		Data = data,
		Tables = defaultTables(),
		Kitchen = { Oven = 1, PrepTables = 2, OrderTables = 2 },
		Orders = {},
		Guests = {},
	}
	restaurants[player] = restaurant
	return restaurant
end

function RestaurantService:SendState(player)
	local restaurant = restaurants[player]
	if not restaurant then return end
	RestaurantState:FireClient(player, {
		Money = restaurant.Data.Money,
		Diamonds = restaurant.Data.Diamonds,
		XP = restaurant.Data.XP,
		RestaurantLevel = restaurant.Data.RestaurantLevel,
		RestaurantType = restaurant.Data.RestaurantType,
		MenuCountry = restaurant.Data.MenuCountry,
		RestaurantName = restaurant.Data.RestaurantName,
		Tables = restaurant.Tables,
		Kitchen = restaurant.Kitchen,
		Orders = restaurant.Orders,
	})
end

SetupRestaurant.OnServerEvent:Connect(function(player, setup)
	local restaurant = restaurants[player]
	if not restaurant or restaurant.Data.RestaurantName then return end
	if type(setup) ~= "table" then return end
	if table.find(Config.RESTAURANT_TYPES, setup.RestaurantType) == nil then return end
	if table.find(Config.MENU_COUNTRIES, setup.MenuCountry) == nil then return end
	if type(setup.RestaurantName) ~= "string" or #setup.RestaurantName < 1 or #setup.RestaurantName > 40 then return end

	restaurant.Data.RestaurantType = setup.RestaurantType
	restaurant.Data.MenuCountry = setup.MenuCountry
	restaurant.Data.RestaurantName = setup.RestaurantName
	RestaurantService:SendState(player)
end)

GuestAction.OnServerEvent:Connect(function(player, action, payload)
	local restaurant = restaurants[player]
	if not restaurant then return end

	if action == "CollectMoney" and type(payload) == "number" and payload > 0 then
		restaurant.Data.Money += math.floor(payload)
		restaurant.Data.XP += math.floor(payload)
		RestaurantService:SendState(player)
	end
end)

Players.PlayerAdded:Connect(function(player)
	repeat task.wait() until DataService:Get(player)
	RestaurantService:Create(player)
	restaurant = RestaurantService:Get(player)
	RestaurantService:SendState(player)
end)

Players.PlayerRemoving:Connect(function(player)
	restaurants[player] = nil
end)

return RestaurantService
