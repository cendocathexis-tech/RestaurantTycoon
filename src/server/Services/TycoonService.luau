local Players = game:GetService("Players")

local DataService = require(script.Parent.DataService)

local TycoonService = {}

local restaurants = {}

function TycoonService:Get(player)
	return restaurants[player]
end

function TycoonService:Create(player)
	if restaurants[player] then
		return restaurants[player]
	end

	local data = DataService:Load(player)

	restaurants[player] = {
		Owner = player,
		Data = data,
	}

	return restaurants[player]
end

function TycoonService:Remove(player)
	restaurants[player] = nil
	DataService:Release(player)
end

Players.PlayerAdded:Connect(function(player)
	local restaurant = TycoonService:Create(player)
	print("[TycoonService] Restaurant ready for " .. player.Name .. " | Money: " .. restaurant.Data.Money)
end)

Players.PlayerRemoving:Connect(function(player)
	TycoonService:Remove(player)
end)

return TycoonService
