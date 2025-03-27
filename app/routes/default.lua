local handler = {}

function handler:get()
	ngx.header["Content-Type"] = "text/html"

	octx.template.render("default.html", {
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
		environment = octx.environment,
	})

	return ngx.exit(ngx.HTTP_OK)
end

return handler
