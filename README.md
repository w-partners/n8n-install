# n8n 자동 설치 스크립트 (GCP 최적화)

Cloudflare DDNS + Docker + Nginx + n8n 설치를 한 번에 구성할 수 있는 자동 설치 스크립트입니다.

> ✅ GCP VM 기준으로 최적화되어 있으며, 환경변수로 민감 정보 입력 방식으로 안전하게 구성됩니다.

---

## 🔧 설치 방법

아래 명령어를 **GCP VM SSH 터미널**에서 복사해 실행하세요:

```bash
export CLOUDFLARE_API_TOKEN=여러분의_Cloudflare_API_토큰
curl -O https://raw.githubusercontent.com/w-partners/n8n-install/refs/heads/main/setup-n8n-env.sh
chmod +x setup-n8n-env.sh
sudo ./setup-n8n-env.sh
