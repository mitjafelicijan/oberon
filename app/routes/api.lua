local cjson = require("cjson")

local handler = {}

function handler:get()
	ngx.header["Content-Type"] = "application/json"

	local data = {
		version = 1.0,
		tags = { "lua", "openresty" },
	}

	ngx.print(cjson.encode(data))
	return ngx.exit(ngx.HTTP_OK)
end

return handler
