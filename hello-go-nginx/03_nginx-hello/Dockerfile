FROM base-nginx:v1

WORKDIR /usr/local/nginx

COPY nginx.conf /usr/local/nginx/conf

ENV PATH /usr/local/nginx/sbin:$PATH

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
