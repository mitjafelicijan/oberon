local cjson = require("cjson")

local handler = {}

function handler.get(request)
	ngx.header["Content-Type"] = "application/json"

	ngx.print(cjson.encode(request))
	return ngx.exit(ngx.HTTP_OK)
end

return handler
