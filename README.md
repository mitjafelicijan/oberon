# Oberon - OpenResty Template

This is a tiny project boilerplate for OpenResty and Lua website that includes
basic router, memcached, Redis and MySQL with accompanying examples how to use
all this.

To run it locally use `make stack`. This will start OpenResty and all the
databases and then you can start tinkering with it and disabling things you
don't need.

## Reading material

- https://openresty-reference.readthedocs.io/en/latest/Lua_Nginx_API/
- https://ketzacoatl.github.io/posts/2017-03-06-lua-and-openresty-interlude-issues-with-luarocks-and-alpine.html
- https://github.com/openresty/lua-resty-core

## Included dependencies

- [x] https://github.com/APItools/router.lua
- [x] https://github.com/bungle/lua-resty-template
- [ ] https://github.com/bungle/lua-resty-session
- [ ] https://github.com/bungle/lua-resty-reqargs
- [ ] https://github.com/bungle/lua-resty-validation

## Internals

- https://github.com/openresty/lua-resty-memcached
- https://github.com/openresty/lua-resty-redis
- https://github.com/openresty/lua-resty-mysql
- https://github.com/openresty/lua-resty-redis
- https://github.com/openresty/lua-resty-string
