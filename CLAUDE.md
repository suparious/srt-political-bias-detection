# CLAUDE.md - Political Bias Detection Agent Context

**Project**: AI-powered political bias analysis tool using fine-tuned BERT
**Status**: Production deployed at `https://political-bias.lab.hq.solidrust.net`
**Last Updated**: 2025-11-13
**Shaun's Golden Rule**: **No workarounds, no temporary fixes, no disabled functionality. Full solutions only.**

---

## ⚡ AGENT QUICK START

**What**: Web application that analyzes text for political bias using a fine-tuned BERT model (700K+ articles from NELA-GT-2022 dataset)
**Stack**: React + Flask + PyTorch (Transformers)
**Model**: `AhadB/bias-detector` on HuggingFace Hub (bert-base-uncased fine-tuned)
**Platform Integration**: vLLM inference service available for alternative/hybrid approach
**Deployment**: Dual-container (frontend + backend), 2 replicas each

---

## 📚 PLATFORM INTEGRATION (ChromaDB Knowledge Base)

**When working in this submodule**, you cannot access the parent srt-hq-k8s repository files. Use ChromaDB to query platform capabilities and integration patterns.

**Collection**: `srt-hq-k8s-platform-guide` (43 docs, updated 2025-11-11)

**Why This Matters for Political Bias Detection**:
This application requires:
- **Ingress with SSL** (DNS-01 Let's Encrypt) for public access
- **vLLM integration** (optional) - platform's vLLM inference service for alternative bias detection
- **Monitoring** - Prometheus metrics for model inference performance
- **Resource management** - Backend needs 1-4Gi memory for PyTorch model loading

**Query When You Need**:
- Platform ingress patterns and SSL configuration
- vLLM service endpoints and integration examples
- Prometheus monitoring setup for ML workloads
- Platform architecture and service catalog

**Example Queries**:
```
"What is the vLLM inference service endpoint?" → service-vllm-inference
"How do I configure SSL ingress with DNS-01?" → ingress-ssl-setup
"What is the platform monitoring stack?" → prometheus-metrics-api
"What is the srt-hq-k8s platform architecture?" → platform-overview
```

**How to Update ChromaDB**:
ChromaDB is accessible via MCP (Model Context Protocol) tools in the parent repo's `.claude/settings.local.json`:
- Use MCP tool functions from parent repo: `mcp__chroma__chroma_add_documents`, `mcp__chroma__chroma_update_documents`, etc.
- Collection name: `srt-hq-k8s-platform-guide`
- Update when platform capabilities change or new integration patterns emerge
- Document format: Markdown with clear IDs and metadata

**Parent Repository Location**:
- Linux: `/home/shaun/repos/srt-hq-k8s`
- WSL: `/mnt/c/Users/shaun/repos/srt-hq-k8s`
- This repo is a submodule at: `manifests/apps/political-bias-detection/`

**When NOT to Query**:
- ❌ React/Flask development (use project docs and code)
- ❌ BERT model fine-tuning (see original project README)
- ❌ Docker build process (use build-and-push.ps1)

---

## 📍 PROJECT OVERVIEW

**Purpose**: Analyze political bias in text using AI/ML (fine-tuned BERT model)

**How It Works**:
1. User submits article text via React frontend
2. Frontend sends to Flask backend API
3. Backend loads fine-tuned BERT model from HuggingFace
4. Model classifies bias (Left, Lean Left, Center, Lean Right, Right)
5. Results displayed with confidence scores

**Model Details**:
- **Base**: `bert-base-uncased` (Google BERT)
- **Fine-tuned**: `AhadB/bias-detector` on HuggingFace Hub
- **Training Data**: 700,000+ political articles from NELA-GT-2022 dataset
- **Labels**: Based on AllSides political bias ratings
- **License**: Training data not included (NELA-GT-2022 terms)

**Integration Options**:
1. **Current**: Standalone BERT model (PyTorch + Transformers)
2. **Future**: Hybrid approach with platform vLLM service for enhanced analysis

---

## 🗂️ LOCATIONS

**Repository**:
- Linux: `/home/shaun/repos/srt-political-bias-detection`
- WSL: `/mnt/c/Users/shaun/repos/srt-political-bias-detection`
- Remote: `git@github.com:suparious/srt-political-bias-detection.git`
- Public Site: `https://biascheck.xyz/` (original deployment)

**K8s Deployment**:
- Submodule: `/mnt/c/Users/shaun/repos/srt-hq-k8s/manifests/apps/political-bias-detection/`
- Namespace: `political-bias-detection`
- Production: `https://political-bias.lab.hq.solidrust.net`

**Images**:
- Frontend: `suparious/political-bias-detection-frontend:latest`
- Backend: `suparious/political-bias-detection-backend:latest`

---

## 🛠️ TECH STACK

### Frontend
- **Framework**: React 18.3.1
- **Build Tool**: react-scripts 5.0.1 (Create React App)
- **UI Library**: Chakra UI 2.8.2
- **ML Integration**: @xenova/transformers 2.17.2 (client-side ML)
- **HTTP Client**: axios 1.12.0
- **Animation**: framer-motion 11.3.24
- **Build Output**: `frontend/build/`

### Backend
- **Framework**: Flask 3.0.3
- **ML Libraries**:
  - PyTorch 2.8.0
  - Transformers 4.53.0 (HuggingFace)
- **Model**: AhadB/bias-detector (bert-base-uncased fine-tuned)
- **CORS**: Flask-Cors 4.0.1
- **Production Server**: gunicorn 23.0.0
- **Port**: 5000

### Infrastructure
- **Container**: Docker multi-stage builds
- **Frontend Server**: nginx:alpine
- **Kubernetes**: Dual deployment (frontend + backend)
- **SSL**: Let's Encrypt DNS-01 (cert-manager)
- **Ingress**: nginx-ingress
- **Monitoring**: Prometheus-ready

---

## 📁 PROJECT STRUCTURE

```
srt-political-bias-detection/
├── frontend/                    # React SPA
│   ├── src/
│   │   ├── App.js              # Main application component
│   │   ├── components/         # React components
│   │   └── index.js            # Entry point
│   ├── public/                 # Static assets
│   └── package.json            # npm dependencies
│
├── backend/                     # Flask API
│   ├── app.py                  # Flask application
│   └── requirements.txt        # Python dependencies
│
├── training-script/             # Model training (reference only)
│   └── bias_data_model_script.py
│
├── k8s/                        # Kubernetes manifests (in submodule)
│   ├── 01-namespace.yaml
│   ├── 02-deployment-backend.yaml
│   ├── 03-deployment-frontend.yaml
│   ├── 04-service-backend.yaml
│   ├── 05-service-frontend.yaml
│   └── 06-ingress.yaml
│
├── Dockerfile.frontend         # Frontend container build
├── Dockerfile.backend          # Backend container build
├── nginx.conf                  # Frontend nginx configuration
├── build-and-push.ps1         # Image build automation
├── deploy.ps1                 # K8s deployment automation
└── README.md                  # Original project docs
```

---

## 🚀 DEVELOPMENT WORKFLOW

### Local Development

**Frontend**:
```bash
cd frontend
npm install
npm start
# Access: http://localhost:3000
```

**Backend**:
```bash
cd backend
pip install -r requirements.txt
python app.py
# Access: http://localhost:5000
```

### Docker Testing

**Build Images**:
```powershell
# Both images
.\build-and-push.ps1

# Frontend only
.\build-and-push.ps1 -Frontend

# Backend only
.\build-and-push.ps1 -Backend
```

**Test Locally**:
```bash
# Frontend
docker run -p 8080:80 suparious/political-bias-detection-frontend:latest

# Backend
docker run -p 5000:5000 suparious/political-bias-detection-backend:latest
```

### Production Deployment

**Deploy to Kubernetes**:
```powershell
# Deploy only
.\deploy.ps1

# Build, push, and deploy
.\deploy.ps1 -Build -Push

# Uninstall
.\deploy.ps1 -Uninstall
```

---

## 📋 DEPLOYMENT

### Quick Deploy
```powershell
cd /mnt/c/Users/shaun/repos/srt-hq-k8s/manifests/apps/political-bias-detection
.\deploy.ps1 -Build -Push
```

### Manual Deployment
```bash
# Build and push images
.\build-and-push.ps1 -Login -Push

# Apply manifests
kubectl apply -f k8s/

# Monitor rollout
kubectl rollout status deployment/political-bias-detection-frontend -n political-bias-detection
kubectl rollout status deployment/political-bias-detection-backend -n political-bias-detection

# Verify
kubectl get all,certificate,ingress -n political-bias-detection
```

---

## 🔧 COMMON TASKS

### View Logs
```bash
# Frontend logs
kubectl logs -n political-bias-detection -l app=political-bias-detection-frontend -f

# Backend logs
kubectl logs -n political-bias-detection -l app=political-bias-detection-backend -f

# All logs
kubectl logs -n political-bias-detection --all-containers=true -f
```

### Update Deployment
```bash
# Restart frontend
kubectl rollout restart deployment/political-bias-detection-frontend -n political-bias-detection

# Restart backend
kubectl rollout restart deployment/political-bias-detection-backend -n political-bias-detection

# Update image
kubectl set image deployment/political-bias-detection-backend \
  backend=suparious/political-bias-detection-backend:latest \
  -n political-bias-detection
```

### Troubleshooting
```bash
# Check pod status
kubectl get pods -n political-bias-detection

# Describe pod
kubectl describe pod <pod-name> -n political-bias-detection

# Check certificate
kubectl get certificate -n political-bias-detection
kubectl describe certificate political-bias-detection-tls -n political-bias-detection

# Check ingress
kubectl get ingress -n political-bias-detection
kubectl describe ingress political-bias-detection -n political-bias-detection

# Test backend health
kubectl port-forward -n political-bias-detection svc/political-bias-detection-backend 5000:5000
curl http://localhost:5000/health
```

### Model Management
```bash
# Check model cache size
kubectl exec -n political-bias-detection <backend-pod> -- du -sh /app/model_cache

# Clear model cache (forces re-download)
kubectl exec -n political-bias-detection <backend-pod> -- rm -rf /app/model_cache/*
kubectl rollout restart deployment/political-bias-detection-backend -n political-bias-detection
```

---

## 🎯 USER PREFERENCES (CRITICAL)

**Context**: Cloud engineer learning K8s, building production-quality platform

**Solutions Must Be**:
- ✅ Complete, immediately deployable, production-ready
- ✅ Full manifests (not patches), reproducible
- ✅ No workarounds, temp files, disabled features, cruft

**Workflow**:
- Run PowerShell/Makefile directly (don't ask permission)
- User monitors changes in real-time, stops/corrects if needed
- Validate end-to-end
- Document in appropriate location

**Technical Standards**:
- Production-grade error handling
- Proper resource limits
- Health checks and probes
- SSL everywhere
- Monitoring integration

---

## 💡 KEY DECISIONS

### Why Dual Deployment?
**Decision**: Separate frontend and backend containers
**Rationale**:
- Independent scaling (frontend = 2 replicas @ 128Mi, backend = 2 replicas @ 4Gi)
- Frontend stateless (nginx), backend stateful (model cache)
- Easier troubleshooting and updates

### Why Model Cache Volume?
**Decision**: emptyDir volume for model cache (5Gi limit)
**Rationale**:
- First startup downloads ~500MB BERT model from HuggingFace
- Subsequent startups use cached model (faster pod restarts)
- emptyDir persists across container restarts but not pod rescheduling
- Alternative: PersistentVolume for cross-pod caching (future optimization)

### Why Backend Health Check Delay?
**Decision**: 60s initialDelaySeconds for backend liveness probe
**Rationale**:
- Model loading takes 30-60s on first startup (HuggingFace download)
- Prevents premature pod termination during initialization
- ReadinessProbe at 30s allows faster traffic routing once ready

### Why nginx Proxy for API?
**Decision**: Frontend nginx proxies `/api/*` to backend service
**Rationale**:
- Avoids CORS complexity (same-origin requests)
- Centralizes routing at frontend ingress
- Simplifies client-side API calls (relative paths)

### vLLM Integration (Future)
**Decision**: Keep BERT model, add optional vLLM endpoint
**Rationale**:
- Current: Fast, specialized bias detection (BERT fine-tuned)
- Future: Hybrid approach with vLLM for explainability/reasoning
- Platform vLLM service already deployed, can leverage for enhanced features

---

## 🔍 VALIDATION

### Post-Deployment Checks
```bash
# 1. All pods running
kubectl get pods -n political-bias-detection
# Expected: 4 pods (2 frontend, 2 backend) - all Running

# 2. Services created
kubectl get svc -n political-bias-detection
# Expected: frontend ClusterIP, backend ClusterIP

# 3. Ingress configured
kubectl get ingress -n political-bias-detection
# Expected: ADDRESS = 172.20.75.200

# 4. Certificate issued
kubectl get certificate -n political-bias-detection
# Expected: READY = True (may take 1-2 minutes)

# 5. Application accessible
curl -k https://political-bias.lab.hq.solidrust.net
# Expected: HTTP 200, HTML response

# 6. Backend health
curl http://<backend-pod-ip>:5000/health
# Expected: {"status": "healthy"}
```

### Browser Testing
1. Open `https://political-bias.lab.hq.solidrust.net`
2. Verify green padlock (valid SSL)
3. Submit test article text
4. Verify bias analysis response
5. Check browser console for errors

### Performance Testing
```bash
# Backend response time
kubectl exec -n political-bias-detection <backend-pod> -- \
  curl -o /dev/null -s -w '%{time_total}\n' http://localhost:5000/health

# Pod resource usage
kubectl top pods -n political-bias-detection
```

---

## 🎓 AGENT SUCCESS CRITERIA

**Onboarding Complete When**:
- ✅ Git submodule added to srt-hq-k8s
- ✅ All deployment files created (Dockerfiles, K8s manifests, scripts, docs)
- ✅ Parent repo configuration updated (workspace, sync scripts, CLAUDE.md)
- ✅ Images build successfully
- ✅ Images pushed to Docker Hub
- ✅ K8s deployment succeeds (4 pods running)
- ✅ Certificate issued (READY=True)
- ✅ Application accessible via HTTPS with green padlock
- ✅ Bias detection fully functional

**Future Enhancements**:
- vLLM integration for hybrid bias detection
- Prometheus metrics for model inference performance
- Rate limiting for API endpoints
- Model cache optimization (PersistentVolume)
- A/B testing framework (BERT vs vLLM)

---

## 📅 CHANGE HISTORY

### 2025-11-13 - Initial Onboarding
- Added to srt-hq-k8s as git submodule
- Created K8s deployment infrastructure:
  - Dockerfile.frontend (React + nginx)
  - Dockerfile.backend (Flask + PyTorch)
  - K8s manifests (namespace, deployments, services, ingress)
  - PowerShell automation (build-and-push.ps1, deploy.ps1)
- Platform integration via ChromaDB knowledge base
- Comprehensive agent context documentation
- Deployed to `https://political-bias.lab.hq.solidrust.net`

---

**Maintained By**: Shaun Prince
**Used With**: Claude Code (Sonnet 4.5)
**Model**: AhadB/bias-detector (HuggingFace)
**Dataset**: NELA-GT-2022 (Gruppi et al., 2023)
