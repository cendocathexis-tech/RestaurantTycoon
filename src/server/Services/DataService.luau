local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)

local DataService = {}

local store = DataStoreService:GetDataStore(Config.DATASTORE_NAME)
local profiles = {}

local function copyTable(value)
	if type(value) ~= "table" then
		return value
	end

	local result = {}
	for key, child in pairs(value) do
		result[key] = copyTable(child)
	end
	return result
end

local function reconcile(data)
	local result = copyTable(Config.DEFAULT_PLAYER_DATA)

	if type(data) == "table" then
		for key, value in pairs(data) do
			result[key] = value
		end
	end

	return result
end

function DataService:Get(player)
	return profiles[player]
end

function DataService:Load(player)
	local key = "Player_" .. player.UserId
	local data

	local success, err = pcall(function()
		data = store:GetAsync(key)
	end)

	if not success then
		warn("[DataService] Failed to load " .. player.Name .. ": " .. tostring(err))
		data = nil
	end

	profiles[player] = reconcile(data)
	return profiles[player]
end

function DataService:Save(player)
	local data = profiles[player]
	if not data then
		return false
	end

	local key = "Player_" .. player.UserId

	local success, err = pcall(function()
		store:SetAsync(key, data)
	end)

	if not success then
		warn("[DataService] Failed to save " .. player.Name .. ": " .. tostring(err))
		return false
	end

	return true
end

function DataService:Release(player)
	profiles[player] = nil
end

Players.PlayerRemoving:Connect(function(player)
	DataService:Save(player)
	DataService:Release(player)
end)

game:BindToClose(function()
	for _, player in Players:GetPlayers() do
		DataService:Save(player)
	end
end)

return DataService
