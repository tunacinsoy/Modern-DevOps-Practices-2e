FROM ubuntu:bionic
RUN apt update && apt install -y curl nginx

WORKDIR /var/www/html/
ADD index.html ./

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

STOPSIGNAL SIGTERM
HEALTHCHECK --interval=60s --timeout=10s --start-period=20s --retries=3 CMD curl -f localhost
