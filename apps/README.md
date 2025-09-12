# 🚀 Flask + Redis on Kubernetes with Ingress & Let’s Encrypt

This repository deploys a **Flask application backed by Redis** on Kubernetes, fronted by **NGINX Ingress**, and secured with **Let’s Encrypt certificates** via **cert-manager + Cloudflare DNS**.

---

## 📦 Features

- **Flask + Redis App**
  - Tracks visitor count (`/`)
  - Simple key/value API (`/set` & `/get/<key>`)
  - Health endpoint (`/healthz`) for Kubernetes probes
- **Redis Backend**
  - In-cluster Redis service (ClusterIP)
- **Ingress + TLS**
  - HTTPS via Let’s Encrypt (Cloudflare DNS01 challenge)
- **Auto-scaling**
  - Horizontal Pod Autoscaler (HPA) for Flask
- **Cloudflare Integration**
  - Certificates issued via Cloudflare DNS

---

## 🛠️ Prerequisites

- Kubernetes cluster (tested on **UpCloud Kubernetes** with Cilium CNI)
- `kubectl` configured for the cluster
- `helm` (for ingress-nginx / cert-manager)
- Cloudflare account with:
  - **API token** that has DNS edit permissions
  - Your domain (e.g., `parallelservicesllc.com`) pointing to UpCloud LB

---

## 📂 Deployment Steps

### 1. Install Ingress NGINX
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace

2. Install cert-manager

helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --set installCRDs=true

3. Configure Cloudflare API Secret
Create cloudflare-secret.yaml:

apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token
  namespace: cert-manager
type: Opaque
stringData:
  api-token: <YOUR_CLOUDFLARE_API_TOKEN>

Apply:
kubectl apply -f cloudflare-secret.yaml

4. Create ClusterIssuers

Staging (safe for testing, not trusted by browsers)
Production (real trusted certs)

kubectl apply -f clusterissuer-staging.yaml
kubectl apply -f clusterissuer-prod.yaml

5. Deploy Redis + Flask App

kubectl apply -f flask-redis.yaml

This creates:

Deployment + Service for Redis

Deployment + Service for Flask


Ingress with TLS

HorizontalPodAutoscaler


6. Certificates

Two options:

Staging cert (use for testing first):

kubectl apply -f flaskredis-certificate-staging.yaml


Production cert (after staging works):

kubectl apply -f flaskredis-certificate.yaml

🌐 Access the App

HTTPS
https://flaskredis.parallelservicesllc.com/

🔎 Endpoints

/ → Visitor counter

/set → Store key/value (POST, JSON body)

/get/<key> → Retrieve value

/healthz → Health check (used by probes)

⚖️ Scaling

The HPA is configured:

Min: 2 pods

Max: 5 pods

Trigger: 70% CPU utilization

Check scaling:

kubectl get hpa



🧪 Troubleshooting

503 Service Temporarily Unavailable
→ Ingress not matching Service (check serviceName and ports)

Invalid SSL Certificate
→ Cert not issued (check kubectl describe certificate and cert-manager logs)

NXDOMAIN
→ Cloudflare DNS not pointing to UpCloud LB

Redirect (308 Permanent Redirect)
→ Ingress is forcing HTTPS. Use https:// in curl, e.g.:

curl -k -X POST https://flaskredis.parallelservicesllc.com/set \
     -H "Content-Type: application/json" \
     -d '{"key":"username","value":"sanu"}'


📝 Notes

Test with Let’s Encrypt staging before switching to production.

Certificates auto-renew via cert-manager.

Redis here is ephemeral — for production use, attach a PersistentVolumeClaim.


📜 License

MIT License © 2025


---

⚡ Do you want me to also include a **suggested repo structure** (`/app`, `/manifests`, `/d