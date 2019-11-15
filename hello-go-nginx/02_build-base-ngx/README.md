# 构建一个最基础的nginx镜像

### 1. 编写Dockerfile文件，源码构建nginx镜像
```shell
# 基础镜像使用alpine，只有几M，不要使用centos
FROM alpine:3.9

# nginx版本和下载地址
ENV NGINX_VERSION nginx-1.16.0
ENV NGINX_DOWNLOAD_RUL http://nginx.org/download/$NGINX_VERSION.tar.gz

# 设置阿里云alpine apk镜像，安装nginx所需依赖包，下载nginx源码并安装
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
  apk --update add \
  build-base linux-headers openssl-dev pcre-dev wget zlib-dev \
  openssl pcre zlib && \
  cd /tmp && \
  wget $NGINX_DOWNLOAD_RUL && \
  tar -zxvf $NGINX_VERSION.tar.gz && \
  cd /tmp/$NGINX_VERSION && \
  ./configure \
    --prefix=/usr/local/nginx \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-http_slice_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio \
    --with-http_v2_module \
    --with-ipv6 \
&& make && \
   make install && \
   adduser -D nginx && \
   rm -rf /tmp/*

# 将nginx执行文件目录添加到PATH环境变量
ENV PATH /usr/local/nginx/sbin:$PATH

# 将nginx home目录设置为容器工作目录
WORKDIR /usr/local/nginx

# 对外暴露nginx端口
EXPOSE 80 443

# 运行容器时执行nginx运行命令，daemon off;是禁止后台运行，
# 容器内的应用必须前台运行，否则容器启动后会立即退出
CMD ["nginx", "-g", "daemon off;"]
```

### 2. 编写build-base-ngx-image.sh文件，用于构建base-nginx:v1基础镜像，该镜像用于具体项目的基础镜像
```shell
#!/bin/bash

# 构建base-nginx:v1镜像
docker build -t base-nginx:v1 -f Dockerfile .
```
### 3. 构建镜像并查看镜像是否构建成功

```shell
# 构建镜像
./build-base-ngx-image.sh

#查看构建成功的base-nginx镜像
docker image ls

# 镜像列表中包含名称为base-nginx:v1的镜像即为构建成功
```

### 4. 运行基于nginx-base:v1镜像的容器

```shell
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
docker run -d --name nginx-base -p 80:8080 --restart=always \
--cpus="1" --memory="512m" --memory-swap="1024m" --oom-kill-disable \
nginx-base:v1
```





 
