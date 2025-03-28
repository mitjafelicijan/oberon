local cjson = require("cjson")

local handler = {}

function handler.get(request)
	ngx.header["Content-Type"] = "text/html"

	ngx.ctx.internal.template.render("forms.html", {
		title = "Forms example!",
		environment = ngx.ctx.internal.environment,
	})

	return ngx.exit(ngx.HTTP_OK)
end

function handler.post(request)
	ngx.header["Content-Type"] = "application/json"
	ngx.say(cjson.encode(request))
	return ngx.exit(ngx.HTTP_OK)
end

return handler
