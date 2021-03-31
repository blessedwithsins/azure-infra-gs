# New DAG Onboarding

## Deploy DAGs to Airflow
To deploy the Ingestion DAGs to airflow, follow below steps.
- Identify the file share to which DAGs need to be copied. [This](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/infra/templates/osdu-r3-mvp/service_resources/airflow.tf#L71) is the file share where DAGs for airflow reside.
- Copy contents of */src/dags* to *airflowdags/dags* folder
- Copy contents of */src/plugins/hooks* to *airflowdags/plugins/hooks*
- Copy contents of */src/plugins/operators* to *airflowdags/plugins/operators*
- Copy contents of */src/plugins/sensors* to *airflowdags/plugins/sensors*

### Installing Python Dependencies
Python dependencies can be specified as extra pip packages in airflow deployment [here](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/airflow/helm-config.yaml#L211)

### Environment Variables & Airflow Variables
Add variables manually in the Airflow UI or through airflow helm charts. [List of the required variables](#required-variables).

Adding variables to helm charts can be found [here](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/airflow/helm-config.yaml#L157)

More details about airflow variables can be found [here](https://airflow.apache.org/docs/apache-airflow/1.10.12/concepts.html?highlight=airflow_var#variables)

## Register DAG
Workflow service can be used to trigger DAGs. To trigger a DAG it needs to be registered with workflow service first. Use below curl command to register the DAG
```
curl --location --request POST 'https://<WORKFLOW_HOST>/api/workflow/v1/workflow' \
--header 'Content-Type: application/json' \
--header 'Authorization: <AUTH_TOKEN>' \
--header 'data-partition-id: <DATA_PARTITION_ID>' \
--data-raw '{
  "workflowName": "<DAG_ID>",
  "description": "<DAG Description>",
  "registrationInstructions": {
  }
}
'
```
You should get a 200 success if it is registered for the first time. If already registered you will get 409 conflict and you can proceed further.

## Trigger DAG
A worfklow can be triggered by workflow service trigger API. Use below curl command to trigger the registered DAG.
```
curl --location --request POST 'https://<WORKFLOW_HOST>/api/workflow/v1/workflow/<WORKFLOW_NAME>/workflowRun' \
--header 'Content-Type: application/json' \
--header 'Authorization: <AUTH_TOKEN>' \
--header 'data-partition-id: <DATA_PARTITION_ID>' \
--data-raw '{
  "runId": "<ANY_GUID>",
  "executionContext": {
    
  }
}'
```
Any input needed by DAG can be passed in the `executionContext`. The `runId` can be used to track the status of a individual run. You will get 200 success response once the workflow service is able to trigger the DAG.

## Get DAG Run Status
Status of a triggered workflow can be found using workflow run API on workflow service. Use below curl command to get the status of workflow run
```
curl --location --request GET 'https://<WORKFLOW_HOST>/api/workflow/v1/workflow/<WORKFLOW_NAME>/workflowRun/<WORKFLOW_RUN_ID>' \
--header 'Content-Type: application/json' \
--header 'Authorization: <AUTH_TOKEN>' \
--header 'data-partition-id: <DATA_PARTITON_ID>' \
--header 'correlation-id: bce15de9-8eef-408e-b61e-b2decb6db09f'
```

**NOTE** Workflow service doesn't support multiple data partitions. By default it connects to opendes or any partition specificed through configuration.

## RBAC in Airflow UI, User Roles and Permissions

For more information on How to create users, manage users, creating roles and managing roles please refere the doc [here](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/docs/airflow-rbac-guide.md)