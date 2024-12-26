# Trojan for linux

## 签发域名证书

`~/Run/ansible` 项目

```bash
./bin/acme.sh issue
```

## 首先安装 nginx

```bash
apt install nginx
```

配置文件 `/etc/nginx/nginx.conf`

```bash
error_log stderr notice;

worker_processes 2;
worker_rlimit_nofile 130048;
worker_shutdown_timeout 10s;

events {
  multi_accept on;
  use epoll;
  worker_connections 16384;
}

http {
    aio threads;
    aio_write on;
    tcp_nopush on;
    tcp_nodelay on;
    
    keepalive_timeout 5m;
    keepalive_requests 100;
    reset_timedout_connection on;
    server_tokens off;
    autoindex off;

    server {
        listen 8043 ssl;
        listen 8080;
        server_name 2.server.iirii.com;
        root /usr/share/nginx/html;

        ssl_certificate   /etc/ssl/certs/iirii.com/fullchain.cer;
        ssl_certificate_key /etc/ssl/certs/iirii.com/iirii.com.key;
        ssl_ciphers  TLS13-AES-256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
        ssl_prefer_server_ciphers    on;
        ssl_protocols                TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
        ssl_session_cache            shared:SSL:50m;
        ssl_session_timeout          10m;
        ssl_session_tickets          on;
        error_page 497  https://$host$request_uri;
    }
}
```

使用 docker 启动

```bash
docker run --rm --name nginx --network host -v /etc/ssl/certs/iirii.com:/etc/ssl/certs/iirii.com -v /etc/nginx:/etc/nginx -v /usr/share/nginx/html:/usr/share/nginx/html:ro nginx
```

```bash
docker run -d --name nginx --network host -v /etc/ssl/certs/iirii.com:/etc/ssl/certs/iirii.com -v /etc/nginx:/etc/nginx -v /usr/share/nginx/html:/usr/share/nginx/html:ro nginx
```

## trojan 下载

```bash
wget https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-linux-amd64.zip
unzip trojan-go-linux-amd64.zip
```

## `trojan` 服务配置

配置 `server.json` 

```json
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 8443,
    "remote_addr": "127.0.0.1",
    "remote_port": 8080,
    "log_level": 0,
    "password": [
        "oo123456"
    ],
    "ssl": {
        "cert": "/root/certs/iirii.com/fullchain.cer",
        "key": "/root/certs/iirii.com/iirii.com.key",
        "sni": "2.server.iirii.com"
    },
    "router": {
        "enabled": true,
        "block": [
            "geoip:private"
        ],
        "geoip": "/root/geoip.dat",
        "geosite": "/root/geosite.dat"
    },
	 "mux": {
        "enabled": true,
        "concurrency": 8,
        "idle_timeout": 60
    }
}
```

## 启动 trojan 服务

```bash
./trojan-go -config example/server.json
```

使用 docker 启动

```bash
docker run --rm --name trojan-go --network host -v /etc/ssl/certs/iirii.com:/etc/ssl/certs/iirii.com -v /etc/trojan-go:/etc/trojan-go teddysun/trojan-go
```

```bash
docker run -d --name trojan-go --network host --restart=always -v /etc/ssl/certs/iirii.com:/etc/ssl/certs/iirii.com -v /etc/trojan-go:/etc/trojan-go teddysun/trojan-go
```

配置 `/etc/trojan-go/config.json` 如下

```bash
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 8443,
    "remote_addr": "127.0.0.1",
    "remote_port": 8080,
    "log_level": 0,
    "password": [
        "oo123456"
    ],
    "ssl": {
        "cert": "/etc/ssl/certs/iirii.com/fullchain.cer",
        "key": "/etc/ssl/certs/iirii.com/iirii.com.key",
        "sni": "2.server.iirii.com"
    },
    "router": {
        "enabled": true,
        "block": [
            "geoip:private"
        ],
        "geoip": "/usr/share/trojan-go/geoip.dat",
        "geosite": "/usr/share/trojan-go/geosite.dat"
    },
	 "mux": {
        "enabled": true,
        "concurrency": 8,
        "idle_timeout": 60
    }
}
```