# Helpers for the worker resources
{{- define "worker.labels" -}}
{{ include "tiime-core.labels" . }}
component: worker
{{- end }}

{{- define "worker.selectorLabels" -}}
{{ include "tiime-core.selectorLabels" . }}
component: worker
{{- end }}

{{- define "worker.name" -}}
{{ printf "%s" .name | trunc 63 | trimSuffix "-" }}
{{- end }}
