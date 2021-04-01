# Airflow Scalability Guide

This FAQ guide will help you configure airflow to scale according to the needs of the customer

### How to scale airflow to execute 500 concurrent tasks across multiple DAG's?

We need to set the airflow configuration as mentioned below
- AIRFLOW__CORE__PARALLELISM: 500 (this value can be increased to 1000 or more if you are ok to have queued tasks)
- AIRFLOW__CORE__MAX_ACTIVE_RUNS_PER_DAG: 500
- AIRFLOW__CORE__DAG_CONCURRENCY: 500
- AIRFLOW__CELERY__WORKER_CONCURRENCY: 25 (this value depends on the resource consumption of the task)

We need 20 airflow worker pods to be launched with the above configuration to process 500 concurrent tasks

The suggested resource requests for airflow scheduler pod is
- CPU : 3000m
- Memory: 2048Mi

We need to increase the airflow default pool size from 128 to 500 (this value can be increased to 1000 or more if you are ok to have queued tasks)

### How to figure out the worker concurrency for an airflow worker?
Worker concurrency of an airflow worker is highly dependent on resource consumption of the tasks

If a task consumes 100m CPU and and 100Mi of memory and resources available to the worker pod is 2000m CPU and 2000Mi memory the worker concurrency
can be set to 20

Worker concurrency can also be increased by allocating more resources to the worker pod

**Note:** Highly suggested to set resource requests for airflow worker pods

### How many airflow worker pods are needed to execute 500 concurrent tasks?
As a prerequisite we need to determine the worker concurrency for airflow worker pod

Lets say the worker concurrency is 25, in order to execute 500 concurrent tasks the number of airflow worker pods needed are 20 (500 / 25 = 20)

### How to change airflow configuration?
To change the airflow configuration it requires adding/updating in `config` section of [helm-config.yaml](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/airflow/helm-config.yaml#L136)

**Example:** If you want to change AIRFLOW__CORE__DAG_CONCURRENCY to say 100
```
airflow:
    config:
      # Do not remove the existing configuration
      AIRFLOW__CORE__DAG_CONCURRENCY: 100 # Newly added configuration
```

### How to increase default pool size of airflow?
To increase default pool size the configuration for scheduler needs to be changed in [helm-config.yaml](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/airflow/helm-config.yaml#L128)

**Example:** If you want to change default pool size to say 1000
```
scheduler:
    # Below configuration needs to be added, do not remove exisiting configuration
    pools: |
      {
        "default_pool": {
          "description": "This is a default pool",
          "slots": 1000
        }
      }
```

### How to change resource requests for airflow scheduler?
To change resource requests for airflow scheduler the configuration for scheduler needs to be changed in [helm-config.yaml](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/airflow/helm-config.yaml#L128)

**Example:** If you want to change resource requests to 3000m cpu and 2048Mi memory
```
scheduler:
    # Below configuration needs to be added, do not remove exisiting configuration
    resources:
      requests:
        cpu: "3000m"
        memory: "2048Mi"
```

### How to change resource requests for airflow workers?
To change resource requests for airflow worker the configuration for worker needs to be changed in [helm-config.yaml](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/airflow/helm-config.yaml#L101)

**Example:** If you want to change resource requests to 2000m cpu and 1024Mi memory
```
workers:
    # Below configuration needs to be added, do not remove exisiting configuration
    resources:
      requests:
        cpu: "2000m"
        memory: "1024Mi"

```

### How to resolve airflow worker pods which are stuck in Pending state?
There are mainly two reasons for airflow worker pods not able to get into running state
- The maximum node limit might have reached on AKS cluster, hence increasing the node limit will let AKS to provision new nodes thereby changing the pod state from Pending to running
- Another reason is even though the node limit is increased the new nodes are not getting launched, this issue is related to exhaustion of subnet address space used by virtual machine scale set used by AKS


### How to scale airflow webserver to execute 100 requests per second for Trigger Dag and Get Dag Run Status APIs

The below configurations are recommended ones for airflow webserver
- AIRFLOW__WEBSERVER__WORKERS: 10 (Number of workers to run the Gunicorn web server)
- AIRFLOW__WEBSERVER__WORKER_REFRESH_BATCH_SIZE: 0 (Number of seconds to wait before refreshing a batch of workers)
- AIRFLOW__CORE__STORE_SERIALIZED_DAGS: True (Whether to serialise DAGs and persist them in DB. If set to True, Webserver reads from DB instead of parsing DAG files)
- AIRFLOW__CORE__STORE_DAG_CODE: True (Whether to persist DAG files code in DB. If set to True, Webserver reads file contents from DB instead of trying to access files in a DAG folder)
- AIRFLOW__WEBSERVER__WORKER_CLASS: gevent (The worker class gunicorn should use)
- AIRFLOW__CORE__MIN_SERIALIZED_DAG_UPDATE_INTERVAL: 300 (Updating serialized DAG can not be faster than a minimum interval to reduce database write rate)
- AIRFLOW__CORE__MIN_SERIALIZED_DAG_FETCH_INTERVAL: 300 (This config controls when your DAGs are updated in the Webserver)


For the below configurations 
1. AIRFLOW__CORE__MIN_SERIALIZED_DAG_UPDATE_INTERVAL 
2. AIRFLOW__CORE__MIN_SERIALIZED_DAG_FETCH_INTERVAL

The value should be reduced/increased as per need basis


We will need around 12 airflow webserver containers to hold this load consistently for long durations
This can be changed by adding below configuration in [helm-config.yaml](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/airflow/helm-config.yaml#L93)
```
web:
    replicas: 12
```
The suggested resource requests and limit for airflow webserver pod in Kubernetes is
- CPU : Request - 3000m, Limits - 3800m
- Memory: Request - 2Gi, Limit - 2Gi

We will need to increase the default timeout value for liveness probe from 3 seconds to 60 seconds
The default value of 3s can result in frequent pod restarts

This can be changed by adding below configuration in [helm-config.yaml](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/airflow/helm-config.yaml#L93)

```
web:
    - livenessProbe:
        timeoutSeconds: 60
```

### How to change resource requests for airflow webserver?
To change resource requests for airflow webserver the configuration for webserver needs to be changed in [helm-config.yaml](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/blob/master/charts/airflow/helm-config.yaml#L93)

**Example:** If you want to change resource requests to 3000m cpu and 2048Mi memory
```
web:
    # Below configuration needs to be added, do not remove exisiting configuration
        resources:
          requests:
            cpu: 3000m
            memory: 2Gi
          limits:
            cpu: 3800m
            memory: 2Gi    
```
