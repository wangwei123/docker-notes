# hello-go-nginx
### 这是一个docker案例：
1. 编译Go项目源码，并打包构建Go项目的镜像，然后运行该镜像的容器
2. 使用nginx源码编译制作base-nginx:v1基础镜像
3. 基于base-nginx:v1基础镜像制Go项目所需的nginx-hello:v1镜像，nginx-hello:v1镜像中的nginx配置文件做了反向代理Go项目
4. nginx-hello容器在宿主机上部署web前端项目，查看nginx日志，修改nginx配置文件

### 如何使用
1. 编译Go项目源码，并打包构建Go项目的镜像，然后运行该镜像的容器
```shell
cd 01_hello-go

#构建hello-go:v1镜像
./build-image.sh

#运行hello-go容器
./startup.sh
```

2. 使用nginx源码编译制作base-nginx:v1基础镜像
```shell
cd 02_build-base-ngx

#构建base-nginx:v1镜像
./build-base-ngx-image.sh

```

3. 基于base-nginx:v1基础镜像制Go项目所需的nginx-hello:v1镜像，nginx-hello镜像中的nginx配置文件做了反向代理Go项目
```shell
cd 03_nginx-hello

#构建nginx-hello:v1镜像
./build-image.sh

#运行nginx-hello容器
./start-nginx.sh

```

4. nginx-hello容器在宿主机上部署web前端项目，查看nginx日志，修改nginx配置文件 
查看第7节内容即可：https://github.com/yayinfor/dockerfile/blob/master/hello-go-nginx/03_nginx-hello/README.md




 
