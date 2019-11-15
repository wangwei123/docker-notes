#!/bin/bash

#--network mynet --network-alias hello-go-net

docker run -d --name hello-go -p 8080:8080 --restart=always \
--cpus="1" --memory="512m" --memory-swap="1024m" --oom-kill-disable \
hello-go:v1
