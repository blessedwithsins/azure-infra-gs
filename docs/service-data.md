# Load Service Data

## Service Schema Loading

Schema Service has standard shared schemas that have to be loaded.


```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo
AZURE_DNS_NAME="<your_osdu_fqdn>"   # ie: osdu-$UNIQUE.contoso.com
DATA_PARTITION="<your_partition>"   # ie:opendes

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
docker run --env-file .env msosdu.azurecr.io/osdu-azure-core-load:latest
```

## CSV Parser DAG Loading

The CSV Ingestion is an Airflow DAG that has to be loaded.  The images are created as part of the [csv-parser](https://community.opengroup.org/osdu/platform/data-flow/ingestion/csv-parser/csv-parser) project and are tied to a release.


```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo
DNS_HOST="<your_osdu_fqdn>"         # ie: osdu-$UNIQUE.contoso.com
DATA_PARTITION="<your_partition>"   # ie:opendes
ACR_REGISTRY="<repository>"         # ie: msosdu.azurecr.io
TAG="<app_version>"                 # ie: 0.7.0

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

cat > .env << EOF
CSV_PARSER_IMAGE=${ACR_REGISTRY}/csv-parser:${TAG}
SHARED_TENANT=$DATA_PARTITION
AZURE_TENANT_ID=$ARM_TENANT_ID
AZURE_DNS_NAME=$DNS_HOST
AZURE_AD_APP_RESOURCE_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
AZURE_CLIENT_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-username --query value -otsv)
AZURE_CLIENT_SECRET=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-password --query value -otsv)
EOF

docker run -it --env-file .env $ACR_REGISTRY/csv-parser-dag:$TAG
```
