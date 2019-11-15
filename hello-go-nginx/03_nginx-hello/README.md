## 基于nginx-base:v1镜像构建用于hello-go项目的nginx镜像

### 1. 修改nginx.conf配置文件：
```
server {
    listen       80;
    server_name  localhost;
    
    # 修改了如下代码，用于反向代理hello-go的web服务
    location / {
      proxy_pass http://hello-go-net:8080;
    }
    ...
}

// 这里hello-go-net是hello-go容器的网络映射名称，类似IP的别名
location / {
  proxy_pass http://hello-go-net:8080;
}

```

### 2. 编写Dockerfile文件，源码构建nginx镜像
```
# 将base-nginx:v1作为基础镜像
FROM base-nginx:v1

# 将配置了反向代理hello-go项目的配置文件nginx.conf，替换nginx默认配置文件
COPY nginx.conf /usr/local/nginx/conf

# 对外暴露容器的80 443端口
EXPOSE 80 443

# 容器启动时执行nginx运行命令
CMD ["nginx", "-g", "daemon off;"]
```

### 3. 编写build-image.sh文件，用于构建nginx-hello:v1镜像
```
#!/bin/bash

# 构建nginx-hello:v1镜像
docker build -t nginx-hello:v1 -f Dockerfile .
```
### 4. 构建镜像并查看镜像是否构建成功

```
# 构建镜像
./build-image.sh

#查看构建成功的nginx-hello镜像
docker image ls

# 镜像列表中包含名称为nginx-hello:v1的镜像即为构建成功
```

### 5. 编写start-nginx.sh脚本，运行基于nginx-hello:v1镜像的容器

```
#!/bin/bash

# 命令参数讲解：
# docker run: 运行容器
# -d: 后台运行
# --name nginx-base: 是指定容器名称为nginx-base
# -p 8080:80 : 指定宿主机端口映射容器端口，通过宿主机8080端口可访问容器中nginx的80端口
# --restart=always: 容器意外停止后，自动重启
# --cpus="1": 分配CPU的核心数
# --memory="512m": 分配内存为512m
# --memory-swap="1024m": 当容器内存不足时，最大可扩容到1024m, 宿主机会再分配512m给容器
# --oom-kill-disable: 内存不足时禁止杀掉容器
# nginx-base:v1 镜像名称

# 执行下面命令启动容器
docker run -d --name nginx-hello -p 80:80 --restart=always \
--link=hello-go:hello-go-net \
--cpus="1" --memory="512m" --memory-swap="1024m" --oom-kill-disable \
--mount src=ngx-hello-wwwroot,dst=/nginx/html \
--mount src=ngx-hello-logs,dst=/nginx/logs \
--mount src=ngx-hello-conf,dst=/nginx/conf \
nginx-hello:v1

#部署：复制index.html文件到数据卷ngx-hello-wwwroot宿主机目录
cp -rf index.html /var/lib/docker/volumes/ngx-hello-wwwroot/_data
```

### 6. 运行nginx-hello:v1镜像的容器
```
// 运行容器
./start-nginx.sh

// 查看nginx-hello
docker ps

浏览器打开http://localhost

```

### 7. 部署项目和查看日志

```
// 查看start-nginx.sh源码内容
#!/bin/bash

docker run -d --name nginx-hello -p 80:80 --restart=always \
--link=hello-go:hello-go-net \
--cpus="1" --memory="512m" --memory-swap="1024m" --oom-kill-disable \
--mount src=ngx-hello-wwwroot,dst=/nginx/html \
--mount src=ngx-hello-logs,dst=/nginx/logs \
--mount src=ngx-hello-conf,dst=/nginx/conf \
nginx-hello:v1

#部署：复制index.html文件到数据卷ngx-hello-wwwroot宿主机目录
cp -rf index.html /var/lib/docker/volumes/ngx-hello-wwwroot/_data


从以上代码我们知道  
1. 挂载容器目录/nginx/html对应宿主机数据卷ngx-hello-wwwroot // 该目录存放着nginx web项目文件  
2. 挂载容器目录/nginx/logs对应宿主机数据卷ngx-hello-logs // 该目录存放着nginx日志文件  
3. 挂载容器目录/nginx/conf对应宿主机数据卷ngx-hello-conf // 该目录存放着nginx配置文件 
```

执行docker inspect nginx-hello, 从输出内容中找到Mounts信息如下：

```
"Mounts": [
    {
        "Type": "volume",
        "Name": "ngx-hello-wwwroot",
        "Source": "/var/lib/docker/volumes/ngx-hello-wwwroot/_data",
        "Destination": "/nginx/html",
        "Driver": "local",
        "Mode": "z",
        "RW": true,
        "Propagation": ""
    },
    {
        "Type": "volume",
        "Name": "ngx-hello-logs",
        "Source": "/var/lib/docker/volumes/ngx-hello-logs/_data",
        "Destination": "/nginx/logs",
        "Driver": "local",
        "Mode": "z",
        "RW": true,
        "Propagation": ""
    }
]
```

上面有2个Volume数据卷，  
通过Name为ngx-hello-wwwroot可以看出：  
宿主机目录在：/var/lib/docker/volumes/ngx-hello-wwwroot/_data 
容器目录在：/nignx/html  

通过Name为ngx-epark-logs可以看出：  
宿主机目录在：/var/lib/docker/volumes/ngx-hello-logs/_data 
容器目录在：/nginx/logs

#### 部署项目：  
只需要把项目文件拷贝到/var/lib/docker/volumes/ngx-hello-wwwroot/_data即可完成部署， 
此时容器目录/nignx/html中也会有最新部署的项目文件

可查看start-nginx.sh中如下代码片段，即为部署项目的方式
```
#部署：复制index.html文件到数据卷ngx-hello-wwwroot宿主机目录
cp -rf index.html /var/lib/docker/volumes/ngx-hello-wwwroot/_data
```

#### 查看日志： 
ls /var/nignx的lib/docker/volumes/ngx-hello-logs/_data即可看到里面有nignx的日志文件

 
