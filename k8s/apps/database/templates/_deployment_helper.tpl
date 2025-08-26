{{- define "database.deployment.env"}}
{{- include "tiime-core.database_config" (dict "config" (include "database.configmapName" .root) "secret" (include "database.secretName" .root) "pgbouncer" .pgbouncer "namespace" .root.Release.Namespace "pgbouncerService" (include "database.pgbouncer.serviceName" .root )) }}
{{- end}}