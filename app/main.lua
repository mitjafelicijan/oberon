local router = require("resty.router").new()

-- Defining global context that all routes inherit.
ngx.ctx.internal = {
	environment = os.getenv("OBERON_ENVIRONMENT"),

	-- Comment/uncomment what you need.
	template = require("bootstrap.template").init(),
	memcached = require("bootstrap.memcached").init(),
	redis = require("bootstrap.redis").init(),
}

-- Importing the routes.
local default = require("routes.default")
local api = require("routes.api")
local forms = require("routes.forms")

router:match("GET", "/", default.get)
router:match("GET", "/api", api.get)
router:match("GET", "/forms", forms.get)

local ok, errmsg = router:execute(
	ngx.var.request_method,
	ngx.var.request_uri,
	ngx.req.get_uri_args(),
	nil, --ngx.req.get_post_args(),
	nil  --{other_arg = 1}
)

if ok then
	ngx.status = ngx.HTTP_OK
else
	ngx.status = ngx.HTTP_NOT_FOUND
	ngx.say("404 Not found")
	ngx.log(ngx.ERR, errmsg)
	ngx.exit(ngx.HTTP_NOT_FOUND)
end
