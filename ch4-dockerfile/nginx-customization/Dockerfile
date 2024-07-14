FROM ubuntu:bionic
RUN apt update && apt install -y curl nginx
WORKDIR /var/www/html/
ADD index.html .
ENTRYPOINT ["nginx", "-g", "daemon off;"]