local ServerScriptService = game:GetService("ServerScriptService")

local Services = ServerScriptService.Server.Services

require(Services.DataService)
require(Services.TycoonService)
require(Services.RestaurantService)
require(Services.GuestService)

print("[Server] RestaurantTycoon services started")
