# Airflow DNS Setup

Create a DNS A record with the same FQDN used in previous steps for airflow multi partition support

Manually update your DNS A Records to point to the Public IP Address for the environment.

```bash
# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

# Set AKS cluster context for data partition 
RESOURCE_GROUP=$(az group list --query "[?contains(name, 'dp1${UNIQUE}')].name" -otsv)
AKS_NAME=$(az aks list --resource-group $RESOURCE_GROUP --query '[].{name:name}' -otsv)
az aks get-credentials -g $RESOURCE_GROUP -n $AKS_NAME 

# Get IP Address
kubectl get svc/istio-ingressgateway -n istio-system --output jsonpath='{.status.loadBalancer.ingress[0].ip}'
```
