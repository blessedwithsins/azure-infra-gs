# Configuration Data Upload Instructions

__CLI Login__

Login to Azure CLI using the OSDU Environment Service Principal.

```bash
# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
```

__Upload Configuration Data__

3 services that required configuration data to be loaded into the configuration storage account file shares.

_Unit_

```bash
FILE_SHARE="unit"
FILE=$(realpath ../unit-service/data/unit_catalog_v2.json)

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

az storage file upload \
  --account-name $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/airflow-storage --query value -otsv) \
  --account-key $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/airflow-storage-key --query value -otsv) \
  --share-name ${FILE_SHARE} \
  --source ${FILE}
```

_CRS Catalog_

```bash
FILE_SHARE="crs"
FILE=$(realpath ../crs-catalog-service/data/crs_catalog_v2.json)

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

az storage file upload \
  --account-name $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/airflow-storage --query value -otsv) \
  --account-key $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/airflow-storage-key --query value -otsv) \
  --share-name ${FILE_SHARE} \
  --source ${FILE}
```

_CRS Conversion_

```bash
FILE_SHARE="crs-conversion"
PROJECT_FOLDER=$(realpath ../crs-conversion-service)
SOURCE_FOLDER="apachesis_setup/**"

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

az storage file upload-batch \
  --account-name $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/airflow-storage --query value -otsv) \
  --account-key $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/airflow-storage-key --query value -otsv) \
  --destination $FILE_SHARE \
  --source ${PROJECT_FOLDER} \
  --pattern ${SOURCE_FOLDER}
```

_Ingest Manifest DAGS_

```bash
FILE_SHARE="airflowdags"
PROJECT_FOLDER=$(realpath ../ingestion-dags/src)

GROUP=$(az group list --query "[?contains(name, 'cr${UNIQUE}')].name" -otsv)
ENV_VAULT=$(az keyvault list --resource-group $GROUP --query [].name -otsv)

az storage file upload-batch \
  --account-name $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/airflow-storage --query value -otsv) \
  --account-key $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/airflow-storage-key --query value -otsv) \
  --destination $FILE_SHARE \
  --source ${PROJECT_FOLDER} \
  --pattern "*.ini"

az storage file upload-batch \
  --account-name $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/airflow-storage --query value -otsv) \
  --account-key $(az keyvault secret show --id https://${ENV_VAULT}.vault.azure.net/secrets/airflow-storage-key --query value -otsv) \
  --destination $FILE_SHARE \
  --source ${PROJECT_FOLDER} \
  --pattern "*.py"
```
