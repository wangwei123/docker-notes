## 使用docker部署一个包含hello api的Go web应用

### 1. 首先编写Dockerfile文件内容，用于构建Go应用镜像：
```shell
# 基础镜像
FROM alpine:latest　　　　　　　　　　　

# 作者信息
MAINTAINER wangwei "2531868871@qq.com"

# 设置容器工作目录，即Go应用目录
WORKDIR /usr/local/apps/hello

# 把编译好的Go应用main执行文件复制到容器工作目录
ADD ./main  /usr/local/apps/hello

# 对外暴露Go应用的http服务器端口8080
EXPOSE 8080

# 运行Go应用
CMD ["/usr/local/apps/hello/main"]
```

### 2. 编写build-image.sh脚本，编译Go应用，并构建Go应用的镜像
```shell
#!/bin/bash

# 编译Go应用
GOOS=linux GOARCH=amd64 go build main.go

# 构建名称为hello-go:v1的镜像，具体看步骤1中Dockerfile内容
docker build -t hello-go:v1 .
```

### 3. 编写startup.sh脚本，运行hello-go:v1镜像的容器
```shell
#!/bin/bash

# 运行hello-go:v1镜像的容器
docker run -d --name hello-go -p 8080:8080 --restart=always \
--cpus="1" --memory="512m" --memory-swap="1024m" --oom-kill-disable \
hello-go:v1
```

### 4. 访问Go应用
浏览器打开http://localhost:8080/hello, 输出内容：Hello World Golang!





 

