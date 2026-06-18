k8s-helm-charts

Production-style Helm charts for deploying a Node.js application to Azure Kubernetes Service (AKS) across staging and production environments.

![Helm](https://img.shields.io/badge/Helm-3.x-0F1689?logo=helm&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28+-326CE5?logo=kubernetes&logoColor=white)
![Azure AKS](https://img.shields.io/badge/Azure-AKS-0078D4?logo=microsoftazure&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

What this repo does

* Parameterized Node.js app deployment to AKS using a single chart with separate staging and production values files.
* Reusable Helm templates for Deployment, Service, Ingress, ConfigMap, and HPA.
* Liveness and readiness probes wired to /health for safe rolling updates.
* Resource requests and limits configured per environment.
* Helper templates for consistent labels and naming across resources.

 Architecture

\`\`\`mermaid
flowchart LR
    Dev[Developer or CI Pipeline] -->|helm upgrade install| Helm[Helm CLI]
    Helm -->|environments/staging/values.yaml| AKS_S[AKS Staging Namespace]
    Helm -->|environments/production/values.yaml| AKS_P[AKS Production Namespace]
    AKS_S --> Pods_S[Deployment + Service + Ingress + HPA]
    AKS_P --> Pods_P[Deployment + Service + Ingress + HPA]
    AKS_S -.-> Mon[Azure Monitor]
    AKS_P -.-> Mon
\`\`\`

## Repo structure

\`\`\`
k8s-helm-charts/
├── charts/
│   └── nodejs-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── _helpers.tpl
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── ingress.yaml
│           ├── configmap.yaml
│           ├── hpa.yaml
│           └── NOTES.txt
├── environments/
│   ├── staging/
│   │   └── values.yaml
│   └── production/
│       └── values.yaml
└── README.md
\`\`\`

 Prerequisites

* Kubernetes cluster (AKS, or Minikube for local testing)
* Helm 3.x
* kubectl configured with the right cluster context
* Azure CLI if deploying to AKS

 Quick start

\`\`\`bash
git clone https://github.com/Lokesh0423/k8s-helm-charts.git
cd k8s-helm-charts
\`\`\`

Lint the chart:

\`\`\`bash
helm lint charts/nodejs-app
\`\`\`

Install to staging:

\`\`\`bash
helm upgrade --install nodejs-app charts/nodejs-app \
  -f environments/staging/values.yaml \
  --namespace staging --create-namespace
\`\`\`

Install to production:

\`\`\`bash
helm upgrade --install nodejs-app charts/nodejs-app \
  -f environments/production/values.yaml \
  --namespace production --create-namespace
\`\`\`

Key values

| Key | Staging | Production |
|-----|---------|------------|
| replicaCount | 1 | 3 |
| service.type | ClusterIP | LoadBalancer |
| resources.requests.cpu | 100m | 250m |
| resources.requests.memory | 32Mi | 64Mi |
| resources.limits.cpu | 250m | 500m |
| resources.limits.memory | 64Mi | 128Mi |

Health probes

\`\`\`yaml
livenessProbe:
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 30
  periodSeconds: 10
readinessProbe:
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 5
  periodSeconds: 5
\`\`\`

 Verifying a deployment

\`\`\`bash
kubectl get pods -n staging
kubectl get svc,ingress -n staging
helm status nodejs-app -n staging
helm get values nodejs-app -n staging
\`\`\`

 CI/CD integration

These charts plug into the pipeline in [azure-cicd-pipeline](https://github.com/Lokesh0423/azure-cicd-pipeline). The pipeline builds the Docker image, pushes to ACR, then runs helm upgrade against AKS with the right values file per environment.

outcomes 

* Templating tradeoffs between flexibility and readability inside _helpers.tpl.
* Setting realistic resource requests vs limits to avoid OOMKills under load.
* Using helm template and --dry-run to debug rendering before applying to a live cluster.
* Structuring values files so staging and production share sensible defaults without drift.
* How probes interact with rolling updates and why initialDelaySeconds matters.

 Related repos

* [azure-cicd-pipeline](https://github.com/Lokesh0423/azure-cicd-pipeline): Azure DevOps pipeline building Docker images, pushing to ACR, and deploying to AKS.
* [terraform-azure-infra](https://github.com/Lokesh0423/terraform-azure-infra): AKS, VNet, and Azure Monitor provisioned via Terraform.
* [nodejs-k8s-minikube-app](https://github.com/Lokesh0423/nodejs-k8s-minikube-app): The Node.js app this chart deploys, with Secrets, ConfigMaps, and GitHub Actions CI/CD.

Author 
Lokesh Kumar Gaddala
DevOps and Cloud Engineer based in Berlin
[LinkedIn](https://linkedin.com/in/lokesh-kumar-gaddala) | [GitHub](https://github.com/Lokesh0423)

