-- https://github.com/openresty/lua-resty-memcached

local memcached = require("resty.memcached")

local M = {}

function M:init(hostname, port, timeout)
	if not hostname then hostname = "memcached" end
	if not port then port = 11211 end
	if not timeout then timeout = 1000 end

	local memc, ok, err = nil, nil, nil

	memc, err = memcached:new()
	if not memc then
		ngx.log(ngx.ERR, "failed to instantiate memc: ", err)
		return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
	end

	memc:set_timeout(timeout)

	ok, err = memc:connect(hostname, port)
	if not ok then
		ngx.log(ngx.ERR, "failed to connect: ", err)
		return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
	end
end

return M
