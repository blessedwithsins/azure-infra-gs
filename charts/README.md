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
Create the helm chart values file necessary to install airflow charts.

- Download [helm-config.yaml](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/raw/master/charts/airflow/helm-config.yaml), which will configure OSDU on Azure.

  `wget https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/raw/master/charts/airflow/helm-config.yaml -O config_airflow.yaml`

- Edit the newly downloaded [config_airflow.yaml](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/raw/master/charts/airflow/helm-config.yaml) and fill out the required sections `externalDatabase` and `externalRedis`.



```bash
# Setup Variables
BRANCH="master"
TAG="latest"
DNS_HOST="<your_ingress_hostname>"  # ie: osdu.contoso.com

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

# Translate Values File
cat > config_airflow.yaml << EOF
################################################################################
# Specify the azure environment specific values
#
appinsightstatsd:
  aadpodidbinding: "osdu-identity"

################################################################################
# Specify any optional override values
#
image:
  repository: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/container-registry --query value -otsv).azurecr.io
  branch: $BRANCH
  tag: $TAG

airflowLogin:
  name: admin

################################################################################
# Specify any custom configs/environment values
#
customConfig:
  rbac:
    createUser: "True"

################################################################################
# Specify pgbouncer configuration
#
pgbouncer:
  enabled: true
  port: 6543
  max_client_connections: 3000
  airflowdb:
    name: airflow
    host: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg.postgres.database.azure.com
    port: 5432
    pool_size: 100
    user:  osdu_admin@$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg
    passwordSecret: "postgres"
    passwordSecretKey: "postgres-password"

################################################################################
# Specify the airflow configuration
#
airflow:

  ###################################
  # Kubernetes - Ingress Configs
  ###################################
  ingress:
    enabled: false                  #<-- Set this enabled to true for Admin UI
    web:
      annotations:
        kubernetes.io/ingress.class: azure/application-gateway
        appgw.ingress.kubernetes.io/request-timeout: "300"
        appgw.ingress.kubernetes.io/connection-draining: "true"
        appgw.ingress.kubernetes.io/connection-draining-timeout: "30"
        cert-manager.io/cluster-issuer: letsencrypt
        cert-manager.io/acme-challenge-type: http01
      path: "/airflow"
      host: $DNS_HOST
      livenessPath: "/airflow/health"
      tls:
        enabled: true
        secretName: osdu-certificate
      precedingPaths:
        - path: "/airflow/*"
          serviceName: airflow-web
          servicePort: 8080

  ###################################
  # Database - External Database
  ###################################
  postgresql:
    enabled: false
  externalDatabase:
    type: postgres
    ## Azure PostgreSQL Database host or pgbouncer host (if pgbouncer is enabled)
    host: airflow-pgbouncer.osdu.svc.cluster.local         
    ## Azure PostgreSQL Database username, formatted as {username}@{hostname}
    user: osdu_admin@$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-pg
    passwordSecret: "postgres"
    passwordSecretKey: "postgres-password"
    port: 6543
    database: airflow
    database: airflow

  ###################################
  # Database - External Redis
  ###################################
  redis:
    enabled: false
  externalRedis:
    ## Azure Redis Cache host
    host: $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/base-name-sr --query value -otsv)-cache.redis.cache.windows.net
    port: 6380
    passwordSecret: "redis"
    passwordSecretKey: "redis-password"

  ###################################
  # Airflow - DAGs Configs
  ###################################
  dags:
    installRequirements: true
    persistence:
      enabled: true
      existingClaim: airflowdagpvc
      subPath: "dags"

  ###################################
  # Airflow - WebUI Configs
  ###################################
  web:
    podLabels:
      aadpodidbinding: "osdu-identity"
    baseUrl: "http://localhost/airflow"

  ###################################
  # Airflow - Worker Configs
  ###################################
  workers:
    podLabels:
      aadpodidbinding: "osdu-identity"
    autoscaling:
      enabled: true
      ## minReplicas is picked from Values.workers.replicas and default value is 1
      maxReplicas: 3
      metrics:
      - type: Resource
        resource:
          name: memory
          target:
            type: Utilization
            averageUtilization: 50
    resources:
      requests:
        memory: "512Mi"

  ###################################
  # Airflow - Flower Configs
  ###################################
  flower:
    enabled: false

  ###################################
  # Airflow - Scheduler Configs
  ###################################
  scheduler:
    podLabels:
      aadpodidbinding: "osdu-identity"
    variables: |
      {}

  ###################################
  # Airflow - Common Configs
  ###################################
  airflow:
    image:
      repository: apache/airflow
      tag: 1.10.12-python3.6
      pullPolicy: IfNotPresent
      pullSecret: ""
    config:
      AIRFLOW__SCHEDULER__STATSD_ON: "True"
      AIRFLOW__SCHEDULER__STATSD_HOST: "appinsights-statsd"
      AIRFLOW__SCHEDULER__STATSD_PORT: 8125
      AIRFLOW__SCHEDULER__STATSD_PREFIX: "osdu_airflow"
      AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION: "False"
      ## Enable for Debug purpose
      AIRFLOW__WEBSERVER__EXPOSE_CONFIG: "False"
      AIRFLOW__WEBSERVER__AUTHENTICATE: "True"
      AIRFLOW__WEBSERVER__AUTH_BACKEND: "airflow.contrib.auth.backends.password_auth"
      AIRFLOW__WEBSERVER__RBAC: "True"
      AIRFLOW__API__AUTH_BACKEND: "airflow.contrib.auth.backends.password_auth"
      AIRFLOW__CORE__REMOTE_LOGGING: "True"
      AIRFLOW__CORE__REMOTE_LOG_CONN_ID: "az_log"
      AIRFLOW__CORE__REMOTE_BASE_LOG_FOLDER: "wasb-airflowlog"
      AIRFLOW__CORE__LOGGING_CONFIG_CLASS: "log_config.DEFAULT_LOGGING_CONFIG"
      AIRFLOW__CORE__LOG_FILENAME_TEMPLATE: "{{ run_id }}/{{ ti.dag_id }}/{{ ti.task_id }}/{{ ts }}/{% if 'correlation_id' in dag_run.conf %}{{ dag_run.conf['correlation_id'] }}{% else %}None{% endif %}/{{ try_number }}.log"
      AIRFLOW__CELERY__SSL_ACTIVE: "True"
      AIRFLOW__WEBSERVER__ENABLE_PROXY_FIX: "True"
      AIRFLOW__CORE__PLUGINS_FOLDER: "/opt/airflow/plugins"
      AIRFLOW__SCHEDULER__DAG_DIR_LIST_INTERVAL: 60
      AIRFLOW__CORE__LOGGING_LEVEL: DEBUG
      AIRFLOW_VAR_CORE__CONFIG__DATALOAD_CONFIG_PATH: "/opt/airflow/dags/configs/dataload.ini"
      AIRFLOW_VAR_CORE__SERVICE__SCHEMA__URL: "http://schema-service.osdu.svc.cluster.local/api/schema-service/v1/schema"
      AIRFLOW_VAR_CORE__SERVICE__SEARCH__URL: "http://search-service.osdu.svc.cluster.local/api/search/v2/query"
      AIRFLOW_VAR_CORE__SERVICE__STORAGE__URL: "http://storage.osdu.svc.cluster.local/api/storage/v2/records"
      AIRFLOW_VAR_CORE__SERVICE__FILE__HOST: "http://file.osdu.svc.cluster.local/api/file/v2"
      AIRFLOW_VAR_CORE__SERVICE__WORKFLOW__HOST: "http://ingestion-workflow.osdu.svc.cluster.local/api/workflow"
    extraEnv:
      - name: AIRFLOW__CORE__FERNET_KEY
        valueFrom:
          secretKeyRef:
            name: airflow
            key: fernet-key
      - name: AIRFLOW_CONN_AZ_LOG
        valueFrom:
          secretKeyRef:
            name: airflow
            key: remote-log-connection
      - name: CLOUD_PROVIDER
        value: "azure"
      - name: KEYVAULT_URI
        valueFrom:
          configMapKeyRef:
            name: osdu-svc-properties
            key: ENV_KEYVAULT
    extraConfigmapMounts:
      - name: remote-log-config
        mountPath: /opt/airflow/config
        configMap: airflow-remote-log-config
        readOnly: true
    extraPipPackages: [
        "flask-bcrypt==0.7.1",
        "apache-airflow[statsd]",
        "apache-airflow[kubernetes]",
        "apache-airflow-backport-providers-microsoft-azure==2021.2.5",
        "dataclasses==0.8",
        "google-cloud-storage",
        "python-keycloak==0.24.0",
        "msal==1.9.0",
        "azure-identity==1.5.0",
        "azure-keyvault-secrets==4.2.0",
        "azure-storage-blob",
        "azure-servicebus==7.0.1",
        "toposort==1.6",
        "https://azglobalosdutestlake.blob.core.windows.net/pythonsdk/osdu_api-0.0.4.tar.gz"
    ]
    extraVolumeMounts:
      - name: azure-keyvault
        mountPath: "/mnt/azure-keyvault"
        readOnly: true
      - name: dags-data
        mountPath: /opt/airflow/plugins
        subPath: plugins
    extraVolumes:
      - name: azure-keyvault
        csi:
          driver: secrets-store.csi.k8s.io
          readOnly: true
          volumeAttributes:
            secretProviderClass: azure-keyvault
EOF
```

