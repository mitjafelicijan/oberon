local tinyrouter = {}

local routes = {
	GET = {},
	POST = {},
	PUT = {},
	DELETE = {},
}

local error_handlers = {
	handle404 = nil,
}

local function path_segments(path)
	local segments = {}
	for segment in string.gmatch(path, "[^/]+") do
		table.insert(segments, segment)
	end
	return segments
end

local function is_named_parameter(segment)
	return string.match(segment, "^:")
end

function tinyrouter.handle404(handler)
	error_handlers.handle404 = handler
end

function tinyrouter.match(method, path, handler)
	table.insert(routes[string.upper(method)], {
		path = path,
		handler = handler,
		path_segments = path_segments(path),
	})
end

function tinyrouter.resolve()
	local request = {
		path = ngx.var.uri,
		full_path = ngx.var.request_uri,
		method = ngx.req.get_method(),
		path_segments = path_segments(ngx.var.uri),
		query = ngx.req.get_uri_args(),
		params = {},
	}

	local matching_route = nil
	for _, item in pairs(routes[request.method]) do
		-- How many segments do match.
		local segments_matching = 0

		-- Found matching number of path segments.
		if #item.path_segments == #request.path_segments then
			for idx, match in ipairs(item.path_segments) do
				-- Check if maybe this is a named parameter.
				if is_named_parameter(match) then
					segments_matching = segments_matching + 1
					request.params[match:sub(2)] = request.path_segments[idx]
				elseif match == request.path_segments[idx] then
					segments_matching = segments_matching + 1
				end
			end

			if segments_matching == #item.path_segments then
				matching_route = item
				goto success
			end
		end
	end

	-- Nothing is found. We display 404 error.
	-- If no 404 handler is provided we display generic error.
	if error_handlers.handle404 and type(error_handlers.handle404) == "function" then
		error_handlers.handle404()
	else
		ngx.status = ngx.HTTP_NOT_FOUND
		ngx.say("404 Not found")
		ngx.exit(ngx.HTTP_NOT_FOUND)
	end

	-- Match was found and we try to invoke handler.
	::success::
	if matching_route then
		matching_route.handler(request)
	end
end

return tinyrouter
