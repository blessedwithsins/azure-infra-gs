## Airflow Helm Chart

This is the base airflow helm chart provided by apache community to install airflow components in kubernetes.

### How to make changes to airflow helm chart?

- Un tar the file by running this command - `tar -xvf airflow-7.5.0.tgz`
- The above step will extract folder `airflow`
- Make the required changes to the files in this folder
- Delete the existing tar file by running this command - `rm -rf airflow-7.5.0.tgz`
- Create a tar file out of above folder by running this command - `tar -cvzf airflow-7.5.0.tgz airflow/`
- Add the change description to the CHANGELOG [here](./CHANGELOG.md)
