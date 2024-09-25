FROM ubuntu:bionic
RUN apt update && apt install -y curl nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]