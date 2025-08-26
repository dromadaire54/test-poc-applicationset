{{- define "monitoring.opentelemetry.env" }}
{{- if .php  }}
- name: OTEL_PHP_AUTOLOAD_ENABLED
  value: 'True'
{{- else if .node }}
- name: OTEL_NODE_RESOURCE_DETECTORS
  value: "env,host,os"
- name: NODE_OPTIONS
  value: "--require @opentelemetry/auto-instrumentations-node/register"
{{- end }}
- name: OTEL_TRACES_EXPORTER
  value: otlp
- name: OTEL_EXPORTER_OTLP_PROTOCOL
  value: http/protobuf
- name: OTEL_PROPAGATORS
  value: baggage,tracecontext
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: http://k8s-monitoring-alloy-receiver.metrology.svc.cluster.local:4318
- name: OTEL_SERVICE_NAME
  value: {{ .service_name }}
- name: OTEL_PHP_PSR3_MODE
  value: inject
- name: OTEL_RESOURCE_ATTRIBUTES
  value: service.version={{ .version }},namespace={{ .namespace }},deployment.environment={{ .environment }},job={{ .namespace }}/{{ .job_name }}
{{- end }}
