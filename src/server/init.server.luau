local ServerScriptService = game:GetService("ServerScriptService")

local Services = ServerScriptService.Server.Services
local WorldBuilder = require(ServerScriptService.Server.WorldBuilder)

WorldBuilder.Build()

require(Services.DataService)
require(Services.TycoonService)
require(Services.RestaurantService)
require(Services.GuestService)

print("[Server] RestaurantTycoon Level 1 started")
