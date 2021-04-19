# Test Data Upload Instructions

## Getting started

* [Python 2.7 or 3.5.3+][python]

__SDK installation__

Install the Python SDK

```bash
pip3 install azure-cosmos
```

__CLI Login__

Login to Azure CLI using the OSDU Environment Service Principal.

```bash
# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
```

__Upload Storage Blob Test Data__

This [file](../tools/test_data/Legal_COO.json) needs to be loaded into the Data Partition Storage Account in the container  `legal-service-azure-configuration`.

```bash
GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)
PARTITION_NAME=opendes

az storage blob upload \
  --account-name $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/${PARTITION_NAME}-storage --query value -otsv) \
  --account-key $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/${PARTITION_NAME}-storage-key --query value -otsv) \
  --file tools/test_data/Legal_COO.json \
  --container-name legal-service-azure-configuration \
  --name Legal_COO.json
```

__Upload Cosmos DB Test Data__

These files need to be uploaded into the proper Cosmos Collections with the required values injected.

- tenant_info_1.json
- tenant_info_2.json
- user_info_1.json
- user_info_2.json
- legal_tag_1.json
- legal_tag_2.json
- legal_tag_3.json
- storage_schema_1.json
- storage_schema_2.json
- storage_schema_3.json
- storage_schema_4.json
- storage_schema_5.json
- storage_schema_6.json
- storage_schema_7.json
- storage_schema_8.json
- storage_schema_9.json
- storage_schema_10.json
- storage_schema_11.json

> NOTE: If you are doing a manual deployment, your partition name is "opendes" by default

```bash
# Retrieve Values from Common Key Vault
export NO_DATA_ACCESS_TESTER=$(az keyvault secret show --id https://$COMMON_VAULT.vault.azure.net/secrets/osdu-mvp-${UNIQUE}-noaccess-clientid --query value -otsv)

# Retrieve Values from Environment Key Vault
export COSMOS_ENDPOINT=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/${PARTITION_NAME}-cosmos-endpoint --query value -otsv)
export COSMOS_KEY=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/${PARTITION_NAME}-cosmos-primary-key --query value -otsv)
export SERVICE_PRINCIPAL_ID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-username --query value -otsv)
export SERVICE_PRINCIPAL_OID=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/app-dev-sp-id --query value -otsv)
export GRAPH_DB_PASSWORD=$(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/graph-db-primary-key --query value -otsv)
export GRAPH_DB_HOST=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv | awk '{ print substr( $0, 1, length($0)-3 ) }')-graph.gremlin.cosmos.azure.com

# Execute the Upload from the test data folder (script expects file locally)
cd tools/test_data
python3 upload-data.py
```
__Upload Graph Cosmos DB Test Data__

> NOTE: requires Maven installed locally
```bash
cd entitlements_data_uploader
mvn compile exec:java -DGRAPH_DB_HOST=$GRAPH_DB_HOST -DGRAPH_DB_PASSWORD=$GRAPH_DB_PASSWORD -DSERVICE_PRINCIPAL_ID=$SERVICE_PRINCIPAL_ID -DNO_DATA_ACCESS_TESTER=$NO_DATA_ACCESS_TESTER -DDOMAIN=contoso.com
```
