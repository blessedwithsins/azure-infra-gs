# Instructions for Loading CSV Parser DAG

For loading CSV Parser DAG we would need to create two docker images

- Docker image for CSV Parser
- Docker image for loading and registering CSV Parser DAG

## Building and pushing Docker Image for CSV Parser
- Execute the below script from root of CSV Parser project


```bash
TAG="latest"
ACR_REGISTRY="msosdu.azurecr.io"
mvn clean install -pl provider/csv-parser-azure -am
cd provider/csv-parser-azure
docker build -t ${ACR_REGISTRY}/csv-parser:${TAG} . 
docker push ${ACR_REGISTRY}/csv-parser:${TAG}
```

## Building and pushing Docker Image for CSV Parser DAG

- Execute the below script from root of CSV Parser project to build and load the CSV Parser  DAG

```bash
# Setup Variables
UNIQUE="<your_osdu_unique>"         # ie: demo
AZURE_DNS_NAME="<your_osdu_fqdn>"   # ie: osdu-$UNIQUE.contoso.com
DATA_PARTITION="<your_partition>"   # ie:opendes
ACR_REGISTRY="<your_acr_fqdn>"      # ie: myacr.azurecr.io

CSV_PARSER_IMAGE="$ACR_REGISTRY/csv-parser"
CSV_DAG_IMAGE="$ACR_REGISTRY/csv-parser-dag"
TAG="latest"

# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

cat > .env << EOF
CSV_PARSER_IMAGE=$CSV_PARSER_IMAGE:$TAG
DATA_PARTITION=$DATA_PARTITION
AZURE_TENANT_ID=$ARM_TENANT_ID
AZURE_DNS_NAME=$AZURE_DNS_NAME
AZURE_AD_APP_RESOURCE_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/aad-client-id --query value -otsv)
AZURE_CLIENT_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-username --query value -otsv)
AZURE_CLIENT_SECRET=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-password --query value -otsv)
EOF

docker build -f deployments/scripts/azure/Dockerfile -t $CSV_DAG_IMAGE:$TAG .
docker push $CSV_DAG_IMAGE:$TAG
docker run -it --env-file .env $CSV_DAG_IMAGE:$TAG
```