#!/bin/bash

apt update; \
apt install -y docker.io nginx && \
snap install --classic certbot

mkdir -p ${CONFIG_PATH}/ghost

cat << EOF > ${CONFIG_PATH}/ghost/config.production.json
{
  "url": "https://${SITE_DOMAIN}",
  "server": {
    "port": 2368,
    "host": "0.0.0.0"
  },
  "database": {
    "client": "sqlite3",
    "connection": {
      "filename": "/var/lib/ghost/content/data/ghost.db"
    }
  },
  "mail": {
    "transport": "Direct"
  },
  "logging": {
    "transports": [
      "file",
      "stdout"
    ]
  },
  "process": "systemd",
  "paths": {
    "contentPath": "/var/lib/ghost/content"
  }
}
EOF

cat << EOF > /etc/nginx/sites-enabled/${SITE_DOMAIN}.conf
server {
    server_name  ${SITE_DOMAIN};
    access_log on;

	location / {
	        proxy_pass http://127.0.0.1:3001/;
		proxy_set_header        X-Real-IP $remote_addr;
		proxy_set_header        Host    $host;
		proxy_set_header        X-Forwarded-Proto $scheme;
	}

	listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/${SITE_DOMAIN}/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/${SITE_DOMAIN}/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

server {
    if ($host = ${SITE_DOMAIN}) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    server_name  ${SITE_DOMAIN};
    listen 80;
    return 404; # managed by Certbot


}
EOF

docker pull ghost:latest && \
docker run -d --restart always --name ${SITE_DOMAIN} \
-p 127.0.0.1:3001:2368 -v ${CONFIG_PATH}/ghost:/var/lib/ghost/content \
-v ${CONFIG_PATH}/ghost/config.production.json:/var/lib/ghost/config.production.json \
-e url=https://${SITE_DOMAIN} ghost:latest

certbot --nginx --non-interactive --agree-tos \
--domains ${SITE_DOMAIN} --email ${SITE_EMAIL} && \
systemctl reload nginx