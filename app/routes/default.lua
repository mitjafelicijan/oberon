local handler = {}

function handler.get(request)
	ngx.header["Content-Type"] = "text/html"

	ngx.ctx.internal.template.render("default.html", {
		title = "Hello, Oberon!",
		message = "This is how you render templates.",
		moons = {
			"Moon (Earth's moon)",
			"Titan (Saturn)",
			"Europa (Jupiter)",
			"Ganymede (Jupiter)",
			"Io (Jupiter)",
			"Enceladus (Saturn)",
			"Callisto (Jupiter)",
			"Triton (Neptune)",
			"Phobos (Mars)",
			"Charon (Pluto)",
		},
		environment = ngx.ctx.internal.environment,
	})

	return ngx.exit(ngx.HTTP_OK)
end

return handler
