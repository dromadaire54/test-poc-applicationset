{{- define "tiime-core.database_config" }}
- name: PGUSER
  valueFrom:
    configMapKeyRef:
      name: "{{ .config }}"
      key: "user"
- name: PGPASSWORD
  valueFrom:
    secretKeyRef:
      name: "{{ .secret }}"
      key: password
{{- if .pgbouncer  }}
- name: PGHOST
  value: {{ .pgbouncerService }}.{{ .namespace }}.svc.cluster.local
- name: PGPORT
  value: "6432"
{{- else }}
- name: PGHOST
  valueFrom:
    configMapKeyRef:
      name: "{{ .config }}"
      key: "host"
- name: PGPORT
  valueFrom:
    configMapKeyRef:
      name: "{{ .config }}"
      key: "port"
{{- end }}
- name: PGDATABASE
  valueFrom:
    configMapKeyRef:
      name: "{{ .config }}"
      key: "name"
- name: DATABASE_URL
  value: postgres://$(PGUSER):$(PGPASSWORD)@$(PGHOST):$(PGPORT)/{{.database | default "$(PGDATABASE)"}}
{{- end }}

{{- define "tiime-core.database_hook" }}
restartPolicy: Never
containers:
  - image: "{{ .image | default "postgres" }}:{{ .tag | default "17.4" }}"
    name: "{{ .name }}"
    {{- if hasKey . "sqlFile"  }}
    command:
      - "/bin/sh"
    args:
      - -c
      - |
        echo "Running SQL script {{ .sqlFile }} on database {{ .database | default "$(PGDATABASE)" }}"
        PGPASSWORD="$PGPASSWORD" psql -h "$PGHOST" -U "$PGUSER" -d "$PGDATABASE" -f "/config/{{ .sqlFile }}"
    {{- else }}
    command:
      {{- range .command }}
      - {{ . }}
      {{- end }}
    args:
      {{- range .args }}
      - {{ . }}
      {{- end }}
      {{- end }}
    env:
{{- include "tiime-core.database_config" (dict "config" .databaseConfigMapName "secret" .databaseSecretName ) | indent 8 }}
{{- if hasKey . "envConfigSecretName" }}
    envFrom:
      - secretRef:
          name: {{ .envConfigSecretName }}
{{- end }}
{{- if hasKey . "resources" }}
    resources:
      limits:
        {{ toYaml .resources.limits | indent 8  | trim }}
      requests:
        {{ toYaml .resources.requests | indent 8  | trim }}
{{- end }}
{{- if hasKey . "sqlFile" }}
    volumeMounts:
      - name: hook-config
        mountPath: "/config"
        readOnly: true
volumes:
  - name: hook-config
    configMap:
      name: {{ .hookConfigMapName }}
      items:
        - key: "{{ .sqlFile }}"
          path: "{{ .sqlFile }}"
{{- end }}
{{- end }}