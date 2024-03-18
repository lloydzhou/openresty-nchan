build:
	docker build -t lloydzhou/nchan -f Dockerfile .

build-proxy:
	sed -s 's/nginx:1.25.4-alpine/lloydzhou\/nchan\n\nRUN mkdir -p \/var\/log\/nginx \&\& ln -sf \/dev\/stdout \/var\/log\/nginx\/access.log/g' nginx-proxy/Dockerfile.alpine | sed -s 's/etc\/nginx\/nginx.conf/usr\/local\/openresty\/nginx\/conf\/nginx.conf/g' > .Dockerfile
	docker build -t lloydzhou/nchan:proxy -f .Dockerfile nginx-proxy

push:
	docker push lloydzhou/nchan

test:
	docker run --rm -it -p 80:80 lloydzhou/nchan



