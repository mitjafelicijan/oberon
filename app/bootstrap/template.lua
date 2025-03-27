-- https://github.com/bungle/lua-resty-template

local template = require("resty.template")

local M = {}

function M:init()
	return template.new({ root = "/app/views" })
end

return M
