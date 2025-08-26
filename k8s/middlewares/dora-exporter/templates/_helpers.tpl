{{- define "dora.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 50 | trimSuffix "-" -}}
{{- end }}

{{/* Generate basic labels */}}
{{- define "dora.labels" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: "{{ replace "+" "_" .Chart.Version }}"
app.kubernetes.io/part-of: {{ template "dora.name" . }}
release: {{ $.Release.Name | quote }}
heritage: {{ $.Release.Service | quote }}
{{- if .Values.dora.commonLabels}}
{{ toYaml .Values.dora.commonLabels }}
{{- end }}
{{- end }}
