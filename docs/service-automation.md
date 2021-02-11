# Create OSDU Service Libraries

__Setup and Configure the ADO Library `Azure - OSDU`__

This variable group will be used to hold the common values for the services to be deployed and relate specifically to settings common to integration tests across all services.  Variable values here that are other variables are being pulled from the Library group accessing the common Key Vault.

| Variable                                      | Value |
|-----------------------------------------------|-------|
| ADMIN_EMAIL                                   | <your_sslcert_admin_email>                  |
| AGENT_POOL                                    | `Hosted Ubuntu 1604`                        |
| AZURE_AD_GUEST_EMAIL                          | `$(ad-guest-email)`                         |
| AZURE_AD_GUEST_OID                            | `$(ad-guest-oid)`                           |
| AZURE_AD_OTHER_APP_RESOURCE_ID                | `$(osdu-mvp-<your_unique>-application-clientid)` |
| AZURE_AD_OTHER_APP_RESOURCE_OID               | `$(osdu-mvp-<your_unique>-application-oid)` |
| AZURE_AD_USER_EMAIL                           | `$(ad-user-email)`                          |
| AZURE_AD_USER_OID                             | `$(ad-user-oid)`                            |
| AZURE_LEGAL_TOPICNAME                         | `legaltags`                                 |
| DEPLOY_ENV                                    | `empty`                                     |
| EXPIRED_TOKEN                                 | <an_expired_token>                          |
| HOST_URL                                      | `https://<your_fqdn>/`                      |
| NO_DATA_ACCESS_TESTER                         | `$(osdu-mvp-<your_unique>-noaccess-clientid)`  |
| NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET | `$(osdu-mvp-<your_unique>-noaccess-secret)` |
| PUBSUB_TOKEN                                  | `az`                                        |
| SERVICE_CONNECTION_NAME                       | <your_service_connection_name>              |
| GOOGLE_CLOUD_PROJECT                          | `opendes`                                   |
| ENTITLEMENT_URL                               | `https://<your_fqdn>/entitlements/v1/`      |
| ENTITLEMENT_V2_URL                            | `https://<your_fqdn>/api/entitlements/v2/`  |
| LEGAL_URL                                     | `https://<your_fqdn>/api/legal/v1/`         |
| STORAGE_URL                                   | `https://<your_fqdn>/api/storage/v2/`       |
| SEARCH_URL                                    | `https://<your_fqdn>/api/search/v2/`        |
| FILE_URL                                      | `https://<your_fqdn>/api/file/v2`           |
| DELIVERY_URL                                  | `https://<your_fqdn>/api/delivery/v2`       |
| UNIT_URL                                      | `https://<your_fqdn>/api/unit/v2`           |
| CRS_CATALOG_URL                               | `https://<your_fqdn>/api/crs/catalog/v2/`   |
| CRS_CONVERSION_URL                            | `https://<your_fqdn>/api/crs/converter/v2/` |
| REGISTER_BASE_URL                             | `https://<your_fqdn>/`                      |
| ACL_OWNERS                                    | `data.test1`                                |
| ACL_VIEWERS                                   | `data.test1`                                |
| DATA_PARTITION_ID                             | `opendes`                                   |
| TENANT_NAME                                   | `opendes`                                   |
| VENDOR                                        | `azure`                                     |
| OSDU_TENANT                                   | `opendes`                                   |
| NOTIFICATION_REGISTER_BASE_URL                | `https://<your_fqdn>`                       |
| NOTIFICATION_BASE_URL                         | `https://<your_fqdn>/api/notification/v1/`  |
| REGISTER_CUSTOM_PUSH_URL_HMAC                 | `https://<your_fqdn>/api/register/v1/test/challenge/1`|
| AGENT_IMAGE                                   | `ubuntu-latest`                             | 


```bash
ADMIN_EMAIL="<your_cert_admin>"     # ie: admin@email.com
DNS_HOST="<your_ingress_hostname>"  # ie: osdu.contoso.com
SERVICE_CONNECTION_NAME=osdu-mvp-$UNIQUE
INVALID_TOKEN="<an_invalid_token>"

az pipelines variable-group create \
  --name "Azure - OSDU" \
  --authorize true \
  --variables \
  ADMIN_EMAIL=$ADMIN_EMAIL \
  AGENT_POOL="Hosted Ubuntu 1604" \
  AZURE_AD_GUEST_EMAIL='$(ad-guest-email)' \
  AZURE_AD_GUEST_OID='$(ad-guest-oid)' \
  AZURE_AD_OTHER_APP_RESOURCE_ID='$(osdu-mvp-'${UNIQUE}'-application-clientid)' \
  AZURE_AD_OTHER_APP_RESOURCE_OID='$(osdu-mvp-'${UNIQUE}'-application-oid)' \
  AZURE_AD_USER_EMAIL='$(ad-user-email)' \
  AZURE_AD_USER_OID='$(ad-user-oid)' \
  AZURE_LEGAL_TOPICNAME="legaltags" \
  DEPLOY_ENV="empty" \
  EXPIRED_TOKEN=$INVALID_TOKEN \
  HOST_URL="https://${DNS_HOST}/" \
  NO_DATA_ACCESS_TESTER='$(osdu-mvp-'${UNIQUE}'-noaccess-clientid)' \
  NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET='$(osdu-mvp-'${UNIQUE}'-noaccess-secret)' \
  PUBSUB_TOKEN="az" \
  SERVICE_CONNECTION_NAME=$SERVICE_CONNECTION_NAME \
  GOOGLE_CLOUD_PROJECT="opendes" \
  ENTITLEMENT_URL="https://${DNS_HOST}/entitlements/v1/" \
  ENTITLEMENT_V2_URL="https://${DNS_HOST}/api/entitlements/v2/" \
  LEGAL_URL="https://${DNS_HOST}/api/legal/v1/" \
  STORAGE_URL="https://${DNS_HOST}/api/storage/v2/" \
  SEARCH_URL="https://${DNS_HOST}/api/search/v2/" \
  FILE_URL="https://${DNS_HOST}/api/file/v2" \
  DELIVERY_URL="https://${DNS_HOST}/api/delivery/v2/" \
  UNIT_URL="https://${DNS_HOST}/api/unit/v2/" \
  CRS_CATALOG_URL="https://${DNS_HOST}/api/crs/catalog/v2/" \
  CRS_CONVERSION_URL="https://${DNS_HOST}/api/crs/converter/v2/" \
  REGISTER_BASE_URL="https://${DNS_HOST}/" \
  ACL_OWNERS="data.test1" \
  ACL_VIEWERS="data.test1" \
  DATA_PARTITION_ID="opendes" \
  TENANT_NAME="opendes" \
  VENDOR="azure" \
  NOTIFICATION_REGISTER_BASE_URL="https://${DNS_HOST}" \
  NOTIFICATION_BASE_URL="https://${DNS_HOST}/api/notification/v1/" \
  REGISTER_CUSTOM_PUSH_URL_HMAC="https://${DNS_HOST}/api/register/v1/test/challenge/1" \
  AGENT_IMAGE="ubuntu-latest" \
  -ojson
```


