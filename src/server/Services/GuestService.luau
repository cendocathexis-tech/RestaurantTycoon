local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Config = require(ReplicatedStorage.Shared.Config)
local RestaurantService = require(script.Parent.RestaurantService)

local GuestService = {}
local GuestAction = ReplicatedStorage:WaitForChild("GuestAction")

local function findFreeTable(restaurant, groupSize)
	for _, tableData in ipairs(restaurant.Tables) do
		if not tableData.Occupied and tableData.Seats >= groupSize then
			return tableData
		end
	end
end

function GuestService:SpawnGroup(player)
	local restaurant = RestaurantService:Get(player)
	if not restaurant or not restaurant.Data.RestaurantName then return end
	if #restaurant.Guests > 0 then return end

	local tableData = findFreeTable(restaurant, Config.GUEST_GROUP_SIZE)
	local guest = {
		Id = tostring(os.clock()),
		Size = Config.GUEST_GROUP_SIZE,
		State = "Waiting",
		TableId = tableData and tableData.Id or nil,
		DishId = "StarterBurger",
	}
	table.insert(restaurant.Guests, guest)
	return guest
end

GuestAction.OnServerEvent:Connect(function(player, action, payload)
	local restaurant = RestaurantService:Get(player)
	if not restaurant then return end
	local guest = restaurant.Guests[1]
	if not guest then return end

	if action == "SeatGuest" then
		local tableId = payload and payload.TableId
		for _, tableData in ipairs(restaurant.Tables) do
			if tableData.Id == tableId and not tableData.Occupied and tableData.Seats >= guest.Size then
				tableData.Occupied = true
				guest.TableId = tableId
				guest.State = "BrowsingMenu"
				task.delay(Config.MENU_TIME, function()
					if guest.State == "BrowsingMenu" then
						guest.State = "OrderReady"
					end
				end)
				break
			end
		end
	elseif action == "TakeOrder" and guest.State == "OrderReady" then
			guest.State = "OrderTaken"
			table.insert(restaurant.Orders, { DishId = guest.DishId, GuestId = guest.Id, State = "Raw" })
	elseif action == "DeliverDish" and guest.State == "OrderTaken" then
			guest.State = "Eating"
			task.delay(Config.EATING_TIME, function()
				if guest.State ~= "Eating" then return end
				guest.State = "Finished"
				local tableData
				for _, t in ipairs(restaurant.Tables) do
					if t.Id == guest.TableId then tableData = t break end
				end
				if tableData then tableData.Occupied = false end
				restaurant.Data.Money += Config.DISHES[guest.DishId].Price
				restaurant.Data.XP += 10
				task.delay(1, function()
					if restaurant.Guests[1] == guest then
						table.remove(restaurant.Guests, 1)
					end
				end)
			end)
	end
end)

Players.PlayerAdded:Connect(function(player)
	task.delay(5, function()
		GuestService:SpawnGroup(player)
	end)
end)

return GuestService
