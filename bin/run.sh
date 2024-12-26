#!/usr/bin/env bash
set -e

sc_dir="$(
  cd "$(dirname "$0")" >/dev/null 2>&1 || exit
  pwd -P
)"

rs_path=${sc_dir/zs-clash*/zs-clash}

source $rs_path/bin/libs/headers.sh

Case=${1:-help}

ebc_debug "解析命令参数> run.sh $Case"

# 根据命令执行不同的命令格式
case "$Case" in
help)
  ebc_debug "说明: run.sh 命令快捷参数"
  ebc_debug "用法: run.sh <Case>"
  ebc_debug "示例: run.sh restart"
  ;;
reconfig)
  ebc_info "说明: 同步 clash 配置"
  ebc_info "> cp bin/clash.sh /etc/profile.d/clash.sh"
  cp bin/clash.sh /etc/profile.d/clash.sh
 ;;
info)
  ebc_info "请访问: http://0.zus.iirii.com:8810/ui/"
  cat conf/config.yaml | grep secret
 ;;
export)
  export https_proxy=http://0.zus.iirii.com:8809 http_proxy=http://0.zus.iirii.com:8809 all_proxy=socks5://0.zus.iirii.com:8809
  ebc_debug "[http_proxy: $http_proxy][https_proxy: $https_proxy][all_proxy: $all_proxy]"
 ;;
test)
  export https_proxy=http://0.zus.iirii.com:8809 http_proxy=http://0.zus.iirii.com:8809 all_proxy=socks5://0.zus.iirii.com:8809
  ebc_debug "[http_proxy: $http_proxy][https_proxy: $https_proxy][all_proxy: $all_proxy]"
  rm -rf _/*.tar.gz
  wget https://github.com/nushell/nushell/releases/download/0.94.2/nu-0.94.2-aarch64-apple-darwin.tar.gz -O _/nu-0.94.2-aarch64-apple-darwin.tar.gz
 ;;
start)
  #docker run --rm --name=zs.clash.test -u root -p 8809:7890 -p 8810:9090 -v $(pwd)/conf:/app/conf -it registry.cn-hangzhou.aliyuncs.com/coam/zs-clash:latest /bin/sh --login
  docker run --restart=always --name=zs.clash.test -u root -p 8809:7890 -p 8810:9090 -v $(pwd)/conf:/app/conf -it registry.cn-hangzhou.aliyuncs.com/coam/zs-clash:latest /bin/sh --login
 ;;
restart)
  docker stop zs.clash.test || true
  docker rm zs.clash.test || true
  docker run --restart=always --name=zs.clash.test -u root -p 8809:7890 -p 8810:9090 -v $(pwd)/conf:/app/conf -it registry.cn-hangzhou.aliyuncs.com/coam/zs-clash:latest /bin/sh --login
 ;;
stop)
  docker stop zs.clash.test || true
  docker rm zs.clash.test || true
 ;;
*)
  echo "[参数命令不合法]case: $Case [reconfig,info,start,restart,stop]"
  exit 1
  ;;
esac
