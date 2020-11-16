# Helm Installation Instructions

__CLI Login__

Login to Azure CLI using the OSDU Environment Service Principal.

```bash
# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
```

__Helm Values__

Create the helm chart values file necessary to install charts.

- Download [helm-config.yaml](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/raw/master/charts/helm-config.yaml), which will configure OSDU on Azure.

  `wget https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/raw/master/charts/helm-config.yaml -O config.yaml`

- Edit the newly downloaded [config.yaml](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/raw/master/charts/helm-config.yaml) and fill out the required sections `azure`, `ingress` and `istio`.



```bash
# Setup Variables
ADMIN_EMAIL="<your_cert_admin>"     # ie: admin@email.com
DNS_HOST="<your_ingress_hostname>"  # ie: osdu.contoso.com

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > config.yaml << EOF
# This file contains the essential configs for the osdu on azure helm chart
global:

  # Service(s) Replica Count
  replicaCount: 2

  ################################################################################
  # Specify the azure environment specific values
  #
  azure:
    tenant: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/tenant-id --query value -otsv)
    subscription: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/subscription-id --query value -otsv)
    resourcegroup: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-rg
    identity: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-cr --query value -otsv)-osdu-identity
    identity_id: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/osdu-identity-id --query value -otsv)
    keyvault: $ENV_VAULT
    appid: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)

  ################################################################################
  # Specify the Ingress Settings
  # DNS Hostname for thet Gateway
  # Admin Email Address to be notified for SSL expirations
  # Lets Encrypt SSL Server
  #     https://acme-staging-v02.api.letsencrypt.org/directory  --> Staging Server
  #     https://acme-v02.api.letsencrypt.org/directory --> Production Server
  #
  ingress:
    hostname: $DNS_HOST
    admin: $ADMIN_EMAIL
    sslServer: https://acme-v02.api.letsencrypt.org/directory  # Production

  ################################################################################
  # Specify the istio specific values
  # based64 encoded username and password
  #
  istio:
    username: $(az keyvault secret show --id https://${COMMON_VAULT}.vault.azure.net/secrets/istio-username --query value -otsv)
    password: $(az keyvault secret show --id https://${COMMON_VAULT}.vault.azure.net/secrets/istio-password --query value -otsv)
EOF
```

__Clone Service Repositories__

Manually ensure all the services have been cloned to your machine.

```bash
SRC_DIR="<ROOT_PATH_TO_SOURCE>" #  $HOME/source/osdu/osdu-gitlab

git clone https://community.opengroup.org/osdu/platform/system/partition.git $SRC_DIR/partition
git clone https://community.opengroup.org/osdu/platform/security-and-compliance/entitlements-azure.git $SRC_DIR/entitlements-azure
git clone https://community.opengroup.org/osdu/platform/security-and-compliance/legal.git $SRC_DIR/legal
git clone https://community.opengroup.org/osdu/platform/system/storage.git $SRC_DIR/storage
git clone https://community.opengroup.org/osdu/platform/system/indexer-queue.git $SRC_DIR/indexer-queue
git clone https://community.opengroup.org/osdu/platform/system/indexer-service.git $SRC_DIR/indexer-service
git clone https://community.opengroup.org/osdu/platform/system/search-service.git $SRC_DIR/search-service
```


__Kubernetes API Access__

> Optional

It can often be helpful to be able to retrieve the cluster context and execute queries directly against the Kubernetes API.

```bash
BASE_NAME=$(az group list --query "[?contains(name, 'sr${UNIQUE}')].name" -otsv |grep -v MC | rev | cut -c 3- | rev)

az aks get-credentials -n ${BASE_NAME}aks -g ${BASE_NAME}rg
```


__Helm Manifests__

Manually extract the manifests from the helm charts to your Flux Repo Directory.

```bash
INFRA_SRC="$SRC_DIR/infra-azure-provisioning"
FLUX_SRC="$INFRA_SRC/k8-gitops-manifests"
BRANCH="master"
TAG="latest"

# Setup the Flux Directory
mkdir -p ${FLUX_SRC}/providers/azure/hld-registry

# Extract manifests from the common osdu chart.
helm template osdu-flux ${INFRA_SRC}/charts/osdu-common -f ${INFRA_SRC}/charts/config.yaml > ${FLUX_SRC}/providers/azure/hld-registry/osdu-common.yaml

# Commit and Checkin to Deploy
(cd $FLUX_SRC \
  && git switch -c $UNIQUE \
  && git add ${FLUX_SRC}/providers/azure/hld-registry/osdu-common.yaml \
  && git commit -m "Initialize Common Chart" \
  && git push origin $UNIQUE)


# Extract manifests from the istio charts.
helm template osdu-flux ${INFRA_SRC}/charts/osdu-istio -f ${INFRA_SRC}/charts/config.yaml > ${FLUX_SRC}/providers/azure/hld-registry/osdu-istio.yaml

helm template osdu-flux ${INFRA_SRC}/charts/osdu-istio-auth -f ${INFRA_SRC}/charts/config.yaml > ${FLUX_SRC}/providers/azure/hld-registry/osdu-istio-auth.yaml

# Commit and Checkin to Deploy
(cd $FLUX_SRC \
  && git switch $UNIQUE \
  && git add ${FLUX_SRC}/providers/azure/hld-registry/osdu-istio.yaml \
  && git add ${FLUX_SRC}/providers/azure/hld-registry/osdu-istio-auth.yaml \
  && git commit -m "Initialize Istio Auth Chart" \
  && git push origin $UNIQUE)


# Extract manifests from the airflow charts.
pip3 install -U PyYAML

helm template airflow ${INFRA_SRC}/charts/airflow -f ${INFRA_SRC}/charts/config.yaml | python3 ${INFRA_SRC}/charts/airflow/scripts/add-namespace.py > ${FLUX_SRC}/providers/azure/hld-registry/airflow.yaml

# Commit and Checkin to Deploy
(cd $FLUX_SRC \
  && git switch $UNIQUE \
  && git add ${FLUX_SRC}/providers/azure/hld-registry/airflow.yaml \
  && git commit -m "Initialize Airflow Chart" \
  && git push origin $UNIQUE)



# Extract manifests from each service chart.
for SERVICE in partition entitlements-azure legal storage indexer-queue indexer-service search-service;
do
  helm template $SERVICE ${SRC_DIR}/$SERVICE/devops/azure/chart --set image.branch=$BRANCH --set image.tag=$TAG > ${FLUX_SRC}/providers/azure/hld-registry/$SERVICE.yaml
done

# Commit and Checkin to Deploy
(cd $FLUX_SRC \
  && git switch $UNIQUE \
  && git add ${FLUX_SRC}/providers/azure/hld-registry/*.yaml \
  && git commit -m "Adding OSDU Services" \
  && git push origin $UNIQUE)
```
