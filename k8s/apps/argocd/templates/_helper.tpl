{{- define "argocd.app.spec" -}}
spec:
  destination:
    {{- if hasKey (.template.spec.destination) "namespace" }}
    namespace: {{ .template.spec.destination.namespace }}
    {{- else }}
    namespace: {{ (.default.spec.destination).namespace | required "A valid .default.template.spec.destination.namespace entry required!" }}
    {{- end }}
    server: 'https://kubernetes.default.svc'
  source:
    repoURL: {{ ((.template.spec).source).repoURL | squote | required "A valid .template.spec.source.repoURL entry required!" }}
    targetRevision: {{ ((.template.spec).source).targetRevision | quote | required "A valid spec.source.targetRevision entry required!" }}
    {{- if hasKey .template.spec.source "path" }}
    path: {{ .template.spec.source.path | quote }}
    {{- end }}
    {{- if hasKey .template.spec.source "chart" }}
    chart: {{ .template.spec.source.chart | quote }}
    {{- end }}
    {{- if hasKey .template.spec.source "helm" }}
    helm:
      {{- if hasKey .template.spec.source.helm "releaseName" }}
      releaseName: {{ .template.spec.source.helm.releaseName }}
      {{- end }}
      {{- if .template.spec.source.helm.skipCrds }}
      skipCrds: true
      {{- end }}
      {{- if hasKey .template.spec.source.helm "parameters" }}
      parameters:
        {{ toYaml .template.spec.source.helm.parameters | nindent 6 }}
      {{- end }}
      {{- if hasKey .template.spec.source.helm "valueFiles" }}
      valueFiles:
        {{- range .template.spec.source.helm.valueFiles }}
        - {{ . }}
        {{- end }}
      {{- end }}
      {{- if hasKey .template.spec.source.helm "ignoreMissingValueFiles" }}
      ignoreMissingValueFiles: {{ .template.spec.source.helm.ignoreMissingValueFiles }}
      {{- end }}
      {{- if hasKey (((.template.spec).source).helm) "values" }}
      values: {{ toYaml .template.spec.source.helm.values | indent 6 }}
      {{- end }}
    {{- end }}
    {{- if hasKey .template.spec.source "directory" }}
      {{- if .template.spec.source.directory.recurse }}
    directory:
      recurse: true
      {{- end }}
    {{- end }}
  project: {{ (.template.spec).project | default .default.spec.project | required "A valid .template.spec.project entry required!" }}
  {{- if or (hasKey .template.spec "syncPolicy") (hasKey .default.spec "syncPolicy") }}
  syncPolicy:
  {{- end }}
    {{- if hasKey ((.template.spec).syncPolicy) "automatedEnableDefaultConfig" }}
    {{- if .template.spec.syncPolicy.automatedEnableDefaultConfig }}
    automated:
      prune: true
      selfHeal: true
      allowEmpty: true
    {{- end }}
    {{- else if hasKey ((.template.spec).syncPolicy) "automated" }}
    automated:
      prune: {{ .template.spec.syncPolicy.automated.prune }}
      selfHeal: {{ .template.spec.syncPolicy.automated.selfHeal }}
      allowEmpty: {{ .template.spec.syncPolicy.automated.allowEmpty }}
    {{- else if hasKey ((.default.spec).syncPolicy) "automated" }}
    automated:
      prune: {{ .default.spec.syncPolicy.automated.prune }}
      selfHeal: {{ .default.spec.syncPolicy.automated.selfHeal }}
      allowEmpty: {{ .default.spec.syncPolicy.automated.allowEmpty }}
    {{- end }}
    {{- if hasKey ((.template.spec).syncPolicy) "managedNamespaceMetadata" }}
    managedNamespaceMetadata:
      {{- if hasKey .template.spec.syncPolicy.managedNamespaceMetadata "labels" }}
      labels:
      {{ .template.spec.syncPolicy.managedNamespaceMetadata.labels | toYaml | indent 2 }}
      {{- end }}
    {{- end }}
    {{- if hasKey ((.template.spec).syncPolicy) "syncOptions" }}
    syncOptions:
    {{- range .template.spec.syncPolicy.syncOptions }}
      - {{ . }}
    {{- end }}
    {{- else if hasKey ((.default.spec).syncPolicy) "syncOptions" }}
    syncOptions:
    {{- range .default.spec.syncPolicy.syncOptions }}
      - {{ . }}
    {{- end }}
    {{- end }}
    {{- if hasKey ((.template.spec).syncPolicy) "retry" }}
    retry:
      limit: {{ .template.spec.syncPolicy.retry.limit }}
      {{- if hasKey .template.spec.syncPolicy.retry "backoff" }}
      backoff:
        duration: {{ .template.spec.syncPolicy.retry.backoff.duration }}
        factor: {{ .template.spec.syncPolicy.retry.backoff.factor }}
        maxDuration: {{ .template.spec.syncPolicy.retry.backoff.maxDuration }}
      {{- end }}
    {{- else if hasKey (.default.spec.syncPolicy) "retry" }}
    retry:
      limit: {{ .default.spec.syncPolicy.retry.limit }}
      {{- if hasKey .default.spec.syncPolicy.retry "backoff" }}
      backoff:
        duration: {{ .default.spec.syncPolicy.retry.backoff.duration }}
        factor: {{ .default.spec.syncPolicy.retry.backoff.factor }}
        maxDuration: {{ .default.spec.syncPolicy.retry.backoff.maxDuration }}
      {{- end }}
    {{- end }}
    {{- if hasKey (.template.spec) "ignoreDifferences" }}
  ignoreDifferences:
{{- .template.spec.ignoreDifferences | toYaml | nindent 6 -}}
    {{- end }}
{{- end }}