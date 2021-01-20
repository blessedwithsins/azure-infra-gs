import pprint
from airflow import DAG
from operators.system.CustomDagRunOperator import CustomDagRunOperator
from sensors.system.DagStatusSensor import DagStatusSensor
from airflow.utils.dates import days_ago
import json

pp = pprint.PrettyPrinter(indent=4)


def conditionally_trigger(context, dag_run_obj):
    """This function decides whether or not to Trigger the remote DAG"""
    print("Controller DAG : running")
    dag_run_obj.payload = context["dag_run"].conf
    dag_run_obj.payload.pop('_trigger_config', 'Key not found') 
    return dag_run_obj


dag = DAG(
    dag_id="_controller_dag",
    default_args={"owner": "airflow", "start_date": days_ago(2)},
    schedule_interval=None,
    tags=['controller']
)

def on_failure_callback(context):
    print("Child Dag run failed ", context.get('dag_run').conf['_trigger_config']['trigger_dag_run_id'])

def on_success_callback(context):
    print("Child Dag ran successfully", context.get('dag_run').conf['_trigger_config']['trigger_dag_run_id'])

trigger = CustomDagRunOperator(
    task_id='trigger_dagrun',
    trigger_dag_id="{{ dag_run.conf['_trigger_config']['trigger_dag_id'] }}",
    trigger_dag_run_id="{{ dag_run.conf['_trigger_config']['trigger_dag_run_id'] }}",
    execution_date="{{ execution_date }}",
    python_callable=conditionally_trigger,
    dag=dag,
)

task_sensor = DagStatusSensor(
    task_id="dag_staus",
    external_dag_id="{{ dag_run.conf['_trigger_config']['trigger_dag_id'] }}",
    external_dag_run_id="{{ dag_run.conf['_trigger_config']['trigger_dag_run_id'] }}",
    allowed_states=['success'],
    failed_states=['failed'],
    on_success_callback=on_success_callback,
    on_failure_callback=on_failure_callback,
    dag=dag,
)

trigger >> task_sensor