__Setup and Configure the ADO Library `Azure - OSDU Secrets`__

This variable group is a linked variable group that links to the Common Key Vault `osducommon<random>` and retrieves secret common settings.

- ad-guest-email
- ad-guest-oid
- ad-user-email
- ad-user-oid
- istio-username
- istio-password
- osdu-mvp-{unique}-application-clientid
- osdu-mvp-{unique}-application-secret
- osdu-mvp-{unique}-application-oid
- osdu-infra-{unique}-noaccess-clientid
- osdu-infra-{unique}-noaccess-oid
- osdu-infra-{unique}-noaccess-secret


__Setup and Configure the ADO Library `Azure Target Env - demo`__

This variable group will be used to hold the specific environment values necessary for integration testing of the services being deployed. Variable values here that are other variables are being pulled from the Library group accessing the environment Key Vault.

| Variable | Value |
|----------|-------|
| AZURE_AD_APP_RESOURCE_ID                      | `$(aad-client-id)`                |
| AZURE_DEPLOY_SUBSCRIPTION                     | `$(subscription-id)`              |
| AZURE_LEGAL_SERVICEBUS                        | `$(opendes-sb-connection)`        |
| AZURE_TENANT_ID                               | `$(tenant-id)`                    |
| AZURE_TESTER_SERVICEPRINCIPAL_SECRET          | `$(app-dev-sp-password)`          |
| CONTAINER_REGISTRY_NAME                       | `$(container_registry)`           |
| DNS_HOST                                      | <your_FQDN>                       |
| DOMAIN                                        | `contoso.com`                     |
| ELASTIC_ENDPOINT                              | `$(opendes-elastic-endpoint)`     |
| ELASTIC_USERNAME                              | `$(opendes-elastic-username)`     |
| ELASTIC_PASSWORD                              | `$(opendes-elastic-password)`     |
| ENVIRONMENT_NAME                              | <your_environment_name_or_identifier>     |
| IDENTITY_CLIENT_ID                            | `$(osdu-identity-id)`             |
| INTEGRATION_TESTER                            | `$(app-dev-sp-username)`          |
| MY_TENANT                                     | `opendes`                         |
| LEGAL_TAG                                     | `opendes-public-usa-dataset-7643990`        |
| PROVIDER_NAME                                 | `azure`                           |
| REDIS_PORT                                    | `6380`                            |
| STORAGE_ACCOUNT                               | `$(opendes-storage)`              |
| STORAGE_ACCOUNT_KEY                           | `$(opendes-storage-key)`          |
| AZURE_EVENT_SUBSCRIBER_SECRET                 | Subscriber Secret used while performing handshake                      |
| AZURE_EVENT_SUBSCRIPTION_ID                   | Subscription ID created by Base64 encoding a string formed by concatenating GET /challenge/{} endpoint in register service and Event Grid Topic <br/>  For eg. BASE64(osdu-mvp-dp1demo-esyx-grid-recordstopic + https://{DNS}/api/register/v1/challenge/1           |
| AZURE_EVENT_TOPIC_NAME                        | Event grid Topic Name eg. `osdu-mvp-dp1demo-esyx-grid-recordstopic`          |
| AZURE_DNS_NAME                                | <your_FQDN>                       |
| AZURE_MAPPINGS_STORAGE_CONTAINER              | `osdu-wks-mappings`               |
| AZURE_COSMOS_KEY                              | `$(opendes-cosmos-primary-key)`   This variable will not be required after the data partition changes|
| AZURE_COSMOS_URL                              | `$(opendes-cosmos-endpoint)`      This variable will not be required after the data partition changes|
| SIS_DATA                                      | `$(Pipeline.Workspace)/s/apachesis_setup/SIS_DATA`      This variable should point to your SIS_DATA setup|

```bash
DATA_PARTITION_NAME=opendes
LEGAL_TAG=opendes-public-usa-dataset-7643990
DNS_HOST="<your_ingress_hostname>"  # ie: osdu.contoso.com
ENVIRONMENT_NAME=$UNIQUE
PROVIDER_NAME=azure
REDIS_PORT="6380"


az pipelines variable-group create \
  --name "Azure Target Env - ${UNIQUE}" \
  --authorize true \
  --variables \
  AZURE_AD_APP_RESOURCE_ID='$(aad-client-id)' \
  AZURE_DEPLOY_SUBSCRIPTION='$(subscription-id)' \
  AZURE_LEGAL_SERVICEBUS='$('${DATA_PARTITION_NAME}'-sb-connection)' \
  AZURE_TENANT_ID='$(tenant-id)' \
  AZURE_TESTER_SERVICEPRINCIPAL_SECRET='$(app-dev-sp-password)' \
  CONTAINER_REGISTRY_NAME='$(container-registry)' \
  DNS_HOST="$DNS_HOST" \
  DOMAIN="contoso.com" \
  ELASTIC_ENDPOINT='$('${DATA_PARTITION_NAME}'-elastic-endpoint)' \
  ELASTIC_USERNAME='$('${DATA_PARTITION_NAME}'-elastic-username)' \
  ELASTIC_PASSWORD='$('${DATA_PARTITION_NAME}'-elastic-password)' \
  ENVIRONMENT_NAME="$ENVIRONMENT_NAME" \
  IDENTITY_CLIENT_ID='$(identity_id)' \
  INTEGRATION_TESTER='$(app-dev-sp-username)' \
  MY_TENANT="$DATA_PARTITION_NAME" \
  LEGAL_TAG="$LEGAL_TAG" \
  PROVIDER_NAME="$PROVIDER_NAME" \
  REDIS_PORT="$REDIS_PORT" \
  STORAGE_ACCOUNT='$('${DATA_PARTITION_NAME}'-storage)' \
  STORAGE_ACCOUNT_KEY='$('${DATA_PARTITION_NAME}'-storage-key)' \
  AZURE_EVENT_SUBSCRIBER_SECRET="secret" \
  AZURE_EVENT_SUBSCRIPTION_ID="subscriptionId" \
  AZURE_EVENT_TOPIC_NAME="topic name" \
  AZURE_DNS_NAME="<your_fqdn>" \
  AZURE_MAPPINGS_STORAGE_CONTAINER="osdu-wks-mappings" \
  AZURE_COSMOS_KEY='$(opendes-cosmos-primary-key)' \
  AZURE_COSMOS_URL='$(opendes-cosmos-endpoint)' \
  -ojson
```

__Setup and Configure the ADO Library `Azure Target Env Secrets - demo`__

This variable group is a linked variable group that links to the Environment Key Vault and retrieves secret common settings.

- aad-client-id
- app-dev-sp-id
- app-dev-sp-password
- app-dev-sp-tenant-id
- app-dev-sp-username
- appinsights-key
- base-name-cr
- base-name-sr
- container-registry
- {partition-name}-cosmos-connection
- {partition-name}-cosmos-endpoint
- {partition-name}-cosmos-primary-key
- {partition-name}-elastic-endpoint
- {partition-name}-elastic-password
- {partition-name}-elastic-username
- {partition-name}-storage
- {partition-name}-storage-key
- {partition-name}-sb-connection
- {partition-name}-sb-namespace
- osdu-identity-id
- subscription-id
- tenant-id


__Setup and Configure the ADO Library `Azure Service Release - partition`__

This variable group is the service specific variables necessary for testing and deploying the `partition` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH     | `drop/provider/partition-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DPARTITION_BASE_URL=$(HOST_URL) -DMY_TENANT=$(MY_TENANT) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DNO_DATA_ACCESS_TESTER=$(NO_DATA_ACCESS_TESTER) -DNO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET=$(NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_OTHER_APP_RESOURCE_ID=$(AZURE_AD_OTHER_APP_RESOURCE_ID) -DENVIRONMENT=HOSTED` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/partition-test-azure/pom.xml` |
| SERVICE_RESOURCE_NAME | `$(AZURE_PARTITION_SERVICE_NAME)` |


```bash
az pipelines variable-group create \
  --name "Azure Service Release - partition" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/partition-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS='-DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DPARTITION_BASE_URL=$(HOST_URL) -DMY_TENANT=$(MY_TENANT) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DNO_DATA_ACCESS_TESTER=$(NO_DATA_ACCESS_TESTER) -DNO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET=$(NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_OTHER_APP_RESOURCE_ID=$(AZURE_AD_OTHER_APP_RESOURCE_ID) -DENVIRONMENT=HOSTED' \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/partition-test-azure/pom.xml" \
  SERVICE_RESOURCE_NAME='$(AZURE_PARTITION_SERVICE_NAME)' \
  -ojson
```

__Setup and Configure the ADO Library `Azure Service Release - entitlements-azure`__

This variable group is the service specific variables necessary for testing and deploying the `entitlements-azure` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH     | `drop` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DENTITLEMENT_URL=$(ENTITLEMENT_URL) -DMY_TENANT=$(MY_TENANT) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DENTITLEMENT_MEMBER_NAME_VALID=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DAZURE_AD_OTHER_APP_RESOURCE_ID=$(AZURE_AD_OTHER_APP_RESOURCE_ID) -DAZURE_AD_OTHER_APP_RESOURCE_OID=$(AZURE_AD_OTHER_APP_RESOURCE_OID) -DDOMAIN=$(DOMAIN) -DEXPIRED_TOKEN=$(EXPIRED_TOKEN) -DENTITLEMENT_GROUP_NAME_VALID=integ.test.data.creator -DENTITLEMENT_MEMBER_NAME_INVALID=InvalidTestAdmin -DAZURE_AD_USER_EMAIL=$(ad-user-email) -DAZURE_AD_USER_OID=$(ad-user-oid) -DAZURE_AD_GUEST_EMAIL=$(ad-guest-email) -DAZURE_AD_GUEST_OID=$(ad-guest-oid)` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/integration-tests` |
| SERVICE_RESOURCE_NAME | `$(AZURE_ENTITLEMENTS_SERVICE_NAME)` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - entitlements-azure" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop" \
  MAVEN_INTEGRATION_TEST_OPTIONS='-DENTITLEMENT_URL=$(ENTITLEMENT_URL) -DMY_TENANT=$(MY_TENANT) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DENTITLEMENT_MEMBER_NAME_VALID=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DAZURE_AD_OTHER_APP_RESOURCE_ID=$(AZURE_AD_OTHER_APP_RESOURCE_ID) -DAZURE_AD_OTHER_APP_RESOURCE_OID=$(AZURE_AD_OTHER_APP_RESOURCE_OID) -DDOMAIN=$(DOMAIN) -DEXPIRED_TOKEN=$(EXPIRED_TOKEN) -DENTITLEMENT_GROUP_NAME_VALID=integ.test.data.creator -DENTITLEMENT_MEMBER_NAME_INVALID=InvalidTestAdmin -DAZURE_AD_USER_EMAIL=$(ad-user-email) -DAZURE_AD_USER_OID=$(ad-user-oid) -DAZURE_AD_GUEST_EMAIL=$(ad-guest-email) -DAZURE_AD_GUEST_OID=$(ad-guest-oid)' \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/integration-tests" \
  SERVICE_RESOURCE_NAME='$(AZURE_ENTITLEMENTS_SERVICE_NAME)' \
  -ojson
```

__Setup and Configure the ADO Library `Azure Service Release - entitlements`__

This variable group is the service specific variables necessary for testing and deploying the `entitlements` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH     | `drop/provider/entitlements-v2-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DargLine="-DENTITLEMENT_V2_URL=$(ENTITLEMENT_V2_URL) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DNO_DATA_ACCESS_TESTER=$(NO_DATA_ACCESS_TESTER) -DNO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET=$(NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET)"`  |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/entitlements-v2-test-azure/pom.xml` |
| SERVICE_RESOURCE_NAME | `$(AZURE_ENTITLEMENTS_V2_SERVICE_NAME)` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - entitlements" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/entitlements-v2-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS='-DargLine="-DENTITLEMENT_V2_URL=$(ENTITLEMENT_V2_URL) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DNO_DATA_ACCESS_TESTER=$(NO_DATA_ACCESS_TESTER) -DNO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET=$(NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET)"' \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/entitlements-v2-test-azure/pom.xml" \
  SERVICE_RESOURCE_NAME='$(AZURE_ENTITLEMENTS_V2_SERVICE_NAME)' \
  -ojson
```

__Setup and Configure the ADO Library `Azure Service Release - legal`__

This variable group is the service specific variables necessary for testing and deploying the `legal` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH | `drop/provider/legal-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DHOST_URL=$(LEGAL_URL) -DENTITLEMENT_URL=$(ENTITLEMENT_URL) -DMY_TENANT=$(MY_TENANT) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DAZURE_LEGAL_STORAGE_ACCOUNT=$(STORAGE_ACCOUNT) -DAZURE_LEGAL_STORAGE_KEY=$(STORAGE_ACCOUNT_KEY) -DAZURE_LEGAL_SERVICEBUS=$(AZURE_LEGAL_SERVICEBUS) -DAZURE_LEGAL_TOPICNAME=$(AZURE_LEGAL_TOPICNAME)` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/legal-test-azure/pom.xml` |
| SERVICE_RESOURCE_NAME | `$(AZURE_LEGAL_SERVICE_NAME)` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - legal" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/legal-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS='-DHOST_URL=$(LEGAL_URL) -DENTITLEMENT_URL=$(ENTITLEMENT_URL) -DMY_TENANT=$(MY_TENANT) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DAZURE_LEGAL_STORAGE_ACCOUNT=$(STORAGE_ACCOUNT) -DAZURE_LEGAL_STORAGE_KEY=$(STORAGE_ACCOUNT_KEY) -DAZURE_LEGAL_SERVICEBUS=$(AZURE_LEGAL_SERVICEBUS) -DAZURE_LEGAL_TOPICNAME=$(AZURE_LEGAL_TOPICNAME)' \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/legal-test-azure/pom.xml" \
  SERVICE_RESOURCE_NAME='$(AZURE_LEGAL_SERVICE_NAME)' \
  -ojson
```


__Setup and Configure the ADO Library `Azure Service Release - storage`__

This variable group is the service specific variables necessary for testing and deploying the `storage` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH | `drop/provider/storage-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DSTORAGE_URL=$(STORAGE_URL) -DLEGAL_URL=$(LEGAL_URL) -DTENANT_NAME=$(MY_TENANT) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DTESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_STORAGE_ACCOUNT=$(STORAGE_ACCOUNT) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DNO_DATA_ACCESS_TESTER=$(NO_DATA_ACCESS_TESTER) -DNO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET=$(NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET) -DDOMAIN=$(DOMAIN) -DPUBSUB_TOKEN=$(PUBSUB_TOKEN) -DDEPLOY_ENV=empty` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/storage-test-azure` |
| SERVICE_RESOURCE_NAME | `$(AZURE_STORAGE_SERVICE_NAME)` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - storage" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/storage-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS='-DSTORAGE_URL=$(STORAGE_URL) -DLEGAL_URL=$(LEGAL_URL) -DTENANT_NAME=$(MY_TENANT) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DTESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_STORAGE_ACCOUNT=$(STORAGE_ACCOUNT) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DNO_DATA_ACCESS_TESTER=$(NO_DATA_ACCESS_TESTER) -DNO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET=$(NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET) -DDOMAIN=$(DOMAIN) -DPUBSUB_TOKEN=$(PUBSUB_TOKEN) -DDEPLOY_ENV=empty' \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/storage-test-azure" \
  SERVICE_RESOURCE_NAME='$(AZURE_STORAGE_SERVICE_NAME)' \
  -ojson
```


__Setup and Configure the ADO Library `Azure Service Release - indexer-service`__

This variable group is the service specific variables necessary for testing and deploying the `indexer-service` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH | `drop/provider/indexer-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -Daad_client_id=$(AZURE_AD_APP_RESOURCE_ID) -DHOST=$(HOST_URL) -DSTORAGE_HOST=$(STORAGE_URL) -DELASTIC_HOST=$(ELASTIC_HOST) -DELASTIC_PORT=$(ELASTIC_PORT) -DELASTIC_USER_NAME=$(ELASTIC_USERNAME) -DELASTIC_PASSWORD=$(ELASTIC_PASSWORD) -DDEFAULT_DATA_PARTITION_ID_TENANT1=$(MY_TENANT) -DDEFAULT_DATA_PARTITION_ID_TENANT2=othertenant2 -DENTITLEMENTS_DOMAIN=$(DOMAIN) -DENVIRONMENT=CLOUD -DLEGAL_TAG=opendes-public-usa-dataset-7643990 -DOTHER_RELEVANT_DATA_COUNTRIES=US` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/indexer-test-azure` |
| SERVICE_RESOURCE_NAME | `$(AZURE_INDEXER_SERVICE_NAME)` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - indexer-service" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/indexer-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS='-DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -Daad_client_id=$(AZURE_AD_APP_RESOURCE_ID) -DSTORAGE_HOST=$(STORAGE_URL) -DELASTIC_HOST=$(ELASTIC_HOST) -DELASTIC_PORT=$(ELASTIC_PORT) -DELASTIC_USER_NAME=$(ELASTIC_USERNAME) -DELASTIC_PASSWORD=$(ELASTIC_PASSWORD) -DDEFAULT_DATA_PARTITION_ID_TENANT1=$(MY_TENANT) -DDEFAULT_DATA_PARTITION_ID_TENANT2=othertenant2 -DENTITLEMENTS_DOMAIN=$(DOMAIN) -DENVIRONMENT=CLOUD -DLEGAL_TAG=opendes-public-usa-dataset-7643990 -DOTHER_RELEVANT_DATA_COUNTRIES=US' \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/indexer-test-azure" \
  SERVICE_RESOURCE_NAME='$(AZURE_INDEXER_SERVICE_NAME)' \
  -ojson
```



__Setup and Configure the ADO Library `Azure Service Release - search-service`__

This variable group is the service specific variables necessary for testing and deploying the `search` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH | `drop/provider/search-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DSEARCH_HOST=$(SEARCH_URL) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DSTORAGE_HOST=$(STORAGE_URL) -DELASTIC_HOST=$(ELASTIC_HOST) -DELASTIC_PORT=$(ELASTIC_PORT) -DELASTIC_USER_NAME=$(ELASTIC_USERNAME) -DELASTIC_PASSWORD=$(ELASTIC_PASSWORD) -DDEFAULT_DATA_PARTITION_ID_TENANT1=$(MY_TENANT) -DDEFAULT_DATA_PARTITION_ID_TENANT2=othertenant2 -DENTITLEMENTS_DOMAIN=$(DOMAIN)` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/integration-tests/search-test-azure` |
| SERVICE_RESOURCE_NAME | `$(AZURE_SEARCH_SERVICE_NAME)` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - search-service" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/search-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS='-DSEARCH_HOST=$(SEARCH_URL) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID)  -DSTORAGE_HOST=$(STORAGE_URL) -DELASTIC_HOST=$(ELASTIC_HOST) -DELASTIC_PORT=$(ELASTIC_PORT) -DELASTIC_USER_NAME=$(ELASTIC_USERNAME) -DELASTIC_PASSWORD=$(ELASTIC_PASSWORD) -DDEFAULT_DATA_PARTITION_ID_TENANT1=$(MY_TENANT) -DDEFAULT_DATA_PARTITION_ID_TENANT2=othertenant2 -DENTITLEMENTS_DOMAIN=$(DOMAIN)' \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/integration-tests/search-test-azure" \
  SERVICE_RESOURCE_NAME='$(AZURE_SEARCH_SERVICE_NAME)' \
  -ojson
```

__Setup and Configure the ADO Library `Azure Service Release - file`__

This variable group is the service specific variables necessary for testing and deploying the `file` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH | `drop/provider/file-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DFILE_SERVICE_HOST=$(FILE_URL) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DTESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DSTAGING_CONTAINER_NAME=file-staging-area -DNO_DATA_ACCESS_TESTER=$(NO_DATA_ACCESS_TESTER) -DNO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET=$(NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_STORAGE_ACCOUNT=$(STORAGE_ACCOUNT) -DUSER_ID=osdu-user -DEXIST_FILE_ID=8900a83f-18c6-4b1d-8f38-309a208779cc -DTIME_ZONE="UTC+0" -DDATA_PARTITION_ID=$(MY_TENANT)` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/file-test-azure` |
| SERVICE_RESOURCE_NAME | `$(AZURE_FILE_SERVICE_NAME)` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - file" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/file-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS='-DFILE_SERVICE_HOST=$(FILE_URL) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DTESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DSTAGING_CONTAINER_NAME=file-staging-area -DNO_DATA_ACCESS_TESTER=$(NO_DATA_ACCESS_TESTER) -DNO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET=$(NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_STORAGE_ACCOUNT=$(STORAGE_ACCOUNT) -DUSER_ID=osdu-user -DEXIST_FILE_ID=8900a83f-18c6-4b1d-8f38-309a208779cc -DTIME_ZONE="UTC+0" -DDATA_PARTITION_ID=$(MY_TENANT)' \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/file-test-azure" \
  SERVICE_RESOURCE_NAME='$(AZURE_FILE_SERVICE_NAME)' \
  -ojson
```

__Setup and Configure the ADO Library `Azure Service Release - delivery`__

This variable group is the service specific variables necessary for testing and deploying the `delivery` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH | `drop/provider/delivery-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DargLine="-DDOMAIN=$(DOMAIN) -DENTITLEMENTS_DOMAIN=$(DOMAIN) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DTESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DAZURE_STORAGE_ACCOUNT=$(STORAGE_ACCOUNT) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DLEGAL_HOST=$(LEGAL_URL) -DDEFAULT_DATA_PARTITION_ID_TENANT1=$(MY_TENANT) -DDEFAULT_DATA_PARTITION_ID_TENANT2=common -DOTHER_RELEVANT_DATA_COUNTRIES=US -DLEGAL_TAG=opendes-public-usa-dataset-1 -DSEARCH_HOST=$(SEARCH_URL) -DSTORAGE_HOST=$(STORAGE_URL) -DDELIVERY_HOST=$(DELIVERY_URL)"` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/delivery-test-azure/pom.xml` |
| SERVICE_RESOURCE_NAME | `$(AZURE_DELIVERY_SERVICE_NAME)` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - delivery" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/delivery-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS='-DargLine="-DDOMAIN=$(DOMAIN) -DENTITLEMENTS_DOMAIN=$(DOMAIN) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DTESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DAZURE_STORAGE_ACCOUNT=$(STORAGE_ACCOUNT) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DLEGAL_HOST=$(LEGAL_URL) -DDEFAULT_DATA_PARTITION_ID_TENANT1=$(MY_TENANT) -DDEFAULT_DATA_PARTITION_ID_TENANT2=common -DOTHER_RELEVANT_DATA_COUNTRIES=US -DLEGAL_TAG=opendes-public-usa-dataset-1 -DSEARCH_HOST=$(SEARCH_URL) -DSTORAGE_HOST=$(STORAGE_URL) -DDELIVERY_HOST=$(DELIVERY_URL)"' \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/delivery-test-azure/pom.xml" \
  SERVICE_RESOURCE_NAME='$(AZURE_DELIVERY_SERVICE_NAME)' \
  -ojson
```

__Setup and Configure the ADO Library `Azure Service Release - schema-service`__

This variable group is the service specific variables necessary for testing and deploying the `schema` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH | `drop/provider/schema-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DargLine="-DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DTESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DPRIVATE_TENANT1=$(TENANT_NAME) -DPRIVATE_TENANT2=tenant2 -DSHARED_TENANT=$(TENANT_NAME) -DVENDOR=$(VENDOR) -DHOST=https://$(DNS_HOST)"` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/schema-test-core/pom.xml` |
| SERVICE_RESOURCE_NAME | `$(AZURE_SCHEMA_SERVICE_NAME)` |
| AZURE_DEPLOYMENTS_SUBDIR | `drop/deployments/scripts/azure` |
| AZURE_DEPLOYMENTS_SCRIPTS_SUBDIR | `drop/deployments/scripts` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - schema-service" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/schema-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS=`-DargLine="-DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DTESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DPRIVATE_TENANT1=$(TENANT_NAME) -DPRIVATE_TENANT2=tenant2 -DSHARED_TENANT=$(TENANT_NAME) -DVENDOR=$(VENDOR) -DHOST=https://$(DNS_HOST)"` \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/schema-test-core/pom.xml" \
  SERVICE_RESOURCE_NAME='$(AZURE_SCHEMA_SERVICE_NAME)' \
  AZURE_DEPLOYMENTS_SUBDIR="drop/deployments/scripts/azure" \
  AZURE_DEPLOYMENTS_SCRIPTS_SUBDIR="drop/deployments/scripts" \
  -ojson
```

__Setup and Configure the ADO Library `Azure Service Release - unit-service`__

This variable group is the service specific variables necessary for testing and deploying the `unit` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH | `drop/provider/unit-azure/unit-aks` |


```bash
az pipelines variable-group create \
  --name "Azure Service Release - unit-service" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/unit-azure/unit-aks" \
  -ojson
```

__Setup and Configure the ADO Library `Azure Service Release - crs-catalog-service`__

This variable group is the service specific variables necessary for testing and deploying the `crs-catalog` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH     | `drop/provider/crs-catalog-azure/crs-catalog-aks` |

No Test Path is needed since the service has python tests

```bash
az pipelines variable-group create \
  --name "Azure Service Release - crs-catalog-service" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/crs-catalog-azure/crs-catalog-aks" \
  -ojson
```

__Setup and Configure the ADO Library `Azure Service Release - crs-conversion-service`__

This variable group is the service specific variables necessary for testing and deploying the `crs-conversion` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH     | `drop/provider/crs-converter-azure/crs-converter-aks` |

No Test Path is needed since the service has python tests

```bash
az pipelines variable-group create \
  --name "Azure Service Release - crs-conversion-service" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/crs-converter-azure/crs-converter-aks" \
  -ojson
```


__Setup and Configure the ADO Library `Azure Service Release - register`__

This variable group is the service specific variables necessary for testing and deploying the `register` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH | `drop/provider/register-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DargLine="-DREGISTER_BASE_URL=$(REGISTER_BASE_URL) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DTESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DNO_DATA_ACCESS_TESTER=$(NO_DATA_ACCESS_TESTER) -DNO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET=$(NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET) -DENVIRONMENT=DEV -DSUBSCRIBER_SECRET=$(AZURE_EVENT_SUBSCRIBER_SECRET) -DTEST_TOPIC_NAME=$(AZURE_EVENT_TOPIC_NAME) -DSUBSCRIPTION_ID=$(AZURE_EVENT_SUBSCRIPTION_ID)"` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/register-test-azure/pom.xml` |
| SERVICE_RESOURCE_NAME | `$(AZURE_REGISTER_SERVICE_NAME)` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - register" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/register-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS='-DargLine="-DREGISTER_BASE_URL=$(REGISTER_BASE_URL) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DTESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DNO_DATA_ACCESS_TESTER=$(NO_DATA_ACCESS_TESTER) -DNO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET=$(NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET) -DENVIRONMENT=DEV -DSUBSCRIBER_SECRET=$(AZURE_EVENT_SUBSCRIBER_SECRET) -DTEST_TOPIC_NAME=$(AZURE_EVENT_TOPIC_NAME) -DSUBSCRIPTION_ID=$(AZURE_EVENT_SUBSCRIPTION_ID)"' \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/register-test-azure/pom.xml" \
  SERVICE_RESOURCE_NAME='$(AZURE_REGISTER_SERVICE_NAME)' \
  -ojson
```

__Setup and Configure the ADO Library `Azure Service Release - wks`__

This variable group is the service specific variables necessary for testing and deploying the `wks` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH | `drop/provider/wks-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DargLine="-DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DVENDOR=$(VENDOR) -DSTORAGE_URL=$(STORAGE_URL) -DHOST=https://$(DNS_HOST) -DLEGAL_TAG=$(LEGAL_TAG) -DDOMAIN=$(DOMAIN) -DACL_OWNERS=$(ACL_OWNERS) -DACL_VIEWERS=$(ACL_VIEWERS) -DDATA_PARTITION_ID=$(DATA_PARTITION_ID) -DTENANT_NAME=$(TENANT_NAME)"` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/wks-test-core/pom.xml` |
| SERVICE_RESOURCE_NAME | `$(AZURE_WKS_SERVICE_NAME)` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - wks" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/wks-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS='-DargLine="-DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DAZURE_TESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DVENDOR=$(VENDOR) -DSTORAGE_URL=$(STORAGE_URL) -DHOST=https://$(DNS_HOST) -DLEGAL_TAG=$(LEGAL_TAG) -DDOMAIN=$(DOMAIN) -DACL_OWNERS=$(ACL_OWNERS) -DACL_VIEWERS=$(ACL_VIEWERS) -DDATA_PARTITION_ID=$(DATA_PARTITION_ID) -DTENANT_NAME=$(TENANT_NAME)"' \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/wks-test-core/pom.xml" \
  SERVICE_RESOURCE_NAME='$(AZURE_WKS_SERVICE_NAME)' \
  -ojson
```


__Setup and Configure the ADO Library `Azure Service Release - notification`__

This variable group is the service specific variables necessary for testing and deploying the `notification` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH | `drop/provider/notification-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DargLine="-DNOTIFICATION_REGISTER_BASE_URL=$(NOTIFICATION_REGISTER_BASE_URL) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DTESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DNO_DATA_ACCESS_TESTER=$(NO_DATA_ACCESS_TESTER) -DNO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET=$(NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET) -DENVIRONMENT=DEV -DHMAC_SECRET=$(AZURE_EVENT_SUBSCRIBER_SECRET) -DTOPIC_ID=$(AZURE_EVENT_TOPIC_NAME) -DNOTIFICATION_BASE_URL=$(NOTIFICATION_BASE_URL) -DREGISTER_CUSTOM_PUSH_URL_HMAC=$(REGISTER_CUSTOM_PUSH_URL_HMAC) -DOSDU_TENANT=$(OSDU_TENANT)"` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/notification-test-azure/pom.xml` |
| SERVICE_RESOURCE_NAME | `$(AZURE_NOTIFICATION_SERVICE_NAME)` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - notification" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/notification-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS=`-DargLine="-DNOTIFICATION_REGISTER_BASE_URL=$(NOTIFICATION_REGISTER_BASE_URL) -DAZURE_AD_TENANT_ID=$(AZURE_TENANT_ID) -DINTEGRATION_TESTER=$(INTEGRATION_TESTER) -DTESTER_SERVICEPRINCIPAL_SECRET=$(AZURE_TESTER_SERVICEPRINCIPAL_SECRET) -DAZURE_AD_APP_RESOURCE_ID=$(AZURE_AD_APP_RESOURCE_ID) -DNO_DATA_ACCESS_TESTER=$(NO_DATA_ACCESS_TESTER) -DNO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET=$(NO_DATA_ACCESS_TESTER_SERVICEPRINCIPAL_SECRET) -DENVIRONMENT=DEV -DHMAC_SECRET=$(AZURE_EVENT_SUBSCRIBER_SECRET) -DTOPIC_ID=$(AZURE_EVENT_TOPIC_NAME) -DNOTIFICATION_BASE_URL=$(NOTIFICATION_BASE_URL) -DREGISTER_CUSTOM_PUSH_URL_HMAC=$(REGISTER_CUSTOM_PUSH_URL_HMAC) -DOSDU_TENANT=$(OSDU_TENANT)"` \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/notification-test-azure/pom.xml" \
  SERVICE_RESOURCE_NAME='$(AZURE_NOTIFICATION_SERVICE_NAME)' \
  -ojson
```

__Setup and Configure the ADO Library `Azure Service Release - ingestion-workflow`__

This variable group is the service specific variables necessary for testing and deploying the `ingestion-workflow` service.

| Variable | Value |
|----------|-------|
| MAVEN_DEPLOY_POM_FILE_PATH | `drop/provider/workflow-azure` |
| MAVEN_INTEGRATION_TEST_OPTIONS | `-DargLine=""` |
| MAVEN_INTEGRATION_TEST_POM_FILE_PATH | `drop/deploy/testing/workflow-test-azure/pom.xml` |
| SERVICE_RESOURCE_NAME | `$(AZURE_INGESTION_WORKFLOW_SERVICE_NAME)` |

```bash
az pipelines variable-group create \
  --name "Azure Service Release - ingestion-workflow" \
  --authorize true \
  --variables \
  MAVEN_DEPLOY_POM_FILE_PATH="drop/provider/workflow-azure" \
  MAVEN_INTEGRATION_TEST_OPTIONS=`-DargLine=""` \
  MAVEN_INTEGRATION_TEST_POM_FILE_PATH="drop/deploy/testing/workflow-test-azure/pom.xml" \
  SERVICE_RESOURCE_NAME='$(AZURE_INGESTION_WORKFLOW_SERVICE_NAME)' \
  -ojson
```

__Setup and Configure the ADO Library `Azure Service Release - seismic-store-service`__

This variable group is the service specific variables necessary for testing and deploying the `seismic-store-service` service.

| Variable                         | Value                                                                                   |
|----------------------------------|-----------------------------------------------------------------------------------------|
| e2eAdminEmail                    | <your_sslcert_admin_email>                                                              |
| e2eDataPartition                 | `opendes`                                                                               |
| e2eLegaltag01                    | `opendes-public-usa-dataset-7643990`                                                    |
| e2eLegaltag02                    | `opendes-dps-integration-test-valid2-legal-tag`                                         |
| e2eSubproject                    | `demo`                                                                                  |
| e2eSubprojectLongname            | `looooooooooooooooooooooooooooooooooooooooooooooooooooongnaaaaaaaaaaaaaaaaaaaameeeeeee` |
| e2eTenant                        | `opendes`                                                                               |
| PORT                             | `80`                                                                                    |
| REPLICA_COUNT                    | `1`                                                                                     |
| serviceUrlSuffix                 | `seistore-svc/api/v3`                                                                   |
| utest.mount.dir                  | `/service`                                                                              |
| utest.runtime.image              | `seistore-svc-runtime`                                                                  |

```bash
e2eAdminEmail="<your_cert_admin>"     # ie: admin@email.com
e2eDataPartition=opendes
e2eLegaltag01=opendes-public-usa-dataset-7643990
e2eLegaltag02=opendes-dps-integration-test-valid2-legal-tag
e2eSubproject=demo
e2eSubprojectLongname=looooooooooooooooooooooooooooooooooooooooooooooooooooongnaaaaaaaaaaaaaaaaaaaameeeeeee
e2eTenant=opendes
PORT="80"
REPLICA_COUNT="1"
serviceUrlSuffix="seistore-svc/api/v3"
utest.mount.dir="/service"
utest.runtime.image=seistore-svc-runtime

az pipelines variable-group create \
  --name "Azure Service Release - seismic-store-service" \
  --authorize true \
  --variables \
  e2eAdminEmail=${e2eAdminEmail} \
  e2eDataPartition=${e2eDataPartition} \
  e2eLegaltag01=${e2eLegaltag01} \
  e2eLegaltag02=${e2eLegaltag02} \
  e2eSubproject=${e2eSubproject} \
  e2eSubprojectLongname=${e2eSubprojectLongname} \
  e2eTenant=${e2eTenant} \
  PORT='${PORT}' \
  REPLICA_COUNT='${REPLICA_COUNT}' \
  serviceUrlSuffix='${serviceUrlSuffix}' \
  utest.mount.dir='${utest.mount.dir}' \
  utest.runtime.image=${utest.runtime.image} \
  -ojson
```

__Create the Chart Pipelines__

Create the pipelines and run things in this exact order.

1. Add a Pipeline for __chart-osdu-common__ to deploy common components.

    _Repo:_ `infra-azure-provisioning`
    _Path:_ `/devops/pipelines/chart-osdu-common.yml`
    _Validate:_ https://<your_dns_name> is alive.

```bash
az pipelines create \
  --name 'chart-osdu-common'  \
  --repository infra-azure-provisioning  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/pipelines/chart-osdu-common.yml  \
  -ojson
```

2. Add a Pipeline for __chart-osdu-istio__  to deploy Istio components.

    _Repo:_ `infra-azure-provisioning`
    _Path:_ `/devops/pipelines/chart-osdu-istio.yml`
    _Validate:_ Pods are running in Istio Namespace.

```bash
az pipelines create \
  --name 'chart-osdu-istio'  \
  --repository infra-azure-provisioning  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/pipelines/chart-osdu-istio.yml  \
  -ojson
```


3. Add a Pipeline for __chart-osdu-istio-auth__  to deploy Istio Authorization Policies.

    _Repo:_ `infra-azure-provisioning`
    _Path:_ `/devops/pipelines/chart-osdu-istio-auth.yml`
    _Validate:_ Authorization Policies exist in osdu namespace.

```bash
az pipelines create \
  --name 'chart-osdu-istio-auth'  \
  --repository infra-azure-provisioning  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/pipelines/chart-osdu-istio-auth.yml  \
  -ojson
```

4. Add a Pipeline for __chart-osdu-airflow__  to deploy Istio Authorization Policies.

    _Repo:_ `infra-azure-provisioning`
    _Path:_ `/devops/pipelines/chart-airflow.yml`
    _Validate:_ Airflow Pods are running except for airflow-setup-default-user which is a job pod.

```bash
az pipelines create \
  --name 'chart-airflow'  \
  --repository infra-azure-provisioning  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/pipelines/chart-airflow.yml  \
  -ojson
```

__Create the Service Pipelines__

Create the pipelines and run things in this exact order.

1. Add a Pipeline for __service-partition__  to deploy the Partition Service.

    _Repo:_ `partition`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/partition/v1/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-partition'  \
  --repository partition  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

**Stop here**. Before you continue, you must register your partition with the Data Partition API by following the instructions [here](../tools/rest/README.md) to configure your IDE to make authenticated requests to your OSDU instance and send the API request located [here](../tools/rest/partition.http) (createPartition).

2. Add a Pipeline for __service-entitlements-azure__  to deploy the Entitlements Service.
    > This pipeline may have to be run twice for integration tests to pass due to a preload data issue.

    _Repo:_ `entitlements-azure`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/entitlements/v1/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-entitlements-azure'  \
  --repository entitlements-azure  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```


3. Add a Pipeline for __service-legal__  to deploy the Legal Service.

    _Repo:_ `legal`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/legal/v1/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-legal'  \
  --repository legal  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

4. Add a Pipeline for __service-storage__  to deploy the Storage Service.

    _Repo:_ `storage`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/storage/v2/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-storage'  \
  --repository storage  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```


5. Add a Pipeline for __service-indexer-queue__  to deploy the Indexer Queue Function.

    _Repo:_ `indexer-queue`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ ScaledObject exist in osdu namespace.

```bash
az pipelines create \
  --name 'service-indexer-queue'  \
  --repository indexer-queue  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

6. Add a Pipeline for __service-indexer__  to deploy the Indexer Service.

    _Repo:_ `indexer-service`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/indexer/v2/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-indexer'  \
  --repository indexer-service  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

7. Add a Pipeline for __service-search__  to deploy the Search Service.

    _Repo:_ `search-service`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/search/v2/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-search'  \
  --repository search-service  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

8. Add a Pipeline for __file__  to deploy the File Service.

    _Repo:_ `file`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/file/v2/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-file'  \
  --repository file  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

9. Add a Pipeline for __delivery__  to deploy the Delivery Service.

    _Repo:_ `delivery`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/delivery/v2/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-delivery'  \
  --repository delivery  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

10. Add a Pipeline for __schema__  to deploy the Schema Service.

    _Repo:_ `schema-service`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/schema-service/v1/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-schema'  \
  --repository schema-service  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

11. Add a Pipeline for __unit__  to deploy the Unit Service.

    _Repo:_ `unit-service`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/unit/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-unit'  \
  --repository unit-service  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

12. Add a Pipeline for __crs-catalog-service__  to deploy the Crs Catalog Service.

    _Repo:_ `crs-catalog-service`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/crs/catalog/swagger-ui.html

```bash
az pipelines create \
  --name 'service-crs-catalog'  \
  --repository crs-catalog-service  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

13. Add a Pipeline for __crs-conversion-service__  to deploy the Crs Conversion Service.

    _Repo:_ `crs-conversion-service`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/crs/converter/swagger-ui.html

```bash
az pipelines create \
  --name 'service-crs-conversion'  \
  --repository crs-conversion-service  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```


14. Add a Pipeline for __register__  to deploy the Register Service.

    _Repo:_ `register`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/register/v1/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-register'  \
  --repository register  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

15. Add a Pipeline for __notification__  to deploy the Notification Service.

    _Repo:_ `notification-service`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/notification/v1/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-notification'  \
  --repository notification  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

16. Add a Pipeline for __wks__  to deploy the Wks Service.

    _Repo:_ `wks`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ ScaledObject exist in osdu namespace.

```bash
az pipelines create \
  --name 'service-wks'  \
  --repository wks  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

17. Add a Pipeline for __ingestion-workflow__  to deploy the Schema Service.

    _Repo:_ `ingestion-workflow`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/workflow/v1/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-ingestion-workflow'  \
  --repository ingestion-workflow  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```
18. Add a Pipeline for __seismic-store-service__  to deploy the Seismic Store Service.

    _Repo:_ `seismic-store-service`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>//seistore-svc/api/v3/svcstatus is alive.

```bash
az pipelines create \
  --name 'service-seismic-store'  \
  --repository seismic-store-service  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```

19. Add a Pipeline for __service-entitlements__  to deploy the Entitlements Service.
    > This pipeline may have to be run twice for integration tests to pass due to a preload data issue.

    _Repo:_ `entitlements`
    _Path:_ `/devops/azure/pipeline.yml`
    _Validate:_ https://<your_dns_name>/api/entitlements/v2/swagger-ui.html is alive.

```bash
az pipelines create \
  --name 'service-entitlements'  \
  --repository entitlements  \
  --branch master  \
  --repository-type tfsgit  \
  --yaml-path /devops/azure/pipeline.yml  \
  -ojson
```
