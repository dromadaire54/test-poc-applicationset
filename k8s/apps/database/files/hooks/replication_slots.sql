{{- range .Values.hooks.replicationSlots.slots }}
{{- if .enabled }}
do $$ begin if not exists (select 1 from pg_publication where pubname = '{{ .name }}_publication') then execute 'create publication {{ .name }}_publication for all tables'; end if; end $$;
do $$ begin if not exists (select 1 from pg_replication_slots where slot_name = '{{ .name }}_replication_slot') then perform pg_create_logical_replication_slot('{{ .name }}_replication_slot', 'pgoutput'); end if; end $$;
{{- else }}
do $$ begin if exists (select 1 from pg_replication_slots where slot_name = '{{ .name }}_replication_slot') then perform pg_drop_replication_slot('{{ .name }}_replication_slot'); end if; end $$;
do $$ begin if exists (select 1 from pg_publication where pubname = '{{ .name }}_publication') then execute 'drop publication {{ .name }}_publication'; end if; end $$;
{{- end }}
{{- end }}