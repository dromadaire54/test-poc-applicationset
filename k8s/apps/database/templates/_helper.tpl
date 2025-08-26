# Helpers for the database resources
{{- define "database.configmapName" -}}
{{ printf "%s-database-configmap" $.Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "database.secretName" -}}
{{ printf "%s-database-secret" $.Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "database.labels" -}}
{{ include "tiime-core.labels" . }}
component: database
{{- end }}