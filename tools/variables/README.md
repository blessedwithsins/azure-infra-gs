# Service Level Environment Variables

This project hosts the service environment variables patterns.

__PreRequisites__

Requires the use of [direnv](https://direnv.net/).

__Log with environment ServicePrincipal__

The application created for OSDU by default does not have a Client Secret and one must be manually created.

```bash
# This logs your local Azure CLI in using the configured service principal.
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

export DNS_HOST=<your_fqdn>
export COMMON_VAULT=<your_common_vault>
export INVALID_JWT=<any_invalid_jwt>
```

__Create Service Environment Variables__

Generate the environment .envrc and yaml files compatable with intelliJ [envfile](https://plugins.jetbrains.com/plugin/7861-envfile) plugin.

```bash
for SERVICE in partition entitlements-azure entitlements legal storage indexer-service search-service delivery file unit crs-catalog register notification os-wellbore-dms;
do
  ./$SERVICE.sh
done
```

For each service, there are four files generated by each of these scripts in the `./$UNIQUE` directory:
* `./${UNIQUE}/${SERVICE}.envrc` file that contains all environment variale definitions required for the service to run as well as those required to run integration tests on the service.
* `${UNIQUE}/${SERVICE}_local.yaml` file that contains the environment variable definitions required to run the service locally.
* `${UNIQUE}/${SERVICE}_local_test.yaml` file that contains the environment variable definitions required to test the service while it is running locally.
* `${UNIQUE}/${SERVICE}_test.yaml` file that contains the environment variable definitions required to test the service that is running in your AKS cluster.
