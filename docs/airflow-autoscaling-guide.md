# Airflow Autoscaling Guide

Airflow autoscaling feature enables autoscaling on airflow components which are deployed in AKS cluster. Below are the airflow components which are auto scalable

- Airflow Web Server
- Airflow Worker

## Prerequisites

- Enable AKS cluster autoscaling by following instructions [here](docs/autoscaling.md)
- Upgrade KEDA from 1.5.0 to 2.2.0 by following instructions [here](docs/keda-upgrade.md)

## FAQ

### How to enable airflow web server autoscaling?

To enable autoscaling for service resources airflow cluster follow the below steps

- Change autoscale configuration to **true** in [helm-config.yaml](charts/airflow/helm-config.yaml) as mentioned below
```yaml
airflow:
    web:
        autoscale:
            enabled: true
```
- Change autoscale label to **true** in [helm-config.yaml](charts/airflow/helm-config.yaml) as mentioned below
```yaml
airflow:
    web:
        labels:
        # DO NOT DELETE THIS LABEL. SET IT TO "false" WHEN AUTOSCALING IS DISABLED, SET IT TO "true" WHEN AUTOSCALING IS    ENABLED
            autoscalingEnabled: "true"
```

To enable autoscaling for data partition specific airflow cluster follow the below steps

- Change autoscale configuration to **true** in [helm-config-dp.yaml](charts/airflow/helm-config-dp.yaml) as mentioned below
```yaml
airflow:
    web:
        autoscale:
            enabled: true
``` 

### How to enable airflow worker autoscaling?

To enable autoscaling for service resources airflow cluster follow the below steps

- Change KEDA version 2 feature flag to **true** in [helm-config.yaml](charts/airflow/helm-config.yaml) as mentioned below
```yaml
keda:
    version_2_enabled: true
```

- Change autoscale configuration to **true** in [helm-config.yaml](charts/airflow/helm-config.yaml) as mentioned below
```yaml
airflow:
    workers:
        autoscale:
            enabled: true
```
- Change autoscale label to **true** in [helm-config.yaml](charts/airflow/helm-config.yaml) as mentioned below
```yaml
airflow:
    workers:
        labels:
        # DO NOT DELETE THIS LABEL. SET IT TO "false" WHEN AUTOSCALING IS DISABLED, SET IT TO "true" WHEN AUTOSCALING IS    ENABLED
            autoscalingEnabled: "true"
```

To enable autoscaling for data partition specific airflow cluster follow the below steps

- Change KEDA version 2 feature flag to **true** in [helm-config-dp.yaml](charts/airflow/helm-config-dp.yaml) as mentioned below
```yaml
keda:
    version_2_enabled: true
```

- Change autoscale configuration to **true** in [helm-config-dp.yaml](charts/airflow/helm-config-dp.yaml) as mentioned below
```yaml
airflow:
    workers:
        autoscale:
            enabled: true
``` 

### What are the tuning parameters available for autoscaling and their significance?

| Parameter | Usage |
| ---      | ---      |
| minReplicas   | Minimum number of pods to be present   |
| maxReplicas | Maximum number of pods beyond which scaleup does not happen |
| scaleDown.coolDownPeriod  | Time interval between two scaledown events <br><br> **Example:** If a scaledown happened from 5 pods to 4 pods at 11:00 the next scaledown from 4 pods to 3 pods happens at 11:05 if the cooldown period is 5 minutes |

### How to set tuning parameters for autoscaling?

The above mentioned tuning parameters can be configured by following the steps below

- For service resources airflow cluster change autoscale tuning configuration in [helm-config.yaml](charts/airflow/helm-config.yaml) as mentioned below
- For data partition specific airflow cluster change autoscale tuning configuration in [helm-config-dp.yaml](charts/airflow/helm-config-dp.yaml) as mentioned below
```yaml
airflow:
    <web|workers>:
        autoscale:
            minReplicas: <Numerical value>
            maxReplicas: <Numerical value>
            scaleDown:
                coolDownPeriod: <Value in seconds>        
```

### What is graceful termination concept in airflow workers?

Airflow worker process can gracefully terminate when it receives a stop signal as part of pod termination, as part of this step the following happens on airflow worker process

- Airflow worker does not accept any new tasks
- Airflow worker will wait for the running tasks to complete
- Once the running tasks are completed the airflow worker terminates successfully

Kubernetes waits for a certain amount of time for the airflow worker pod to gracefully terminate, if it does not complete the graceful termination in the specified amount of time kubernetes will terminate it forcefully. 

### How to set graceful termination timeout for airflow workers?

To set the graceful termination timeout for airflow workers follow the steps below

- For service resources airflow cluster change graceful termination timeout in [helm-config.yaml](charts/airflow/helm-config.yaml) as mentioned below
- For data partition specific airflow cluster change graceful termination timeout in [helm-config-dp.yaml](charts/airflow/helm-config-dp.yaml) as mentioned below
```yaml
airflow:
    workers:
        celery:
            gracefullTermination: true
            gracefullTerminationPeriod: <Value in seconds>
```



