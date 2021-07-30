# CHANGELOG

## [90cdb1bc1597f74b34ec2a2fd369b460d9fc3251](https://community.opengroup.org/osdu/platform/deployment-and-operations/infra-azure-provisioning/-/commit/90cdb1bc1597f74b34ec2a2fd369b460d9fc3251)

- Fixed graceful termination script in `templates/configmap-scripts.yaml` under `graceful-stop-celery-worker.sh` where the `celery inspect` command is wrapped with `$()` to avoid syntax error if redis password contains special characters

Below is the change in `templates/configmap-scripts.yaml` under `graceful-stop-celery-worker.sh` 

**Actual code**
```bash
    while (( celery inspect --broker $AIRFLOW__CELERY__BROKER_URL --destination celery@$HOSTNAME --json active | python3 -c "import json;     active_tasks = json.loads(input())['celery@$HOSTNAME']; print(len(active_tasks))" > 0 )); do
      sleep 10
    done
```

**Changed code**
```bash
    while (( $(celery inspect --broker $AIRFLOW__CELERY__BROKER_URL --destination celery@$HOSTNAME --json active | python3 -c "import json; active_tasks = json.loads(input())['celery@$HOSTNAME']; print(len(active_tasks))") > 0 )); do
      sleep 10
    done
```