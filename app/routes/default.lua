local handler = {}

function handler:get()
	ngx.header["Content-Type"] = "text/html"

	octx.template.render("default.html", {
		title = "Hello, Oberon!",
		message = "This is how you render templates.",
		environment = octx.environment,
	})

	return ngx.exit(ngx.HTTP_OK)
end

return handler
