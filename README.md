# StegoShield DevOps

> Production-grade DevOps pipeline for StegoShield —
> an AI-powered steganography detection platform for images, audio, and video.

## Project Overview
StegoShield detects hidden payloads inside images, audio, and video
files using trained deep learning models. This repo contains the full
DevOps infrastructure built around it.

## Tech Stack

### Application
- **Backend:** Python, Flask, PostgreSQL, Cloudinary
- **Frontend:** React, Vite, Tailwind CSS
- **Auth:** Firebase
- **ML Models:** PyTorch (.pth) — image, audio, video detection

### Infrastructure
- **Containerisation:** Docker, Docker Compose
- **CI/CD:** GitHub Actions
- **Cloud:** AWS (EC2, RDS, S3, ECR, EKS)
- **IaC:** Terraform
- **Orchestration:** Kubernetes, Helm
- **GitOps:** ArgoCD
- **Monitoring:** Prometheus, Grafana, Loki

## Architecture
> Full architecture diagram coming soon

## Quick Start
```bash
# 1. Clone the repo
git clone https://github.com/amyy45/stegoshield-devops.git
cd stegoshield-devops

# 2. Run setup
bash scripts/setup.sh

# 3. Configure environment
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env
# Fill in your values in both .env files

# 4. Start the backend
cd backend && source venv/bin/activate && python app.py

# 5. Verify everything is healthy
bash scripts/health_check.sh
```

## Project Structure
```
stegoshield-devops/
├── backend/          # Flask API, ML models, database
├── frontend/         # React app
├── scripts/          # Setup and health check scripts
└── CONTRIBUTING.md   # Branch strategy and commit conventions
```

## Contributing
See [CONTRIBUTING.md](./CONTRIBUTING.md) for branch strategy, commit
message format, and development workflow.