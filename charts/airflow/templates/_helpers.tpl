{{ define "airflow.pgbouncer_config" }}
[databases]
{{ .Values.pgbouncer.airflowdb.name }} = host={{ .Values.pgbouncer.airflowdb.host }} dbname={{ .Values.pgbouncer.airflowdb.name }} port={{ .Values.pgbouncer.airflowdb.port }} pool_size={{ .Values.pgbouncer.airflowdb.pool_size }}

[pgbouncer]
pool_mode = transaction
listen_port = {{ .Values.pgbouncer.port }}
server_tls_sslmode = require
listen_addr = 0.0.0.0
auth_type = trust
auth_file = /etc/pgbouncer/users.txt
ignore_startup_parameters = extra_float_digits
max_client_conn = {{ .Values.pgbouncer.max_client_connections }}
verbose = 0
log_disconnections = 0
log_connections = 0
user = postgres
admin_users = postgres
{{- end }}

{{ define "airflow.pgbouncer_users_template" }}
"${AIRFLOW_DATABASE_USERNAME}" "${AIRFLOW_DATABASE_PASSWORD}"
{{- end }}