local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local SetupRestaurant = ReplicatedStorage:WaitForChild("SetupRestaurant")
local RestaurantState = ReplicatedStorage:WaitForChild("RestaurantState")

local gui = Instance.new("ScreenGui")
gui.Name = "RestaurantHUD"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function label(parent, text, size, position)
	local x = Instance.new("TextLabel")
	x.Text = text
	x.Size = size
	x.Position = position
	x.BackgroundTransparency = 1
	x.TextScaled = true
	x.Parent = parent
	return x
end

local currency = Instance.new("Frame")
currency.Size = UDim2.fromOffset(190, 90)
currency.Position = UDim2.fromOffset(15, 15)
currency.Parent = gui
local moneyLabel = label(currency, "$200", UDim2.fromScale(1, .5), UDim2.fromScale(0, 0))
local diamondLabel = label(currency, "♦ 10", UDim2.fromScale(1, .5), UDim2.fromScale(0, .5))
local xp = label(gui, "XP 0", UDim2.fromOffset(300, 40), UDim2.new(.5, -150, 0, 15))

local bottom = Instance.new("Frame")
bottom.Size = UDim2.new(1, -30, 0, 80)
bottom.Position = UDim2.new(0, 15, 1, -95)
bottom.Parent = gui

local buildPanel = Instance.new("Frame")
buildPanel.Size = UDim2.fromOffset(520, 620)
buildPanel.Position = UDim2.new(1, -535, .5, -310)
buildPanel.Visible = false
buildPanel.Parent = gui
label(buildPanel, "BUILD", UDim2.new(1, 0, 0, 45), UDim2.fromOffset(0, 5))
label(buildPanel, "Restaurant   Decorate   Build   More   Packs", UDim2.new(1, -20, 0, 45), UDim2.fromOffset(10, 55))
label(buildPanel, "Paint   Duplicate   Grid   Inventory   Sell", UDim2.new(1, -20, 0, 45), UDim2.fromOffset(10, 110))
label(buildPanel, "E Exit   G Grid Size   Q Pick Item   ← Undo   → Redo", UDim2.new(1, -20, 0, 60), UDim2.fromOffset(10, 165))

for i, name in ipairs({ "Build", "Menu", "Staff", "Upgrades", "Shop" }) do
	local button = Instance.new("TextButton")
	button.Text = name
	button.Size = UDim2.new(.2, -5, 1, 0)
	button.Position = UDim2.new((i - 1) * .2, 2, 0, 0)
	button.Parent = bottom
	button.MouseButton1Click:Connect(function()
		if name == "Build" then buildPanel.Visible = not buildPanel.Visible end
	end)
end

local right = Instance.new("Frame")
right.Size = UDim2.fromOffset(180, 230)
right.Position = UDim2.new(1, -195, 0, 80)
right.Parent = gui
for i, name in ipairs({ "Music", "Achievements", "Restaurant", "Game Settings" }) do
	local button = Instance.new("TextButton")
	button.Text = name
	button.Size = UDim2.new(1, -10, 0, 50)
	button.Position = UDim2.fromOffset(5, (i - 1) * 55)
	button.Parent = right
end

local setup = Instance.new("Frame")
setup.Size = UDim2.fromOffset(600, 400)
setup.Position = UDim2.new(.5, -300, .5, -200)
setup.Parent = gui
label(setup, "CREATE YOUR RESTAURANT", UDim2.new(1, 0, 0, 50), UDim2.fromOffset(0, 10))

local selectedType = "Classic"
local selectedCountry = "American"
for i, value in ipairs({ "Classic", "Modern", "Italian", "Asian", "Diner" }) do
	local b = Instance.new("TextButton")
	b.Text = value
	b.Size = UDim2.fromOffset(105, 45)
	b.Position = UDim2.fromOffset(10 + (i - 1) * 115, 75)
	b.Parent = setup
	b.MouseButton1Click:Connect(function() selectedType = value end)
end
for i, value in ipairs({ "American", "Italian", "Japanese", "Mexican", "French" }) do
	local b = Instance.new("TextButton")
	b.Text = value
	b.Size = UDim2.fromOffset(105, 45)
	b.Position = UDim2.fromOffset(10 + (i - 1) * 115, 135)
	b.Parent = setup
	b.MouseButton1Click:Connect(function() selectedCountry = value end)
end

local nameBox = Instance.new("TextBox")
nameBox.PlaceholderText = "Restaurant name"
nameBox.Text = "My Restaurant"
nameBox.Size = UDim2.new(1, -20, 0, 50)
nameBox.Position = UDim2.fromOffset(10, 205)
nameBox.Parent = setup

local confirm = Instance.new("TextButton")
confirm.Text = "START"
confirm.Size = UDim2.new(1, -20, 0, 55)
confirm.Position = UDim2.fromOffset(10, 270)
confirm.Parent = setup
confirm.MouseButton1Click:Connect(function()
	SetupRestaurant:FireServer({ RestaurantType = selectedType, MenuCountry = selectedCountry, RestaurantName = nameBox.Text })
end)

RestaurantState.OnClientEvent:Connect(function(state)
	moneyLabel.Text = "$" .. tostring(state.Money)
	diamondLabel.Text = "♦ " .. tostring(state.Diamonds)
	xp.Text = "XP " .. tostring(state.XP)
	setup.Visible = not state.RestaurantName
end)
