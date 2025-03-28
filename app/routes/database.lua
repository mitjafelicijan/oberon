local cjson = require "cjson"

local handler = {}

function handler.get(request)
	ngx.header["Content-Type"] = "text/html"

	-- MySQL example.
	local mysql_result = nil
	do
		local res, err, errcode, sqlstate = ngx.ctx.internal.mysql:query("select 33 + 22 as sum", 10)
		if not res then
			ngx.ctx.internal.mysql:close()
			ngx.log(ngx.ERR, "bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
			-- You can return or exit here.
		end
		mysql_result = { value = cjson.encode(res), err = err or "no error" }
	end

	-- Redis example.
	local redis_result = nil
	do
		local ok, err = ngx.ctx.internal.redis:set("oberon", "this is value from redis")
		if not ok then
			ngx.log(ngx.ERR, "failed to set redis key `oberon`:", err)
			-- You can return or exit here.
		end

		local res, err = ngx.ctx.internal.redis:get("oberon")
		if not res then
			ngx.log(ngx.ERR, "failed to get `oberon` key from redis:", err)
			-- You can return or exit here.
		end
		redis_result = { value = cjson.encode(res), err = err or "no error" }
	end

	-- Memcached example.
	local memcached_result = nil
	do
		local ok, err = ngx.ctx.internal.memcached:set("oberon", "this is value from memcached")
		if not ok then
			ngx.log(ngx.ERR, "failed to set memcached key `oberon`:", err)
			-- You can return or exit here.
		end

		local res, flags, err = ngx.ctx.internal.memcached:get("oberon")
		if err then
			ngx.log(ngx.ERR, "failed to get `oberon` key from memcached:", err)
			-- You can return or exit here.
		end
		memcached_result = { value = cjson.encode(res), err = err or "no error" }
	end

	ngx.ctx.internal.template.render("database.html", {
		title = "Database example",
		mysql = mysql_result,
		redis = redis_result,
		memcached = memcached_result,
		environment = ngx.ctx.internal.environment,
	})

	return ngx.exit(ngx.HTTP_OK)
end

return handler