__Clone Service Repositories__

Manually ensure all the services have been cloned to your machine.

```bash
SRC_DIR="<ROOT_PATH_TO_SOURCE>" #  $HOME/source/osdu/osdu-gitlab

git clone https://community.opengroup.org/osdu/platform/system/partition.git $SRC_DIR/partition
git clone https://community.opengroup.org/osdu/platform/security-and-compliance/entitlements-azure.git $SRC_DIR/entitlements-azure
git clone https://community.opengroup.org/osdu/platform/security-and-compliance/entitlements.git $SRC_DIR/entitlements
git clone https://community.opengroup.org/osdu/platform/security-and-compliance/legal.git $SRC_DIR/legal
git clone https://community.opengroup.org/osdu/platform/system/storage.git $SRC_DIR/storage
git clone https://community.opengroup.org/osdu/platform/system/indexer-queue.git $SRC_DIR/indexer-queue
git clone https://community.opengroup.org/osdu/platform/system/indexer-service.git $SRC_DIR/indexer-service
git clone https://community.opengroup.org/osdu/platform/system/search-service.git $SRC_DIR/search-service
git clone https://community.opengroup.org/osdu/platform/system/file.git $SRC_DIR/file-service
git clone https://community.opengroup.org/osdu/platform/system/delivery.git $SRC_DIR/delivery
git clone https://community.opengroup.org/osdu/platform/system/reference/ unit-service.git $SRC_DIR/unit-service
git clone https://community.opengroup.org/osdu/platform/system/reference/crs-catalog-service.git $SRC_DIR/crs-catalog-service
git clone https://community.opengroup.org/osdu/platform/system/reference/crs-conversion-service.git $SRC_DIR/crs-conversion-service
git clone https://community.opengroup.org/osdu/platform/system/notification.git $SRC_DIR/notification
git clone https://community.opengroup.org/osdu/platform/data-flow/enrichment/wks.git $SRC_DIR/wks
git clone https://community.opengroup.org/osdu/platform/system/register.git $SRC_DIR/register
git clone https://community.opengroup.org/osdu/platform/system/schema-service.git $SRC_DIR/schema-service
git clonehttps://community.opengroup.org/osdu/platform/data-flow/ingestion/ingestion-workflow.git $SRC_DIR/ingestion-workflow
git clone https://community.opengroup.org/osdu/platform/domain-data-mgmt-services/seismic/seismic-dms-suite/seismic-store-service.git $SRC_DIR/seismic-store-service
git clone https://community.opengroup.org:osdu/platform/domain-data-mgmt-services/wellbore/wellbore-domain-services.git $SRC_DIR/wellbore-domain-services
git clone https://community.opengroup.org/osdu/platform/data-flow/ingestion/ingestion-service.git $SRC_DIR/ingestion-service
```

