local cjson = require("cjson")

local handler = {}

function handler:get(router)
	ngx.header["Content-Type"] = "application/json"

	local routes = router._get_routes()
	local list = {}

	for method, paths in pairs(routes) do
		for path, _ in pairs(paths) do
			table.insert(list, {
				method = method,
				uri = path,
			})
		end
	end

	ngx.print(cjson.encode(list))
	return ngx.exit(ngx.HTTP_OK)
end

return handler
