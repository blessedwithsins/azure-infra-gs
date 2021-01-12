#   Copyright © Microsoft Corporation
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

import datetime
import os
from typing import Any, Callable, FrozenSet, Iterable, Optional, Union

from sqlalchemy import func

from airflow.exceptions import AirflowException
from airflow.models import BaseOperatorLink, DagBag, DagModel, DagRun, TaskInstance
from airflow.operators.dummy_operator import DummyOperator
from airflow.sensors.base_sensor_operator import BaseSensorOperator
from airflow.utils.decorators import apply_defaults
from airflow.utils.db import provide_session
from airflow.utils.state import State



class DagStatusSensor(BaseSensorOperator):
    """
    Waits for a different DAG or a task in a different DAG to complete for a
    specific run id

    :param external_dag_id: The dag_id that you want to wait for
    :type external_dag_id: str
    :param external_dag_run_id: The run_id that you want to wait for.
    :type external_task_id: str
    :param allowed_states: Iterable of allowed states, default is ``['success']``
    :type allowed_states: Iterable
    :param failed_states: Iterable of failed or dis-allowed states, default is ``None``
    :type failed_states: Iterable
    """

    template_fields = ['external_dag_id','external_dag_run_id']
    ui_color = '#19647e'

    @apply_defaults
    def __init__(
        self,
        *,
        external_dag_id: str,
        external_dag_run_id: str,
        allowed_states: Optional[Iterable[str]] = None,
        failed_states: Optional[Iterable[str]] = None,
        check_existence: bool = False,
        **kwargs,
    ):
        super().__init__(**kwargs)
        self.allowed_states = list(allowed_states) if allowed_states else [State.SUCCESS]
        self.failed_states = list(failed_states) if failed_states else []

        total_states = self.allowed_states + self.failed_states
        total_states = set(total_states)

        if set(self.failed_states).intersection(set(self.allowed_states)):
            raise AirflowException(
                "Duplicate values provided as allowed "
                "`{}` and failed states `{}`".format(self.allowed_states, self.failed_states)
            )

        if not total_states <= set(State.dag_states):
            raise ValueError(
                f'Valid values for `allowed_states` and `failed_states` '
                f'when `external_task_id` is `None`: {State.dag_states}'
            )

        self.external_dag_id = external_dag_id
        self.external_dag_run_id = external_dag_run_id
        self.check_existence = check_existence
        self._has_checked_existence = False

    @provide_session
    def poke(self, context, session=None):
        
        self.log.info(
            'Poking for %s on %s ... ', self.external_dag_id, self.external_dag_run_id
        )

        # In poke mode this will check dag existence only once
        if self.check_existence and not self._has_checked_existence:
            self._check_for_existence(session=session)

        count_allowed = self.get_count(session, self.allowed_states)

        count_failed = -1
        if self.failed_states:
            count_failed = self.get_count(session, self.failed_states)

        if count_failed == 1:
            if self.external_task_id:
                raise AirflowException(
                    f'The external task {self.external_task_id} in DAG {self.external_dag_id} failed.'
                )
            else:
                raise AirflowException(f'The external DAG {self.external_dag_id} failed.')

        return count_allowed == 1

    def _check_for_existence(self, session) -> None:
        dag_to_wait = session.query(DagModel).filter(DagModel.dag_id == self.external_dag_id).first()

        if not dag_to_wait:
            raise AirflowException(f'The external DAG {self.external_dag_id} does not exist.')

        if not os.path.exists(dag_to_wait.fileloc):
            raise AirflowException(f'The external DAG {self.external_dag_id} was deleted.')

        if self.external_task_id:
            refreshed_dag_info = DagBag(dag_to_wait.fileloc).get_dag(self.external_dag_id)
            if not refreshed_dag_info.has_task(self.external_task_id):
                raise AirflowException(
                    f'The external task {self.external_task_id} in '
                    f'DAG {self.external_dag_id} does not exist.'
                )
        self._has_checked_existence = True

    def get_count(self, session, states) -> int:
        """
        Get the count of records against dag_id, run_id and states

        :param session: airflow session object
        :type session: SASession
        :param states: task or dag states
        :type states: list
        :return: count of record against the filters
        """
        TI = TaskInstance
        DR = DagRun
        
        count = (
            session.query(func.count())
            .filter(
                DR.dag_id == self.external_dag_id,
                DR.run_id == self.external_dag_run_id,
                DR.state.in_(states),  # pylint: disable=no-member
            )
            .scalar()
        )
        return count