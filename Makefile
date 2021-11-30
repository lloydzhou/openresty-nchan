build:
	docker build -t lloydzhou/openresty-nchan -f Dockerfile . | tee /tmp/build.log

push:
	docker push lloydzhou/openresty-nchan