__Additional Manual Steps__
Following services require additional steps for manual setup.
- [CRS Catalog Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/56)
- [CRS Conversion Serice](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/65)
- [Unit Service](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/55)
- [Wellbore DMS](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/issues/36)


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

# Publish Docker Images for airflow components
CONTAINER_REGISTRY=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/container-registry --query value -otsv)
az acr login -n $CONTAINER_REGISTRY
for SERVICE in airflow-function airflow-statsd;
do
  cd ${INFRA_SRC}/source/$SERVICE
  IMAGE=$CONTAINER_REGISTRY.azurecr.io/$SERVICE-$BRANCH:$(TAG)
  docker build -t $IMAGE .
  docker push $IMAGE
done

# Installing PyYaml required for airflow
pip3 install -U PyYAML

# Extract manifests from the airflow charts.
helm template airflow ${INFRA_SRC}/charts/airflow -f ${INFRA_SRC}/charts/config_airflow.yaml | python3 ${INFRA_SRC}/charts/airflow/scripts/add-namespace.py > ${FLUX_SRC}/providers/azure/hld-registry/airflow.yaml

# Commit and Checkin to Deploy
(cd $FLUX_SRC \
  && git switch $UNIQUE \
  && git add ${FLUX_SRC}/providers/azure/hld-registry/airflow.yaml \
  && git commit -m "Initialize Airflow Chart" \
  && git push origin $UNIQUE)

# Extract manifests from each service chart.
SERVICE_LIST="infra-azure-provisioning \
              partition \
              entitlements-azure \
              entitlements \
              legal \
              storage \
              indexer-queue \
              indexer-service \
              search-service \
              delivery \
              file-service \
              unit-service \
              crs-conversion-service \
              crs-catalog-service \
              wks \
              register \
              notification \
              schema-service \
              ingestion-workflow \
              ingestion-service"

for SERVICE in $SERVICE_LIST;
do
  helm template $SERVICE ${SRC_DIR}/$SERVICE/devops/azure/chart --set image.branch=$BRANCH --set image.tag=$TAG > ${FLUX_SRC}/providers/azure/hld-registry/$SERVICE.yaml
done


SERVICE=wellbore-domain-services
helm template $SERVICE ${SRC_DIR}/$SERVICE/devops/azure/chart \
  --set image.repository=${CONTAINER_REGISTRY_NAME}.azurecr.io/${SERVICE}-${BRANCH} \
  --set image.tag=$TAG \
  --set annotations.buildNumber=undefined \
  --set annotations.buildOrigin=manual \
  --set annotations.commitBranch=undefined \
  --set annotations.commitId=undefined \
  --set labels.env=dev \
  > ${FLUX_SRC}/providers/azure/hld-registry/$SERVICE.yaml


# Commit and Checkin to Deploy
(cd $FLUX_SRC \
  && git switch $UNIQUE \
  && git add ${FLUX_SRC}/providers/azure/hld-registry/*.yaml \
  && git commit -m "Adding OSDU Services" \
  && git push origin $UNIQUE)
```
