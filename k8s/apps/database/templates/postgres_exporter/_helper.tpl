{{- define "database.postgres_exporter.labels" -}}
{{- include "tiime-core.labels" . }}
component: postgres-exporter
{{- end }}

{{- define "database.postgres_exporter.extendedQueriesName" -}}
{{ printf "%s-database-postgres-exporter-extended-queries" $.Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}