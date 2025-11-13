# Political Bias Detection - Kubernetes Deployment

AI-powered political bias analysis using fine-tuned BERT model. Deployed as dual-container application (React frontend + Flask backend) on srt-hq-k8s platform.

**Production**: `https://political-bias.lab.hq.solidrust.net`

---

## 🚀 Quick Start

### Deploy to Kubernetes
```powershell
# From submodule directory
cd /mnt/c/Users/shaun/repos/srt-hq-k8s/manifests/apps/political-bias-detection

# Build, push, and deploy
.\deploy.ps1 -Build -Push

# Deploy only (using existing images)
.\deploy.ps1
```

### Local Development
```bash
# Frontend
cd frontend && npm install && npm start
# → http://localhost:3000

# Backend
cd backend && pip install -r requirements.txt && python app.py
# → http://localhost:5000
```

### Docker Testing
```bash
# Build images
.\build-and-push.ps1

# Test frontend
docker run -p 8080:80 suparious/political-bias-detection-frontend:latest

# Test backend
docker run -p 5000:5000 suparious/political-bias-detection-backend:latest
```

---

## 🔧 Maintenance

### View Logs
```bash
# Frontend
kubectl logs -n political-bias-detection -l app=political-bias-detection-frontend -f

# Backend
kubectl logs -n political-bias-detection -l app=political-bias-detection-backend -f
```

### Update Deployment
```bash
# Rebuild and redeploy
.\deploy.ps1 -Build -Push

# Restart without rebuild
kubectl rollout restart deployment/political-bias-detection-frontend -n political-bias-detection
kubectl rollout restart deployment/political-bias-detection-backend -n political-bias-detection
```

### Troubleshooting
```bash
# Check status
kubectl get all,certificate,ingress -n political-bias-detection

# Check certificate (may take 1-2 minutes)
kubectl get certificate -n political-bias-detection

# Describe pod issues
kubectl describe pod <pod-name> -n political-bias-detection

# Test backend health
kubectl port-forward -n political-bias-detection svc/political-bias-detection-backend 5000:5000
curl http://localhost:5000/health
```

### Uninstall
```powershell
.\deploy.ps1 -Uninstall
```

---

## 🏗️ Architecture

### Tech Stack
- **Frontend**: React 18 + Chakra UI + nginx
- **Backend**: Flask 3 + PyTorch 2.8 + Transformers 4.53
- **Model**: AhadB/bias-detector (bert-base-uncased fine-tuned on 700K+ articles)
- **Infrastructure**: Kubernetes, Let's Encrypt SSL, nginx-ingress

### Resources
- **Frontend**: 2 replicas @ 100m CPU / 128Mi memory
- **Backend**: 2 replicas @ 500m-2000m CPU / 1-4Gi memory
- **Model Cache**: 5Gi emptyDir volume (per backend pod)

### Networking
- **Ingress**: `https://political-bias.lab.hq.solidrust.net` → frontend service
- **API Proxy**: nginx proxies `/api/*` to backend service (avoids CORS)
- **SSL**: Let's Encrypt DNS-01 via cert-manager
- **Services**: ClusterIP (frontend:80, backend:5000)

---

## 📁 Files Overview

### Docker
- `Dockerfile.frontend` - React SPA with nginx (multi-stage)
- `Dockerfile.backend` - Flask API with PyTorch
- `nginx.conf` - Frontend server config (SPA routing + API proxy)
- `.dockerignore` - Build exclusions

### Kubernetes Manifests (`k8s/`)
- `01-namespace.yaml` - political-bias-detection namespace
- `02-deployment-backend.yaml` - Flask backend (2 replicas, model cache)
- `03-deployment-frontend.yaml` - React frontend (2 replicas)
- `04-service-backend.yaml` - Backend ClusterIP service
- `05-service-frontend.yaml` - Frontend ClusterIP service
- `06-ingress.yaml` - HTTPS ingress with cert-manager

### Automation
- `build-and-push.ps1` - Build and push Docker images
- `deploy.ps1` - Deploy to Kubernetes

### Documentation
- `CLAUDE.md` - Comprehensive agent context
- `README-K8S.md` - This file (deployment guide)
- `README.md` - Original project documentation

---

## 💡 Key Features

- **AI Bias Detection**: Fine-tuned BERT model (700K+ training articles)
- **Bias Categories**: Left, Lean Left, Center, Lean Right, Right
- **Training Data**: NELA-GT-2022 dataset
- **Labels**: Based on AllSides political bias ratings
- **Model Source**: HuggingFace Hub (AhadB/bias-detector)
- **Production Ready**: HA deployment, health checks, SSL, monitoring

---

## 🔗 Useful Commands

```bash
# Status
kubectl get all,certificate,ingress -n political-bias-detection

# Logs
kubectl logs -n political-bias-detection -l app=political-bias-detection-frontend -f
kubectl logs -n political-bias-detection -l app=political-bias-detection-backend -f

# Restart
kubectl rollout restart deployment/political-bias-detection-frontend -n political-bias-detection
kubectl rollout restart deployment/political-bias-detection-backend -n political-bias-detection

# Scale
kubectl scale deployment/political-bias-detection-backend --replicas=3 -n political-bias-detection

# Port Forward
kubectl port-forward -n political-bias-detection svc/political-bias-detection-frontend 8080:80
kubectl port-forward -n political-bias-detection svc/political-bias-detection-backend 5000:5000

# Resource Usage
kubectl top pods -n political-bias-detection
```

---

## 🌐 Links

- **Production**: https://political-bias.lab.hq.solidrust.net
- **Original Site**: https://biascheck.xyz/
- **Docker Hub**:
  - https://hub.docker.com/r/suparious/political-bias-detection-frontend
  - https://hub.docker.com/r/suparious/political-bias-detection-backend
- **Model**: https://huggingface.co/AhadB/bias-detector
- **Dataset**: NELA-GT-2022 (Gruppi et al., 2023)
- **GitHub**: https://github.com/suparious/srt-political-bias-detection

---

**Last Updated**: 2025-11-13
**Maintained By**: Shaun Prince
**Platform**: srt-hq-k8s (Talos Kubernetes)
