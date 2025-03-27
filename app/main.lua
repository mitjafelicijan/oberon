local router = require("resty.router")

-- Defining global context that all routes inherit.
_G.octx = {
	environment = os.getenv("OBERON_ENVIRONMENT"),

	-- Comment/uncomment what you need.
	template = require("bootstrap.template").init(),
	memcached = require("bootstrap.memcached").init(),
	redis = require("bootstrap.redis").init(),
}

-- Importing the routes.
local default = require("routes.default")
local api = require("routes.api")
local routes = require("routes.routes")

-- Declaring routes - put stuff here.
router.get("/", default.get)
router.get("/api", api.get)
router.get("/routes", function()
	routes:get(router)
end)

-- Handling all the routes.
return router.handle()
