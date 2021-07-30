from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.dummy_operator import DummyOperator

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'schedule_interval': None,
    'start_date': days_ago(2),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False
}

dag = DAG('test_dummy_dag', schedule_interval=None, default_args=default_args)

# t1, t2, t3 and t4 are examples of tasks created using operators
dummy_task = DummyOperator(task_id='dummy', dag=dag)
