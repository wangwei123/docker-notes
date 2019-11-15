FROM alpine:3.9

# nginx版本和下载地址
ENV NGINX_VERSION nginx-1.16.0
ENV NGINX_DOWNLOAD_RUL http://nginx.org/download/$NGINX_VERSION.tar.gz

# 设置阿里云alpine apk镜像
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

# 设置nginx可执行文件到path中
ENV PATH /usr/local/nginx/sbin:$PATH
WORKDIR /usr/local/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
