{{- define "tiime-core.php.memory_extractor" }}
{{- if hasSuffix "Mi" . }}
{{- atoi (trimSuffix "Mi" .) }}
{{- else if hasSuffix "Gi" . }}
{{- int (mulf (float64 (trimSuffix "Gi" .)) 1024) }}
{{- else }}
{{- 1 }}
{{- end }}
{{- end }}

{{- define "tiime-core.php.memory_env" }}
{{- $memory := include "tiime-core.php.memory_extractor" . }}
- name: PHP_MEMORY_LIMIT
  value: "{{ sub $memory 50 }}"
- name: SWARROT_MEMORY_LIMIT
  value: "{{ sub $memory 60 }}"
{{- end }}

{{- define "tiime-core.new_relic_config" }}
{{- if and (.newRelicSplitEnabled) (eq .subProject "api") }}
- name: NEWRELIC_APPNAME
  value: "{{ $.Release.Name }}"
{{- else if and (.newRelicSplitEnabled) (eq .subProject "internal") }}
- name: NEWRELIC_APPNAME
  value: "{{ $.Release.Name }}-internal"
{{- else if and (.newRelicSplitEnabled) (eq .subProject "worker") }}
- name: NEWRELIC_APPNAME
  value: "{{ $.Release.Name }}-worker"
{{- else if and (.newRelicSplitEnabled) (eq .subProject "cronjob") }}
- name: NEWRELIC_DAEMON_HOST
  value: "newrelic-cronjob:31339"
- name: NEWRELIC_APPNAME
  value: "{{ $.Release.Name }}-cronjob"
{{- else }}
- name: NEWRELIC_APPNAME
  value: "{{ $.Release.Name }}"
{{- end }}
{{- end }}