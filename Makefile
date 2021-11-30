build:
	docker build -t lloydzhou/nchan -f Dockerfile . | tee /tmp/build.log

push:
	docker push lloydzhou/nchan

test:
	docker run --rm -it -p 80:80 lloydzhou/nchan



