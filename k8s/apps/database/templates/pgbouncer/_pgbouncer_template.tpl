{{- define "pgbouncer_config" }}
- name: POSTGRESQL_HOST
  valueFrom:
    configMapKeyRef:
      name: "{{ include "database.configmapName" . }}"
      key: "host"
- name: POSTGRESQL_PORT
  valueFrom:
    configMapKeyRef:
      name: "{{ include "database.configmapName" . }}"
      key: "port"
- name: POSTGRESQL_USERNAME
  valueFrom:
    configMapKeyRef:
      name: "{{ include "database.configmapName" . }}"
      key: "user"
- name: POSTGRESQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: "{{ include "database.secretName" . }}"
      key: password
- name: PGBOUNCER_STATS_USERS
  valueFrom:
    configMapKeyRef:
      name: "{{ include "database.configmapName" . }}"
      key: "user" 
- name: POSTGRESQL_DATABASE
  valueFrom:
    configMapKeyRef:
      name: "{{ include "database.configmapName" . }}"
      key: "name" 
- name: PGBOUNCER_DATABASE
  valueFrom:
    configMapKeyRef:
      name: "{{ include "database.configmapName" . }}"
      key: "name" 
- name: PGBOUNCER_PORT
  value: "6432"
{{- end }}
