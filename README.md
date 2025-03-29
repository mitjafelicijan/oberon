# Oberon - OpenResty Template

This is a tiny project boilerplate for OpenResty and Lua website that includes
basic router, memcached, Redis and MySQL with accompanying examples how to use
all this.

To run it locally use `make stack`. This will start OpenResty and all the
databases and then you can start tinkering with it and disabling things you
don't need.

## Project Structure

```
oberon/
├── app/                 # Main application directory
│   ├── bootstrap/       # Bootstrap modules (template, database, cache)
│   ├── routes/          # Route handlers and controllers
│   ├── static/          # Static assets (CSS, JS, images)
│   ├── views/           # View templates
│   ├── resty/           # OpenResty specific modules
│   └── main.lua         # Application entry point
├── nginx.conf           # Nginx configuration
├── Dockerfile           # Container configuration
├── stack.yaml           # Stack configuration
├── Makefile             # Build and deployment scripts
└── LICENSE              # Project license
```

## Core Components

### Application Entry Point (main.lua)

The main application file sets up the core components and routing system:

- Initializes global context with environment variables
- Sets up template engine, MySQL, Memcached, and Redis connections
- Defines route handlers for different endpoints
- Implements custom 404 handling

### Routing Examples

The project uses a simple and intuitive routing system. Here are some examples:

1. Basic Route Handler:
```lua
-- In routes/default.lua
local handler = {}

function handler.get(request)
    ngx.header["Content-Type"] = "text/html"
    ngx.ctx.internal.template.render("index.html", {
        title = "Welcome to Oberon"
    })
    return ngx.exit(ngx.HTTP_OK)
end

return handler
```

2. Form Handling (GET/POST):
```lua
-- In routes/forms.lua
local cjson = require("cjson")

local handler = {}

function handler.get(request)
    -- Render form template
    ngx.ctx.internal.template.render("forms.html", {
        title = "Forms example!",
        environment = ngx.ctx.internal.environment
    })
    return ngx.exit(ngx.HTTP_OK)
end

function handler.post(request)
    -- Handle form submission
    ngx.header["Content-Type"] = "application/json"
    ngx.say(cjson.encode(request))
    return ngx.exit(ngx.HTTP_OK)
end

return handler
```

3. Dynamic Route Parameters:
```lua
-- In routes/params.lua
local handler = {}

function handler.get(request)
    -- Access route parameters
    local id = request.params.id
    local key = request.params.key
    -- Process parameters...
end

return handler
```

4. API Endpoint:
```lua
-- In routes/api.lua
local handler = {}

function handler.get(request)
    ngx.header["Content-Type"] = "application/json"
    -- Return JSON response
    ngx.say(cjson.encode({
        status = "success",
        data = { message = "API is working" }
    }))
    return ngx.exit(ngx.HTTP_OK)
end

return handler
```

Key points about routing

- Each route is defined in a separate file under the `routes/` directory
- Route handlers are simple Lua modules that return a table with handler
  functions
- HTTP methods (GET, POST) are handled by corresponding functions in the
  handler module
- The `request` object contains route parameters, query parameters, and request
  body
- Responses can be HTML (using template engine) or JSON
- Proper HTTP status codes and content types should be set

### Bootstrap Modules

The application includes several bootstrap modules for common functionality:

- Template Engine
- MySQL Database Connection
- Memcached Cache
- Redis Cache

### Database Usage Examples

The project supports multiple database types through bootstrap modules. Here are
examples for each:

1. MySQL Database Operations:
```lua
-- Execute a query
local res, err, errcode, sqlstate = ngx.ctx.internal.mysql:query("SELECT * FROM users WHERE id = ?", 10)
if not res then
    ngx.log(ngx.ERR, "Query failed: ", err, ": ", errcode, ": ", sqlstate)
    -- Handle error
end

-- Process results
for i, row in ipairs(res) do
    -- Access row data
    local id = row.id
    local name = row.name
end

-- Don't forget to close the connection when done
ngx.ctx.internal.mysql:close()
```

2. Redis Cache Operations:
```lua
-- Set a value
local ok, err = ngx.ctx.internal.redis:set("user:123", "user data")
if not ok then
    ngx.log(ngx.ERR, "Failed to set Redis key:", err)
    -- Handle error
end

-- Get a value
local res, err = ngx.ctx.internal.redis:get("user:123")
if not res then
    ngx.log(ngx.ERR, "Failed to get Redis key:", err)
    -- Handle error
end

-- Set with expiration (in seconds)
ngx.ctx.internal.redis:set("session:123", "session data", 3600)  -- Expires in 1 hour
```

3. Memcached Operations:
```lua
-- Set a value
local ok, err = ngx.ctx.internal.memcached:set("cache:key", "cached data")
if not ok then
    ngx.log(ngx.ERR, "Failed to set Memcached key:", err)
    -- Handle error
end

-- Get a value
local res, flags, err = ngx.ctx.internal.memcached:get("cache:key")
if err then
    ngx.log(ngx.ERR, "Failed to get Memcached key:", err)
    -- Handle error
end

-- Set with expiration (in seconds)
ngx.ctx.internal.memcached:set("temp:key", "temporary data", 300)  -- Expires in 5 minutes
```

Key points about database usage:

- All database connections are managed through the bootstrap modules
- Error handling is important for all database operations
- Connections should be properly closed when done
- Use parameterized queries for MySQL to prevent SQL injection
- Cache operations should include appropriate expiration times
- Consider using transactions for complex MySQL operations
- Use appropriate data types and serialization for cache storage

## Development Setup

### Prerequisites

- OpenResty
- Docker (optional)
- Make

### Local Development

1. Clone the repository
2. Install dependencies
3. Configure environment variables
4. Run the development server

### Docker Deployment

The project includes Docker support for containerized deployment:

- Build the image using the provided Dockerfile
- Configure environment variables
- Run the container

## Configuration

### Environment Variables

- `OBERON_ENVIRONMENT`: Sets the application environment
(development/production)

To pass additional environment variables to the Lua application:

1. Add the environment variable to your system/container
2. Update nginx.conf to pass it through using `env` directive:
   ```nginx
   env OBERON_ENVIRONMENT;
   env YOUR_NEW_VARIABLE; 
   ```
3. Access in Lua code via `os.getenv("YOUR_NEW_VARIABLE")`

> [!NOTE]
> This is required because OpenResty/Nginx does not automatically expose
> environment variables to Lua for security reasons. Each variable must be
> explicitly allowed in the nginx configuration.

### Nginx Configuration

The `nginx.conf` file contains the server configuration for OpenResty,
including:

- Server blocks
- Location directives
- Lua module loading
- Static file serving

## Contributing

Please refer to the LICENSE file for information about contributing to the
project.

## Documentation and Resources

- https://openresty-reference.readthedocs.io/en/latest/Lua_Nginx_API/
- https://ketzacoatl.github.io/posts/2017-03-06-lua-and-openresty-interlude-issues-with-luarocks-and-alpine.html
- https://github.com/openresty/lua-resty-core
- https://github.com/LewisJEllis/awesome-lua

## Included dependencies

- https://github.com/bungle/lua-resty-template

## OpenResty internals

- https://github.com/openresty/lua-resty-memcached
- https://github.com/openresty/lua-resty-redis
- https://github.com/openresty/lua-resty-mysql
- https://github.com/openresty/lua-resty-redis
- https://github.com/openresty/lua-resty-string
