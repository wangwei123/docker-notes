#!/bin/bash

# 创建mynet网络
#docker network create mynet
#--network mynet --network-alias nginx-net

docker run -d --name nginx-hello -p 80:80 --restart=always \
--link=hello-go:hello-go-net \
--cpus="1" --memory="512m" --memory-swap="1024m" --oom-kill-disable \
--mount src=ngx-hello-wwwroot,dst=/nginx/html \
--mount src=ngx-hello-logs,dst=/nginx/logs \
--mount src=ngx-hello-conf,dst=/nginx/conf \
nginx-hello:v1

# 复制index.html文件到数据卷ngx-epark-wwwroot宿主机目录
cp -rf index.html /var/lib/docker/volumes/ngx-hello-wwwroot/_data
