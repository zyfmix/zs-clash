# Clash for linux

```bash
git clone git@github.com:wnlen/clash-for-linux.git
```

## 修改 `.env` 配置文件

```bash
# Clash 订阅地址
export CLASH_URL='https://feedneo.com/files/******/clash.yml'
export CLASH_SECRET=''
```

## 启动服务

```bash
2024-06-16 19:29:55 on Ubuntu bsh ❯ ./start.sh
CPU architecture: amd64

正在检测订阅地址...
Clash订阅地址可访问！                                      [  OK  ]

正在下载Clash配置文件...
配置文件config.yaml下载成功！                              [  OK  ]

判断订阅内容是否符合clash配置文件标准:
订阅内容符合clash标准

正在启动Clash服务...
服务启动成功！                                             [  OK  ]

Clash Dashboard 访问地址: http://<ip>:9090/ui
Secret: e2dbe6e22cc0b7157bdc2e293d54564d025fefa3dcfd9a1a94e375288b2bc361

请执行以下命令加载环境变量: source /etc/profile.d/clash.sh

请执行以下命令开启系统代理: proxy_on

若要临时关闭系统代理，请执行: proxy_off
```

测试

```bash
proxy_on
wget https://github.com/nushell/nushell/releases/download/0.94.2/nu-0.94.2-aarch64-apple-darwin.tar.gz
```

本地

```bash
export https_proxy=http://0.zus.iirii.com:8809 http_proxy=http://0.zus.iirii.com:8809 all_proxy=socks5://0.zus.iirii.com:8809
wget https://github.com/nushell/nushell/releases/download/0.94.2/nu-0.94.2-aarch64-apple-darwin.tar.gz
```

访问: http://0.zus.iirii.com:8810/ui/#/proxies
