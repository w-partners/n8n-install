#!/bin/bash

# 확인: Cloudflare API 토큰이 설정되었는지
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
  echo "❌ CLOUDFLARE_API_TOKEN 환경변수가 설정되지 않았습니다."
  echo "🔧 실행 전 아래 명령어를 먼저 입력하세요:"
  echo ""
  echo "   export CLOUDFLARE_API_TOKEN=여러분의_Cloudflare_API_토큰"
  echo ""
  exit 1
fi

# 필수 패키지 설치
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl gnupg software-properties-common apt-transport-https ca-certificates lsb-release sudo nano ufw

# Docker 설치
curl -fsSL https://get.docker.com | bash
sudo systemctl enable docker
sudo systemctl start docker
sudo docker network create n8n_network

# Node.js 설치
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Nginx 설치 및 설정
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

sudo bash -c 'cat <<EOF > /etc/nginx/sites-available/n8n
server {
    listen 80;
    server_name w.w-partners.org;

    location / {
        proxy_pass http://127.0.0.1:5678;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_cache_bypass \$http_upgrade;
        chunked_transfer_encoding off;
        proxy_buffering off;
        proxy_cache off;
    }
}
EOF'

sudo ln -s /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl restart nginx

# ddclient 설치 및 설정
sudo apt install -y ddclient

sudo bash -c "cat <<EOF > /etc/ddclient.conf
protocol=cloudflare
use=web
web=dynamicdns.park-your-domain.com/getip
ssl=yes
server=api.cloudflare.com/client/v4
login=token
password=$CLOUDFLARE_API_TOKEN
zone=w-partners.org
w.w-partners.org
daemon=300
EOF"

sudo sed -i 's/^run_daemon="false"/run_daemon="true"/' /etc/default/ddclient
sudo sed -i 's/^daemon_interval="300"/daemon_interval="300"/' /etc/default/ddclient
sudo systemctl enable ddclient
sudo systemctl restart ddclient

# n8n 실행
sudo docker run -it -d --name n8n \
  --network n8n_network \
  -p 5678:5678 \
  -e WEBHOOK_URL="https://w.w-partners.org/" \
  -e GENERIC_TIMEZONE="Asia/Seoul" \
  -e N8N_HOST="0.0.0.0" \
  -e N8N_PORT=5678 \
  -e N8N_EDITOR_BASE_URL="https://w.w-partners.org/" \
  -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
  -e NODE_ENV=production \
  -v n8n_data:/home/node/.n8n \
  --pull always \
  docker.n8n.io/n8nio/n8n
