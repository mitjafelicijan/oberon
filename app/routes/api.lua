local cjson = require("cjson")

local handler = {}

local function random_string(length)
	local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local result = {}
	for i = 1, length do
		local idx = math.random(1, #characters)
		local char = string.sub(characters, idx, idx)
		result[i] = char
	end
	return table.concat(result)
end

function handler:get()
	ngx.header["Content-Type"] = "application/json"

	local random_numbers = {}
	for i = 1, 10 do
		random_numbers[i] = math.random()
	end

	local random_strings = {}
	for i = 1, 10 do
		random_strings[i] = random_string(16)
	end

	local data = {
		version = 1.0,
		today = ngx.today(),
		epoch = ngx.time(),
		worker_pid = ngx.worker.pid(),
		random_numbers = random_numbers,
		random_strings = random_strings,
		tags = { "lua", "openresty" },
	}

	ngx.print(cjson.encode(data))
	return ngx.exit(ngx.HTTP_OK)
end

return handler
