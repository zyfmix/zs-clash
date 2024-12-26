#!/usr/bin/env bash
set -e

sc_dir="$(
  cd "$(dirname "$0")" >/dev/null 2>&1 || exit
  pwd -P
)"

rs_path=${sc_dir/zs-clash*/zs-clash}

source $rs_path/bin/libs/headers.sh

Case=${1:-restart}

ebc_debug "解析命令参数> service.sh $Case"

shopt -s expand_aliases
alias dcs='docker-compose -f deploy/docker-compose-trojan.yml --env-file deploy/.env.trojan'

# 根据命令执行不同的命令格式
case "$Case" in
help)
  ebc_debug "说明: trojan.sh 命令快捷参数 [使用 docker-compose 管理 docker 服务(zs.trojan)]"
  ebc_debug "用法: trojan.sh <Case>"
  ebc_debug "示例: trojan.sh restart"
  ;;
restart)
  dcs down

  #rm -rf conf/cache.db

  #dcs up -d --pull=always
  dcs up -d

  dcs logs -f
 ;;
stop)
  dcs down
  docker ps -a
 ;;
clean)
  #[How to Get Docker-Compose to Always Use the Latest Image](https://www.baeldung.com/ops/docker-compose-latest-image)
  dcs down --rmi all
  ;;
*)
  echo "[参数命令不合法]case: $Case [restart,stop,clean]"
  exit 1
  ;;
esac
