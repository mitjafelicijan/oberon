FROM openresty/openresty:latest
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
