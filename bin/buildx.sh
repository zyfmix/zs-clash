#!/usr/bin/env bash
set -xe

# 脚本路径
sc_dir="$(
  cd "$(dirname "$0")" >/dev/null 2>&1 || exit
  pwd -P
)"

# 去掉路径后缀
rs_path=${sc_dir/zs-clash*/zs-clash}

# 引入头文件
source $rs_path/bin/libs/headers.sh

#CPU_ARCH=linux/amd64,linux/arm64
CPU_ARCH=linux/amd64

docker buildx create --use --name tests_buildx || true
docker buildx build --progress=plain --push --platform=$CPU_ARCH -t registry.cn-hangzhou.aliyuncs.com/coam/zs-clash:latest  .

docker rmi registry.cn-hangzhou.aliyuncs.com/coam/zs-clash:latest || true
docker pull registry.cn-hangzhou.aliyuncs.com/coam/zs-clash:latest

exec docker run --rm --name=zs.clash.test -u root -p 8809:7890 -p 8810:9090 -v $(pwd)/conf:/app/conf -it registry.cn-hangzhou.aliyuncs.com/coam/zs-clash:latest /bin/sh --login

# visit: [](http://localhost:8810)
