-- https://github.com/openresty/lua-resty-mysql

local mysql = require("resty.mysql")

local M = {}

function M:init(host, port, timeout, username, password, database)
	if not host then host = "mysql" end
	if not port then port = 3306 end
	if not timeout then timeout = 1000 end
	if not username then username = "root" end
	if not password then password = "" end
	if not database then database = "oberon" end

	local db, err, errcode, sqlstate = nil, nil, nil, nil

	db, err = mysql:new()
	if not db then
		ngx.log(ngx.ERR, "failed to initiate mysql: ", err)
		return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
	end

	db:set_timeout(timeout)

	ok, err, errcode, sqlstate = db:connect{
		host = host,
		port = port,
		database = database,
		user = username,
		password = password,
		charset = "utf8",
		max_packet_size = 1024 * 1024,
	}

	if not ok then
		ngx.say("failed to connect: ", err, ": ", errcode, " ", sqlstate)
		db:close()
		return
	end

	return db
end

return M
