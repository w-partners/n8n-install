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
```

---

## 📦 설치 구성 요소

- [x] **Docker** 및 Docker Network 구성
- [x] **Node.js 18** 버전 설치
- [x] **n8n** Docker 컨테이너 실행
- [x] **Nginx** Reverse Proxy (포트 80 → 5678)
- [x] **ddclient** (Cloudflare API 연동으로 DDNS 자동 IP 갱신)

---

## 🌐 도메인 구성 예시

- `w.w-partners.org` ← `n8n`이 접근되는 주소
- Cloudflare 계정에서 서브도메인 생성 후 사용

---

## 🔐 보안

- API 토큰은 `.sh` 내에 저장되지 않습니다
- 실행 시 `환경변수`로만 전달됨
- GitHub 퍼블릭 저장소로도 안전하게 사용 가능

---

## 🧑‍💻 만든이

- **w-partners** 기술 자동화 프로젝트
- 문의: [whitegun.suh@gmail.com](mailto:whitegun.suh@gmail.com)
