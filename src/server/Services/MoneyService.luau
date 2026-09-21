local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local DataService = require(script.Parent.DataService)

local MoneyService = {}

function MoneyService:Get(player)
	local data = DataService:Get(player)
	if not data then
		return 0
	end

	return data.Money
end

function MoneyService:Set(player, amount)
	local data = DataService:Get(player)
	if not data then
		return false
	end

	data.Money = math.max(Config.MIN_MONEY, math.floor(amount))
	return true
end

function MoneyService:Add(player, amount)
	return MoneyService:Set(player, MoneyService:Get(player) + amount)
end

function MoneyService:CanAfford(player, amount)
	return MoneyService:Get(player) >= amount
end

function MoneyService:Spend(player, amount)
	if amount < 0 or not MoneyService:CanAfford(player, amount) then
		return false
	end

	return MoneyService:Set(player, MoneyService:Get(player) - amount)
end

return MoneyService
