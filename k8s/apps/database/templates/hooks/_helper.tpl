
# Helpers for the hooks resources
{{- define "database.hooks.configmapName" -}}
{{ printf "%s-database-hook-configmap" $.Release.Name}}
{{- end }}

{{- define "database.hooks.name" -}}
{{ printf "%s-database-hook-%s" .release (.name | lower) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "database.hooks.labels" -}}
{{ include "tiime-core.labels" . }}
component: hook
{{- end }}


# Dictionary for common hook values
# It includes the configmap and secret names for the database
{{- define "database.hooks.dict.common" -}}
{{ dict
    "hookConfigMapName"     (include "database.hooks.configmapName" .)
    "databaseConfigMapName" (include "database.configmapName" .)
    "databaseSecretName"    (include "database.secretName" .)
| toYaml }}
{{- end }}

# Dictionary for the teleport database hook
{{- define "database.hooks.dict.teleport" -}}
{{- $common := include "database.hooks.dict.common" . | fromYaml }}
{{- $dict := dict
    "name"    "database-teleport-hook"
    "sqlFile" "teleport.sql"
    "resources"    .Values.hooks.teleport.resources
}}
{{- merge $common $dict | toYaml }}
{{- end }}

# Dictionary for the replication slots database hook
{{- define "database.hooks.dict.replicationSlots" -}}
{{- $common := include "database.hooks.dict.common" . | fromYaml }}
{{- $dict := dict
    "name"    "database-replication-slots-hook"
    "sqlFile" "replication_slots.sql"
    "resources"    .Values.hooks.replicationSlots.resources 
}}
{{- merge $common $dict | toYaml }}
{{- end }}