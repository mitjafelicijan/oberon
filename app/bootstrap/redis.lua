-- https://github.com/openresty/lua-resty-redis

local redis = require("resty.redis")

local M = {}

function M:init(hostname, port, timeout)
	if not hostname then hostname = "redis" end
	if not port then port = 6379 end
	if not timeout then timeout = 1000 end

	local red, ok, err = nil, nil, nil

	red = redis:new()

	red:set_timeouts(timeout, timeout, timeout)

	ok, err = red:connect(hostname, port)
	if not ok then
		ngx.log(ngx.ERR, "failed to connect: ", err)
		return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
	end
end

return M
