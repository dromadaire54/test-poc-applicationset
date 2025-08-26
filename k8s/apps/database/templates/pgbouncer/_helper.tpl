{{- define "database.pgbouncer.labels" -}}
{{ include "tiime-core.labels" . }}
component: pgbouncer
{{- end }}

{{- define "database.pgbouncer.selectorLabels" -}}
{{ include "tiime-core.selectorLabels" . }}
component: pgbouncer
{{- end }}

{{- define "database.pgbouncer.name" -}}
{{ printf "%s-database-pgbouncer" $.Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}


{{- define "database.pgbouncer.serviceName" -}}
{{ include "database.pgbouncer.name" . }}-service
{{- end }}