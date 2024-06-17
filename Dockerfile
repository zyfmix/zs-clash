#############################################################################
# Docker 镜像容器构建配置文件
#
##* 登录 `Docker` 服务器
# Usage:
#> docker login
#
##* 构建并发布 `image` 文件
#
# Usage:
#> docker image build --no-cache -t registry.cn-hangzhou.aliyuncs.com/coam/zs-clash:latest . --push
#> docker image push coam/zs-clash:latest
#
##* 启动 Docker Container
# Usage:
#> docker container run --rm --name=zs.clash -u root -p 8080:8000 -it coam/zs-clash /bin/bash --login
#
##* 进入 Docker Container
# Usage:
#> docker exec -u root -it zs.clash /bin/bash --login

#[镜像安装说明]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 依赖目录及数据
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# [git executable not found in golang:alpine image](https://github.com/docker-library/golang/issues/209)
#FROM --platform=$BUILDPLATFORM proxy.icsay.com/library/golang:1.22.3-alpine3.19 AS builder
FROM --platform=$BUILDPLATFORM proxy.icsay.com/library/alpine:3.20.0

MAINTAINER Cor Ethan <zyf@iirii.com>

ARG TARGETOS
ARG TARGETARCH

# Set Environment Variables
ENV HOME /app

# apk mirror
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache bash openssl curl

# 同步项目
WORKDIR /app

COPY . /app

RUN sed -i 's/log-level: .*/log-level: debug/' /app/temp/templete_config.yaml

RUN echo "" > ${HOME}/.env

EXPOSE 7890 7891 9090
CMD [ "/app/bin/start.sh" ]
