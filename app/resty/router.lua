local router = {}

local routes = {
	GET = {},
	POST = {},
	PUT = {},
	DELETE = {}
}

function router.get(path, handler)
	routes.GET[path] = handler
end

function router.post(path, handler)
	routes.POST[path] = handler
end

function router.put(path, handler)
	routes.PUT[path] = handler
end

function router.delete(path, handler)
	routes.DELETE[path] = handler
end

function router.handle()
	local method = ngx.req.get_method()
	local uri = ngx.var.uri

	ngx.log(ngx.DEBUG, "Method: " .. method .. ", URI: " .. uri)

	if routes[method] and routes[method][uri] then
		return routes[method][uri]()
	else
		local alt_uri = uri
		if uri:sub(-1) == "/" then
			alt_uri = uri:sub(1, -2)
		else
			alt_uri = uri .. "/"
		end

		if routes[method] and routes[method][alt_uri] then
			return routes[method][alt_uri]()
		end

		ngx.status = ngx.HTTP_NOT_FOUND
		ngx.say("404 Not Found: " .. uri)
		return ngx.exit(ngx.HTTP_NOT_FOUND)
	end
end

function router._get_routes()
	return routes
end

return router
