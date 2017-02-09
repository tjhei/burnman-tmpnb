IMG=tjhei/burnman-tmpnb-notebook

img:
	docker build -t tjhei/burnman-tmpnb-server .

push: img
	docker push tjhei/burnman-tmpnb-server

test: kill
	docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN --name=proxy jupyterhub/configurable-http-proxy --default-target http://127.0.0.1:9999
	docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN --name=tmpnb -v /var/run/docker.sock:/docker.sock tjhei/burnman-tmpnb-server python orchestrate.py \
         --image="${IMG}" \
        --pool-size=4 \
        --command='start-notebook.sh \
            "--NotebookApp.base_url={base_path} \
            --ip=0.0.0.0 \
            --port={port} \
            --NotebookApp.trust_xheaders=True"'

kill:
	docker rm -f proxy tmpnb || true

.PHONY: img test kill
