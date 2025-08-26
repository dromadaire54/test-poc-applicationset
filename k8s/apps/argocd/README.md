# argocd-template-helm

![Version: 1.0.3](https://img.shields.io/badge/Version-1.0.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.3](https://img.shields.io/badge/AppVersion-1.0.3-informational?style=flat-square)

Tiime template ArgoCD apps

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argoAppSets.test.annotations."argocd.argoproj.io/sync-wave" | string | `"-5"` |  |
| argoAppSets.test.elements[0].auto-sync | bool | `true` |  |
| argoAppSets.test.elements[0].env | string | `"preprod"` |  |
| argoAppSets.test.elements[0].version | string | `">=1.0.0"` |  |
| argoAppSets.test.enabled | bool | `true` |  |
| argoAppSets.test.finalizer | bool | `true` |  |
| argoAppSets.test.name | string | `"test-{{.env}}"` |  |
| argoAppSets.test.spec.destination.namespace | string | `"test-{{.env}}"` |  |
| argoAppSets.test.spec.ignoreDifferences[0].group | string | `"apps"` |  |
| argoAppSets.test.spec.ignoreDifferences[0].jsonPointers[0] | string | `"/spec/template/metadata/annotations/checksum~1config"` |  |
| argoAppSets.test.spec.ignoreDifferences[0].kind | string | `"Deployment"` |  |
| argoAppSets.test.spec.ignoreDifferences[1].group | string | `"batch"` |  |
| argoAppSets.test.spec.ignoreDifferences[1].jsonPointers[0] | string | `"/spec/schedule"` |  |
| argoAppSets.test.spec.ignoreDifferences[1].kind | string | `"CronJob"` |  |
| argoAppSets.test.spec.ignoreDifferences[1].name | string | `"linkerd-heartbeat"` |  |
| argoAppSets.test.spec.project | string | `"OverridedProject"` |  |
| argoAppSets.test.spec.source.chart | string | `"myChart"` |  |
| argoAppSets.test.spec.source.helm.releaseName | string | `"myHelmApps-{{.env}}-release"` |  |
| argoAppSets.test.spec.source.helm.skipCrds | bool | `true` |  |
| argoAppSets.test.spec.source.helm.valueFiles[0] | string | `"values-{{.env}}.yaml"` |  |
| argoAppSets.test.spec.source.helm.values | string | `"key: value\nkey.subkey: value\nfoo:\n  bar: toto\n"` |  |
| argoAppSets.test.spec.source.repoURL | string | `"https://example.com/helm-chart"` |  |
| argoAppSets.test.spec.source.targetRevision | string | `"{{.version}}"` |  |
| argoAppSets.test.spec.syncPolicy.managedNamespaceMetadata.labels | string | `"key: value \n"` |  |
| argoAppSets.test.spec.syncPolicy.retry.backoff.duration | string | `"5s"` |  |
| argoAppSets.test.spec.syncPolicy.retry.backoff.factor | int | `2` |  |
| argoAppSets.test.spec.syncPolicy.retry.backoff.maxDuration | string | `"3m"` |  |
| argoAppSets.test.spec.syncPolicy.retry.limit | int | `5` |  |
| argoAppSets.test.spec.syncPolicy.syncOptions[0] | string | `"Validate=true"` |  |
| argoApps.myGitApps.appsNameOverride | string | `"myname"` |  |
| argoApps.myGitApps.enabled | bool | `true` |  |
| argoApps.myGitApps.finalizer | bool | `true` |  |
| argoApps.myGitApps.spec.source.directory.recurse | bool | `true` |  |
| argoApps.myGitApps.spec.source.path | string | `"."` |  |
| argoApps.myGitApps.spec.source.repoURL | string | `"https://example.com/repo.git"` |  |
| argoApps.myGitApps.spec.source.targetRevision | string | `"master"` |  |
| argoApps.myGitApps.spec.syncPolicy.automatedEnableDefaultConfig | bool | `true` |  |
| argoApps.myHelmApps-from-repo-git.enabled | bool | `true` |  |
| argoApps.myHelmApps-from-repo-git.finalizer | bool | `true` |  |
| argoApps.myHelmApps-from-repo-git.spec.source.helm.parameters[0].name | string | `"param1"` |  |
| argoApps.myHelmApps-from-repo-git.spec.source.helm.parameters[0].value | string | `"values1"` |  |
| argoApps.myHelmApps-from-repo-git.spec.source.helm.parameters[1].name | string | `"param2"` |  |
| argoApps.myHelmApps-from-repo-git.spec.source.helm.parameters[1].value | string | `"value2"` |  |
| argoApps.myHelmApps-from-repo-git.spec.source.helm.valueFiles[0] | string | `"myvalues.yaml"` |  |
| argoApps.myHelmApps-from-repo-git.spec.source.path | string | `"mychart"` |  |
| argoApps.myHelmApps-from-repo-git.spec.source.repoURL | string | `"https://example.com/repo.git"` |  |
| argoApps.myHelmApps-from-repo-git.spec.source.targetRevision | string | `"master"` |  |
| argoApps.myHelmApps-from-repo-helm.annotations."argocd.argoproj.io/sync-wave" | string | `"-5"` |  |
| argoApps.myHelmApps-from-repo-helm.enabled | bool | `true` |  |
| argoApps.myHelmApps-from-repo-helm.finalizer | bool | `true` |  |
| argoApps.myHelmApps-from-repo-helm.spec.ignoreDifferences[0].group | string | `"apps"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.ignoreDifferences[0].jsonPointers[0] | string | `"/spec/template/metadata/annotations/checksum~1config"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.ignoreDifferences[0].kind | string | `"Deployment"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.ignoreDifferences[1].group | string | `"batch"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.ignoreDifferences[1].jsonPointers[0] | string | `"/spec/schedule"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.ignoreDifferences[1].kind | string | `"CronJob"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.ignoreDifferences[1].name | string | `"linkerd-heartbeat"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.project | string | `"OverridedProject"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.source.chart | string | `"myChart"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.source.helm.releaseName | string | `"myHelmApps-release"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.source.helm.skipCrds | bool | `true` |  |
| argoApps.myHelmApps-from-repo-helm.spec.source.helm.valueFiles[0] | string | `"values-dev.yaml"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.source.helm.values | string | `"key: value\nkey.subkey: value\nfoo:\n  bar: toto\n"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.source.repoURL | string | `"https://example.com/helm-chart"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.source.targetRevision | string | `"1.2.3"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.syncPolicy.automated.allowEmpty | bool | `false` |  |
| argoApps.myHelmApps-from-repo-helm.spec.syncPolicy.automated.prune | bool | `false` |  |
| argoApps.myHelmApps-from-repo-helm.spec.syncPolicy.automated.selfHeal | bool | `false` |  |
| argoApps.myHelmApps-from-repo-helm.spec.syncPolicy.automatedDefaultConfig | bool | `true` |  |
| argoApps.myHelmApps-from-repo-helm.spec.syncPolicy.managedNamespaceMetadata.labels | string | `"key: value \n"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.syncPolicy.retry.backoff.duration | string | `"5s"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.syncPolicy.retry.backoff.factor | int | `2` |  |
| argoApps.myHelmApps-from-repo-helm.spec.syncPolicy.retry.backoff.maxDuration | string | `"3m"` |  |
| argoApps.myHelmApps-from-repo-helm.spec.syncPolicy.retry.limit | int | `5` |  |
| argoApps.myHelmApps-from-repo-helm.spec.syncPolicy.syncOptions[0] | string | `"Validate=true"` |  |
| argoProjects.myArgocdProject.enabled | bool | `true` |  |
| argoProjects.myArgocdProject.finalizer | bool | `true` |  |
| argoProjects.myArgocdProject.projectsNameOverride | string | `"argocd-project"` |  |
| argoProjects.myArgocdProject.spec.clusterResourceWhitelist[0].group | string | `""` |  |
| argoProjects.myArgocdProject.spec.clusterResourceWhitelist[0].kind | string | `"Namespace"` |  |
| argoProjects.myArgocdProject.spec.description | string | `"my project description\""` |  |
| argoProjects.myArgocdProject.spec.namespacesList | list | `["chronos-*","subscription-manager-*"]` | namespacesList is a list of namespaces from the current cluster that the project can access. Warning: this will override the destinations key |
| argoProjects.myArgocdProject.spec.sourceRepos[0] | string | `"https://github.com/ManakinCubber/chronos-api"` |  |
| default.spec.destination.namespace | string | `"DefaultNamespace"` |  |
| default.spec.project | string | `"DefaultProject"` |  |
| default.spec.syncPolicy.automated.allowEmpty | bool | `true` |  |
| default.spec.syncPolicy.automated.prune | bool | `true` |  |
| default.spec.syncPolicy.automated.selfHeal | bool | `true` |  |
| default.spec.syncPolicy.retry.backoff.duration | string | `"5s"` |  |
| default.spec.syncPolicy.retry.backoff.factor | int | `2` |  |
| default.spec.syncPolicy.retry.backoff.maxDuration | string | `"3m"` |  |
| default.spec.syncPolicy.retry.limit | int | `5` |  |
| default.spec.syncPolicy.syncOptions[0] | string | `"Validate=false"` |  |
| default.spec.syncPolicy.syncOptions[1] | string | `"CreateNamespace=true"` |  |
| default.spec.syncPolicy.syncOptions[2] | string | `"PrunePropagationPolicy=foreground"` |  |
| default.spec.syncPolicy.syncOptions[3] | string | `"PruneLast=true"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
