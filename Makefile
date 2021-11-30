build:
	docker build -t lloydzhou/openresty-nchan -f Dockerfile . | tee /tmp/build.log

push:
	docker push lloydzhou/openresty-nchan

test:
	docker run --rm -it -p 80:80 lloydzhou/openresty-nchan



