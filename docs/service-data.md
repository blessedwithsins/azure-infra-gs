# Load Service Data

## Service Schema Loading

Schema Service has standard shared schemas that have to be loaded.


```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo
AZURE_DNS_NAME="<your_osdu_fqdn>"   # ie: osdu-$UNIQUE.contoso.com
DATA_PARTITION="<your_partition>"   # ie:opendes
ACR_REGISTRY="<repository>"         # ie: msosdu.azurecr.io
TAG="<app_version>"                 # ie: 0.10.0

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

cat > .env << EOF
DATA_PARTITION=$DATA_PARTITION
AZURE_TENANT_ID=$ARM_TENANT_ID
AZURE_DNS_NAME=$AZURE_DNS_NAME
AZURE_AD_APP_RESOURCE_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
AZURE_CLIENT_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-username --query value -otsv)
AZURE_CLIENT_SECRET=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-password --query value -otsv)
EOF

# Execute container to load the schema's
docker run --env-file .env $ACR_REGISTRY/schema-load:$TAG
```
## Policy Data Loading

Policy Service has standard shared policies that have to be loaded.


```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo
AZURE_DNS_NAME="<your_osdu_fqdn>"   # ie: osdu-$UNIQUE.contoso.com
DATA_PARTITION="<your_partition>"   # ie:opendes
ACR_REGISTRY="<repository>"         # ie: msosdu.azurecr.io
TAG="<app_version>"                 # ie: 0.10.0

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

cat > .env << EOF
DATA_PARTITION=$DATA_PARTITION
AZURE_TENANT_ID=$ARM_TENANT_ID
AZURE_DNS_NAME=$AZURE_DNS_NAME
AZURE_AD_APP_RESOURCE_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
AZURE_CLIENT_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-username --query value -otsv)
AZURE_CLIENT_SECRET=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-password --query value -otsv)
EOF

# Execute container to load the policies
docker run --env-file .env $ACR_REGISTRY/policy-data:$TAG
```

## CSV Parser DAG Loading

The CSV Ingestion is an Airflow DAG that has to be loaded.  The images are created as part of the [csv-parser](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser) project and are tied to a release.


```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo
DNS_HOST="<your_osdu_fqdn>"         # ie: osdu-$UNIQUE.contoso.com
DATA_PARTITION="<your_partition>"   # ie:opendes
ACR_REGISTRY="<repository>"         # ie: msosdu.azurecr.io
TAG="<app_version>"                 # ie: 0.10.0

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

cat > .env << EOF
CSV_PARSER_IMAGE=${ACR_REGISTRY}/csv-parser:${TAG}
DATA_PARTITION=$DATA_PARTITION
AZURE_TENANT_ID=$ARM_TENANT_ID
AZURE_DNS_NAME=$DNS_HOST
AZURE_AD_APP_RESOURCE_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
AZURE_CLIENT_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-username --query value -otsv)
AZURE_CLIENT_SECRET=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-password --query value -otsv)
EOF

docker run -it --env-file .env $ACR_REGISTRY/csv-parser-dag:$TAG
```

## SEGY to ZGY DAG Conversion - DAG Loading

For the SEGY to ZGY Conversion to happen, the conversion DAG needs to be loaded. The images are created as part of the [segy-to-zgy-conversion] (https://community.opengroup.org/osdu/platform/data-flow/ingestion/segy-to-zgy-conversion.git) project and are tied to a release. [Here](community.opengroup.org:5555/osdu/platform/data-flow/ingestion/segy-to-zgy-conversion:latest) is the baseline image for SEGY.

Reference: [Open ZGY](https://community.opengroup.org/osdu/platform/domain-data-mgmt-services/seismic/open-zgy)

```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo
AZURE_DNS_NAME="<your_osdu_fqdn>"   # ie: osdu-$UNIQUE.contoso.com
DATA_PARTITION="<your_partition>"   # ie:opendes
ACR_REGISTRY="<your_acr_fqdn>"      # ie: myacr.azurecr.io
TAG="<app_version>"                 # ie: 0.10.0

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

cat > .env << EOF
DAG_TASK_IMAGE=${ACR_REGISTRY}/segy-to-zgy-conversion-dag:$TAG
SHARED_TENANT=$DATA_PARTITION
AZURE_DNS_NAME=$AZURE_DNS_NAME
AZURE_TENANT_ID=$ARM_TENANT_ID
AZURE_AD_APP_RESOURCE_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
AZURE_CLIENT_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-username --query value -otsv)
AZURE_CLIENT_SECRET=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-password --query value -otsv)
EOF

docker run -it --env-file .env $ACR_REGISTRY/segy-to-zgy-conversion-dag:$TAG
```



## SEGY to VDS DAG Conversion - DAG Loading

For the SEGY to VDS Conversion to happen, the conversion DAG needs to be loaded. The images are created as part of the [segy-to-vds-conversion] (https://community.opengroup.org/osdu/platform/data-flow/ingestion/segy-to-vds-conversion.git) project and are tied to a release. [Here](community.opengroup.org:5555/osdu/platform/domain-data-mgmt-services/seismic/open-vds/openvds-ingestion:latest) is the baseline image for SEGY.

Reference: [Open VDS](https://community.opengroup.org/osdu/platform/domain-data-mgmt-services/seismic/open-vds)

```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo
AZURE_DNS_NAME="<your_osdu_fqdn>"   # ie: osdu-$UNIQUE.contoso.com
DATA_PARTITION="<your_partition>"   # ie:opendes
ACR_REGISTRY="<your_acr_fqdn>"      # ie: myacr.azurecr.io
DAG_NAME="vds_dag"
TAG="latest"                        # For now the latest tag should be used for the image places in the Open VDS Project. For example, 0.10.0
AZURE_AD_APP_RESOURCE_ID="<your_azure_ad_resource_id>"
AZURE_CLIENT_ID="<your azure_client_id>"
AZURE_CLIENT_SECRET="<your azure client secret>"
SHARED_TENANT="<your shared tenant>" # i.e: opendes

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

cat > .env << EOF
DAG_IMAGE=${ACR_REGISTRY}/$DAG_NAME:${TAG}
SHARED_TENANT=$SHARED_TENANT
AZURE_TENANT_ID=$AZURE_TENANT_ID
AZURE_DNS_NAME=$AZURE_DNS_NAME
AZURE_AD_APP_RESOURCE_ID=$AZURE_AD_APP_RESOURCE_ID
AZURE_CLIENT_ID=$AZURE_CLIENT_ID
AZURE_CLIENT_SECRET=$AZURE_CLIENT_SECRET
EOF

#(cd ../../.. && docker build -f deployments/scripts/azure/Dockerfile -t $ACR_REGISTRY/$DAG_NAME:$TAG .)
docker run -it --env-file .env $ACR_REGISTRY/$DAG_NAME:$TAG
```
