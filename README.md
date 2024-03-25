# nchan

https://github.com/slact/nchan

Fast, horizontally scalable, multiprocess pub/sub queuing server and proxy for HTTP, long-polling, Websockets and EventSource (SSE), powered by Nginx.

# openresty

https://github.com/openresty/openresty

High Performance Web Platform Based on Nginx and LuaJIT 

# nginx-proxy

https://github.com/nginx-proxy/nginx-proxy

Automated nginx proxy for Docker containers using docker-gen


# build
1. based on openresty/openresty:alpine
2. using multistage-build

# Usage

```
docker run [options] lloydzhou/nchan

docker run -v /my/custom/default.conf:/etc/nginx/conf.d/default.conf -p 80:80 lloydzhou/nchan

```

# test

## dependency
1. make
2. curl
3. wscat `sudo npm install -g wscat`

## start server
```
make test
```
## client test

### publish message using curl
```
curl --request POST --data "test message" -H "Accept: text/json" http://localhost:80/pub/test
{"messages": 2, "requested": 63, "subscribers": 0, "last_message_id": "1638248608:0" }
```
### subscribe message and publish message using wscat
```
wscat -c ws://localhost:80/pubsub/test
Connected (press CTRL+C to quit)
< test
< test message
> PING
< PONG
> test123
< test123
> 

```

