## Usage

Install to Staging
```bash
helm install nodejs-app ./charts/nodejs-app -f environments/staging/values.yaml
```

 Install to Production
```bash
helm install nodejs-app ./charts/nodejs-app -f environments/production/values.yaml
```

 Upgrade deployment
```bash
helm upgrade nodejs-app ./charts/nodejs-app -f environments/production/values.yaml
```

 Key Features

- Multi-environment support** — staging and production values separated
- Parameterized templates** — single chart, multiple deployment targets
- Health probes** — liveness and readiness configured on `/health`
- Resource limits** — CPU and memory constraints per environment
- AKS ready** — integrates with [azure-cicd-pipeline](https://github.com/Lokesh0423/azure-cicd-pipeline) and [terraform-azure-infra](https://github.com/Lokesh0423/terraform-azure-infra)

 Related

- [azure-cicd-pipeline](https://github.com/Lokesh0423/azure-cicd-pipeline) — CI/CD pipeline pushing images to ACR
- [terraform-azure-infra](https://github.com/Lokesh0423/terraform-azure-infra) — AKS cluster provisioning
