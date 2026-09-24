local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local DataService = {}
local store = DataStoreService:GetDataStore(Config.DATASTORE_NAME)
local profiles = {}

local function copyTable(value)
	if type(value) ~= "table" then return value end
	local result = {}
	for key, child in pairs(value) do result[key] = copyTable(child) end
	return result
end

local function reconcile(data)
	local result = copyTable(Config.DEFAULT_PLAYER_DATA)
	if type(data) ~= "table" then return result end
	for key, value in pairs(data) do result[key] = value end
	if data.Diamonds == nil then
		result.Money = Config.STARTING_MONEY
		result.Diamonds = Config.STARTING_DIAMONDS
		result.XP = Config.STARTING_XP
		result.RestaurantType = nil
		result.MenuCountry = nil
		result.RestaurantName = nil
	end
	return result
end

function DataService:Get(player) return profiles[player] end

function DataService:Load(player)
	local data
	local success, err = pcall(function() data = store:GetAsync("Player_" .. player.UserId) end)
	if not success then warn("[DataService] Load failed: " .. tostring(err)) end
	profiles[player] = reconcile(data)
	return profiles[player]
end

function DataService:Save(player)
	local data = profiles[player]
	if not data then return false end
	local success, err = pcall(function() store:SetAsync("Player_" .. player.UserId, data) end)
	if not success then warn("[DataService] Save failed: " .. tostring(err)) return false end
	return true
end

function DataService:Release(player) profiles[player] = nil end

Players.PlayerRemoving:Connect(function(player)
	DataService:Save(player)
	DataService:Release(player)
end)

game:BindToClose(function()
	for _, player in Players:GetPlayers() do DataService:Save(player) end
end)

return DataService
