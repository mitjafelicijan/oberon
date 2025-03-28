-- https://github.com/openresty/lua-resty-redis

local redis = require("resty.redis")

local M = {}

function M:init(host, port, timeout)
	if not host then host = "redis" end
	if not port then port = 6379 end
	if not timeout then timeout = 1000 end

	local red, ok, err = nil, nil, nil

	db = redis:new()

	db:set_timeouts(timeout, timeout, timeout)

	ok, err = db:connect(host, port)
	if not ok then
		ngx.log(ngx.ERR, "failed to connect: ", err)
		return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
	end

	return db
end

return M
