
img:
	docker build -t tjhei/burnman-tmpnb-notebook .

push: img
	docker push tjhei/burnman-tmpnb-notebook

test: kill
	docker run -d -p 8888:8888 --name tmpnb tjhei/burnman-tmpnb-notebook
	@echo visit http://localhost:8888 now and type "make kill" to remove

kill:
	docker rm -f tmpnb || true


.PHONY: img test kill
