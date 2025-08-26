# Helpers for the cronjob resources
{{- define "cronjob.labels" -}}
{{ include "tiime-core.labels" . }}
component: cronjob
{{- end }}

{{- define "cronjob.selectorLabels" -}}
{{ include "tiime-core.selectorLabels" . }}
component: cronjob
{{- end }}

{{- define "cronjob.name" -}}
{{ printf "%s" .name | trunc 63 | trimSuffix "-" }}
{{- end }}
