local Workspace = game:GetService("Workspace")

local WorldBuilder = {}

local function part(parent, name, size, position, color, material)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = position
	p.Anchored = true
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Parent = parent
	return p
end

function WorldBuilder.Build()
	if Workspace:FindFirstChild("RestaurantWorld") then return end

	local world = Instance.new("Folder")
	world.Name = "RestaurantWorld"
	world.Parent = Workspace

	part(world, "Ground", Vector3.new(180, 1, 120), Vector3.new(0, -0.5, 0), Color3.fromRGB(70, 120, 70), Enum.Material.Grass)

	local plot = Instance.new("Model")
	plot.Name = "PlayerPlot"
	plot.Parent = world
	part(plot, "PlotFloor", Vector3.new(55, 1, 45), Vector3.new(0, 0.5, 0), Color3.fromRGB(180, 180, 180), Enum.Material.Concrete)

	local restaurant = Instance.new("Model")
	restaurant.Name = "Restaurant"
	restaurant.Parent = plot

	for _, z in ipairs({-10, 10}) do
		local tableModel = Instance.new("Model")
		tableModel.Name = "Table"
		tableModel.Parent = restaurant
		part(tableModel, "TableTop", Vector3.new(7, 1, 5), Vector3.new(-10, 3, z), Color3.fromRGB(120, 75, 45), Enum.Material.Wood)
		for _, x in ipairs({-12.5, -7.5}) do
			part(tableModel, "Chair", Vector3.new(2, 3, 2), Vector3.new(x, 1.5, z), Color3.fromRGB(90, 55, 35), Enum.Material.Wood)
		end
	end

	local kitchen = Instance.new("Model")
	kitchen.Name = "Kitchen"
	kitchen.Parent = restaurant
	part(kitchen, "KitchenFloor", Vector3.new(25, 1, 40), Vector3.new(15, 1, 0), Color3.fromRGB(120, 120, 120), Enum.Material.Metal)
	part(kitchen, "Oven", Vector3.new(5, 5, 5), Vector3.new(10, 4, -12), Color3.fromRGB(50, 50, 50), Enum.Material.Metal)
	for i, z in ipairs({-3, 5}) do
		part(kitchen, "PrepTable" .. i, Vector3.new(7, 3, 4), Vector3.new(12, 2.5, z), Color3.fromRGB(190, 190, 190), Enum.Material.Metal)
	end
	for i, z in ipairs({13, 21}) do
		part(kitchen, "OrderTable" .. i, Vector3.new(7, 3, 4), Vector3.new(12, 2.5, z), Color3.fromRGB(100, 70, 45), Enum.Material.Wood)
	end

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "RestaurantSpawn"
	spawn.Size = Vector3.new(6, 1, 6)
	spawn.Position = Vector3.new(-22, 2, 0)
	spawn.Anchored = true
	spawn.Neutral = false
	spawn.Parent = plot
end

return WorldBuilder
