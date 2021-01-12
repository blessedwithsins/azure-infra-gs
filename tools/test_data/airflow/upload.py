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

"""
FILE: upload.py

DESCRIPTION:
    This script uploads common scenarios like instantiating a client,
    creating a file share, and uploading a file to a share.

USAGE:
    python file_samples_hello_world.py

    Set the environment variables with values before running the sample:
    1) AIRFLOW_FILE_SHARE_CONNECTION_STRING - the connection string to airflow storage account
"""

import os
import logging
import sys
from azure.core.exceptions import (
    ResourceExistsError,
    ResourceNotFoundError
)

from azure.storage.fileshare import (
    ShareServiceClient,
    ShareClient,
    ShareDirectoryClient,
    ShareFileClient
)
SOURCE_FILE_CONTROLLER = './controller.py'
DEST_FILE_CONTROLLER = 'dags/system/controller.py'
SOURCE_FILE_OPERATOR = './CustomDagRunOperator.py'
DEST_FILE_OPERATOR = 'plugins/operators/system/CustomDagRunOperator.py'
SOURCE_FILE_SENSOR = './DagStatusSensor.py'
DEST_FILE_SENSOR = 'plugins/sensors/system/DagStatusSensor.py'

class FileShareSamples(object):

    connection_string = os.getenv('AIRFLOW_FILE_SHARE_CONNECTION_STRING')
    share_name = "airflowdags"
    logger = logging.getLogger('azure.storage.fileshare')
    logger.setLevel(logging.DEBUG)
    handler = logging.StreamHandler(stream=sys.stdout)
    logger.addHandler(handler)

    def upload_file_to_share(self,source_path,dest_path):
        try:
            # Create the directory if not exists
            try:
                dir_name = os.path.dirname(dest_path)
                dir_client = ShareDirectoryClient.from_connection_string(
                self.connection_string, self.share_name, dir_name)

                print("Creating directory:", self.share_name + "/" + dir_name)
                dir_client.create_directory()
            except ResourceExistsError as ex:
                print("ResourceExistsError:", ex.message)
            
            # Instantiate the ShareFileClient from a connection string
            # [START create_file_client]
            file = ShareFileClient.from_connection_string(
                self.connection_string,
                share_name=self.share_name,
                file_path=dest_path, logging_enable=True)
            # [END create_file_client]

            # Upload a file
            with open(source_path, "rb") as source_file:
                file.upload_file(source_file)

        finally:
            print("END upload_file_to_share")

if __name__ == '__main__':
    sample = FileShareSamples()
    sample.upload_file_to_share(SOURCE_FILE_CONTROLLER,DEST_FILE_CONTROLLER)
    sample.upload_file_to_share(SOURCE_FILE_OPERATOR,DEST_FILE_OPERATOR)
    sample.upload_file_to_share(SOURCE_FILE_SENSOR,DEST_FILE_SENSOR)