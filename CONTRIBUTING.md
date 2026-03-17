# Contributing to StegoShield

## Branch Strategy

This project follows GitFlow Lite:

| Branch | Purpose |
|--------|---------|
| `main` | Production-ready code only |
| `dev` | Integration branch — all features merge here first |
| `feature/xxx` | New features, branched from `dev` |
| `fix/xxx` | Bug fixes, branched from `dev` |
| `chore/xxx` | Docs, config, scripts — no app logic |

## Branch Naming Convention
```
feature/docker-setup
feature/kubernetes-deploy
fix/database-connection
fix/cloudinary-upload
chore/update-readme
chore/add-health-check
```

## Workflow
```bash
# 1. Always branch from dev
git checkout dev
git pull origin dev
git checkout -b feature/your-feature-name

# 2. Make your changes and commit
git add .
git commit -m "feat: describe what you did"

# 3. Push your branch
git push origin feature/your-feature-name

# 4. Open a PR: feature/xxx → dev
# 5. Only merge dev → main at stable milestones
```

## Commit Message Format
```
type: short description
```

| Type | When to use |
|------|-------------|
| `feat` | New feature or script |
| `fix` | Bug fix |
| `chore` | Config, docs, tooling |
| `refactor` | Code restructure, no behavior change |
| `ci` | GitHub Actions, pipelines |
| `docker` | Dockerfile, docker-compose changes |

**Examples:**
```
feat: add Dockerfile for backend
fix: resolve neon database connection timeout
fix: fix cloudinary upload path for video files
chore: update .env.example with firebase variables
refactor: move scripts to scripts/ folder
ci: add GitHub Actions workflow for linting
docker: add multi-stage build to reduce image size
```

## Rules

- Never commit directly to `main`
- Never commit `.env` or `firebase_config.json`
- Always run `bash scripts/health_check.sh` before merging to `dev`
- Keep `backend/models/*.pth` out of git — too large