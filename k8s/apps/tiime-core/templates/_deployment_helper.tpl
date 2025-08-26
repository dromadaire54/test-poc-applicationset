{{- define "tiime-core.database.configmapName" -}}
{{ printf "%s-database-configmap" $.Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "tiime-core.database.secretName" -}}
{{ printf "%s-database-secret" $.Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "tiime-core.database.pgbouncerName" -}}
{{ printf "%s-database-pgbouncer" $.Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "tiime-core.database.pgbouncerServiceName" -}}
{{ include "tiime-core.database.pgbouncerName" . }}-service
{{- end }}

{{- define "tiime-core.deployment.env"}}
{{- include "tiime-core.database_config" (dict "config" (include "tiime-core.database.configmapName" .root) "secret" (include "tiime-core.database.secretName" .root) "pgbouncer" .pgbouncer "namespace" .root.Release.Namespace "pgbouncerService" (include "tiime-core.database.pgbouncerServiceName" .root )) }}
{{- end}}