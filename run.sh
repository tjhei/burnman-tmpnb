
# delete routes:
# iptables -t nat -F 

echo 0 > /proc/sys/net/ipv4/conf/docker0/forwarding
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 7999
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8000

docker rm -f proxy tmpnb redirector

docker pull tjhei/burnman-tmpnb-notebook
docker pull tjhei/burnman-tmpnb-server
docker pull tjhei/burnman-tmpnb-redirector

export TOKEN=$( head -c 30 /dev/urandom | xxd -p )
export AUTHTOKEN=4062571d66d41fc604d59c915f77b3824b42016ed5bb2a8b5f31e21b2515
#export MASTERIMG=jupyter/tmpnb
export MASTERIMG=tjhei/burnman-tmpnb-server
#export IMG=jupyter/minimal-notebook
export IMG=tjhei/burnman-tmpnb-notebook

docker run --net=host -d \
    --name redirector \
    tjhei/burnman-tmpnb-redirector

docker run --net=host -d \
    -v "/root/certs/:/certs/:ro" \
    -e CONFIGPROXY_AUTH_TOKEN=$TOKEN \
    --name=proxy \
    jupyterhub/configurable-http-proxy \
    --default-target http://127.0.0.1:9999 \
    --ssl-cert=/certs/fullchain.pem \
    --ssl-key=/certs/privkey.pem

#docker run --net=host -d \
#    -e CONFIGPROXY_AUTH_TOKEN=$TOKEN \
#    --name=proxy \
#    jupyterhub/configurable-http-proxy \
#    --default-target http://127.0.0.1:9999


docker run --net=host -d \
    -e CONFIGPROXY_AUTH_TOKEN=$TOKEN \
    -e ADMIN_AUTH_TOKEN=$AUTHTOKEN \
    --name=tmpnb \
    -v /var/run/docker.sock:/docker.sock \
    $MASTERIMG \
    python orchestrate.py \
    --image="$IMG" \
    --pool-size=6 \
    --ip=127.0.0.1 \
    --command='start-notebook.sh \                                                                    
            "--NotebookApp.base_url={base_path} \
            --ip=0.0.0.0 \
            --port={port} \
            --NotebookApp.trust_xheaders=True"'




#   --admin-ip=0.0.0.0 \                                                                                             

# iptables -I INPUT -p tcp -m tcp --dport 8000 -j ACCEPT                  


docker logs -f tempnb
