## Upgade keda version from 1.5 to 2.x

We've used feature flag to upgrade keda version from 1.5 to 2.x osdu infra on azure.
A user can follow following steps to upgrade keda version - 

1. We've set keda_v2_enabled field in feature_flag variable in service resource to false.
It represents that currently osdu infra is currently using 1.5 version.
2. If using flux, reduce replica count to 0 for flux deployment until step 4. (use command - kubectl edit deployment flux -n flux)
3. Either run it or follow the steps in this script - infra/scripts/keda_upgrade_and_host_encryption.sh. 
   This script requires some inputs. Feel free to edit the script as per requirement.
4. Override keda_v2_enabled field to true.


Service deployment steps for manual users - 
1. We've added a variable named (keda.version_2_enabled: false) in Values.yaml for following files in helm-charts-azure repo-
    - osdu-airflow/values.yaml
    - osdu-azure/osdu-core_services/values.yaml 
    - osdu-azure/osdu-ingest_enrich/values.yaml 
    
2. Override (keda.version_2_enabled: false) value to true.
3. Make the deployment.

Service deployment steps for automated pipeline users - 
1. We've added a variable named (keda.version_2_enabled: false) in Values.yaml in indexer-queue repo.
2. Override (keda.version_2_enabled: false) value here to true.
3. Make the deployment
   
    
