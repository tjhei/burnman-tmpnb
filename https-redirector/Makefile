IMG=tjhei/burnman-tmpnb-redirector
NAME=redirector

img:
	docker build -t ${IMG} .

push: img
	docker push ${IMG}

test: kill img
	docker run --net=host -d --name=${NAME} ${IMG}
	echo "try to access http://127.0.0.1:7999"

kill:
	docker rm -f ${NAME} || true

.PHONY: img test kill
