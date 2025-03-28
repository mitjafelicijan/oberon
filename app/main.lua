local tinyrouter = require("resty.tinyrouter")

-- Defining global context that all routes inherit.
ngx.ctx.internal = {
	environment = os.getenv("OBERON_ENVIRONMENT"),

	-- Comment/uncomment what you need.
	template = require("bootstrap.template").init(),
	mysql = require("bootstrap.mysql").init(),
	memcached = require("bootstrap.memcached").init(),
	redis = require("bootstrap.redis").init(),
}

-- Importing the routes.
local default = require("routes.default")
local api = require("routes.api")
local forms = require("routes.forms")
local database = require("routes.database")
local params = require("routes.params")

tinyrouter.match("get", "/", default.get)
tinyrouter.match("get", "/api", api.get)
tinyrouter.match("get", "/forms", forms.get)
tinyrouter.match("get", "/database", database.get)
tinyrouter.match("get", "/params/:id/meta/:key", params.get)

-- Custom 404 handler.
tinyrouter.handle404(function(request)
	ngx.status = ngx.HTTP_NOT_FOUND
	ngx.say("My custom 404 handler!")
end)

tinyrouter.resolve()
