local Config = {}

Config.DATASTORE_NAME = "RestaurantTycoon_PlayerData_v2"
Config.STARTING_MONEY = 200
Config.STARTING_DIAMONDS = 10
Config.MIN_MONEY = 0
Config.STARTING_XP = 0

Config.DEFAULT_PLAYER_DATA = {
	Money = Config.STARTING_MONEY,
	Diamonds = Config.STARTING_DIAMONDS,
	XP = Config.STARTING_XP,
	RestaurantLevel = 1,
	RestaurantType = nil,
	MenuCountry = nil,
	RestaurantName = nil,
	Cleanliness = 100,
	PurchasedItems = {},
	UnlockedDishes = { "StarterBurger" },
	Staff = {},
	Upgrades = {},
}

Config.RESTAURANT_TYPES = {
	"Classic",
	"Modern",
	"Italian",
	"Asian",
	"Diner",
}

Config.MENU_COUNTRIES = {
	"American",
	"Italian",
	"Japanese",
	"Mexican",
	"French",
}

Config.DISH_CATEGORIES = { "Starter", "Main", "Dessert", "Drink" }

Config.DISHES = {
	StarterBurger = { Name = "Starter Burger", Category = "Starter", Price = 20, Prep = "ChopBake" },
	Pasta = { Name = "Pasta", Category = "Main", Price = 30, Prep = "ChopBake" },
	Salad = { Name = "Salad", Category = "Starter", Price = 18, Prep = "Chop" },
	Cake = { Name = "Cake", Category = "Dessert", Price = 28, Prep = "Bake" },
	Lemonade = { Name = "Lemonade", Category = "Drink", Price = 12, Prep = "Serve" },
}

Config.GUEST_GROUP_SIZE = 2
Config.MENU_TIME = 30
Config.EATING_TIME = 30
Config.BAKING_TIME = 5
Config.CHOP_CLICKS = 10
Config.ORDER_HOLD_TIME = 3

return Config
