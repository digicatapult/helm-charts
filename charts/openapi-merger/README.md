# openapi-merger

The openapi-merger is designed to merge several openapi files into one and present a unified swagger interface

## TL;DR

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/openapi-merger
```

## Introduction

This chart bootstraps a [openapi-merger](https://github.com/digicatapult/openapi-merger/) deployment on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/openapi-merger
```

The command deploys openapi-merger on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-releases
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.name                                          | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |

### openapi-merger config parameters

| Name                                              | Description                                                                                                                                               | Value                                                                                                                                                                                                                 |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `logLevel`                                        | Allowed values: error, warn, info, debug                                                                                                                  | `info`                                                                                                                                                                                                                |
| `paths`                                           | An array of URLs to the OpenAPI specs to merge                                                                                                            | `["http://wasp-reading-service/v1/api-docs","http://wasp-event-service/v1/api-docs","http://wasp-thing-service/v1/api-docs","http://wasp-authentication-service/v1/api-docs","http://wasp-user-service/v1/api-docs"]` |
| `output`                                          | The path to the output file                                                                                                                               | `output/output.swagger.json`                                                                                                                                                                                          |
| `baseUrl`                                         | The base URL of the API                                                                                                                                   | `["http://localhost:3000/api"]`                                                                                                                                                                                       |
| `apiDocsFilePath`                                 | The path to the API docs file                                                                                                                             | `/data/api-docs.json`                                                                                                                                                                                                 |
| `apiPublicUrlPrefix`                              | The public url prefix to prepend for accessing docs                                                                                                       | `""`                                                                                                                                                                                                                  |
| `prepend`                                         | what to prepend to the pathModification in the merged OpenAPI spec                                                                                        | `""`                                                                                                                                                                                                                  |
| `openApiTitle`                                    | The title of the merged OpenAPI spec                                                                                                                      | `Merged OpenAPI spec`                                                                                                                                                                                                 |
| `apiDocsMock.enabled`                             | Enable API docs mock                                                                                                                                      | `false`                                                                                                                                                                                                               |
| `securitySchema.name`                             | Name of the security schema as referenced in the merged OpenAPI spec                                                                                      | `oauth2`                                                                                                                                                                                                              |
| `securitySchema.type`                             | Options are ["bearer", "oauth2", ""] to enable security configuration in the merged OpenAPI spec                                                          | `oauth2`                                                                                                                                                                                                              |
| `securitySchema.enabled`                          | Enable security configuration in the merged OpenAPI spec                                                                                                  | `false`                                                                                                                                                                                                               |
| `securitySchema.oauth2`                           | Oauth2 configuration. Required if type is "oauth2"                                                                                                        |                                                                                                                                                                                                                       |
| `securitySchema.oauth2.flows`                     | Supported OAuth2 flows. Allowed values are ["authorizationCode", "clientCredentials", "implicit", "password"]                                             | `["authorizationCode","clientCredentials"]`                                                                                                                                                                           |
| `securitySchema.oauth2.authorizationUrl`          | The URL for the oauth2 authorization. Required if type is oauth2 and either "authorizationCode" or "implicit" is included in flows                        | `/auth/realms/simple/protocol/openid-connect/auth`                                                                                                                                                                    |
| `securitySchema.oauth2.tokenUrl`                  | The URL for the oauth2 token. Required if type is oauth2 and any of "authorizationCode", "password" or "clientCredentials" are included in flows          | `/auth/realms/simple/protocol/openid-connect/token`                                                                                                                                                                   |
| `securitySchema.oauth2.refreshUrl`                | The refresh URL for the oauth2 token                                                                                                                      | `/auth/realms/simple/protocol/openid-connect/token`                                                                                                                                                                   |
| `securitySchema.oauth2.scopes`                    | Scopes for the oauth2 token                                                                                                                               |                                                                                                                                                                                                                       |
| `securitySchema.bearer`                           | Bearer format configuration. Required if type is "bearer"                                                                                                 |                                                                                                                                                                                                                       |
| `securitySchema.bearer.format`                    | Bearer token format                                                                                                                                       | `JWT`                                                                                                                                                                                                                 |
| `extraSecuritySchemas`                            | Additional security schemas to be referenced in the merged OpenAPI spec                                                                                   | `[]`                                                                                                                                                                                                                  |
| `image.registry`                                  | openapi-merger image registry                                                                                                                             | `docker.io`                                                                                                                                                                                                           |
| `image.repository`                                | openapi-merger image repository                                                                                                                           | `digicatapult/openapi-merger`                                                                                                                                                                                         |
| `image.tag`                                       | openapi-merger image tag (immutable tags are recommended)                                                                                                 | `v1.0.72`                                                                                                                                                                                                             |
| `image.digest`                                    | openapi-merger image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                                                                                                                                                                                                                  |
| `image.pullPolicy`                                | openapi-merger image pull policy                                                                                                                          | `IfNotPresent`                                                                                                                                                                                                        |
| `image.pullSecrets`                               | openapi-merger image pull secrets                                                                                                                         | `[]`                                                                                                                                                                                                                  |
| `image.debug`                                     | Enable openapi-merger image debug mode                                                                                                                    | `false`                                                                                                                                                                                                               |
| `replicaCount`                                    | Number of openapi-merger replicas to deploy                                                                                                               | `1`                                                                                                                                                                                                                   |
| `containerPorts.http`                             | openapi-merger HTTP container port                                                                                                                        | `3000`                                                                                                                                                                                                                |
| `livenessProbe.enabled`                           | Enable livenessProbe on openapi-merger containers                                                                                                         | `true`                                                                                                                                                                                                                |
| `livenessProbe.path`                              | Path for to check for livenessProbe                                                                                                                       | `/health`                                                                                                                                                                                                             |
| `livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                                                                   | `10`                                                                                                                                                                                                                  |
| `livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                                                          | `10`                                                                                                                                                                                                                  |
| `livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                                                         | `5`                                                                                                                                                                                                                   |
| `livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                                                       | `3`                                                                                                                                                                                                                   |
| `livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                                                       | `1`                                                                                                                                                                                                                   |
| `readinessProbe.enabled`                          | Enable readinessProbe on openapi-merger containers                                                                                                        | `true`                                                                                                                                                                                                                |
| `readinessProbe.path`                             | Path for to check for readinessProbe                                                                                                                      | `/health`                                                                                                                                                                                                             |
| `readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                                                                  | `5`                                                                                                                                                                                                                   |
| `readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                                                         | `10`                                                                                                                                                                                                                  |
| `readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                                                        | `5`                                                                                                                                                                                                                   |
| `readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                                                      | `5`                                                                                                                                                                                                                   |
| `readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                                                      | `1`                                                                                                                                                                                                                   |
| `startupProbe.enabled`                            | Enable startupProbe on openapi-merger containers                                                                                                          | `false`                                                                                                                                                                                                               |
| `startupProbe.path`                               | Path for to check for startupProbe                                                                                                                        | `/health`                                                                                                                                                                                                             |
| `startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                                                                    | `30`                                                                                                                                                                                                                  |
| `startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                                                                           | `10`                                                                                                                                                                                                                  |
| `startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                                                                          | `5`                                                                                                                                                                                                                   |
| `startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                                                                        | `10`                                                                                                                                                                                                                  |
| `startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                                                                        | `1`                                                                                                                                                                                                                   |
| `customLivenessProbe`                             | Custom livenessProbe that overrides the default one                                                                                                       | `{}`                                                                                                                                                                                                                  |
| `customReadinessProbe`                            | Custom readinessProbe that overrides the default one                                                                                                      | `{}`                                                                                                                                                                                                                  |
| `customStartupProbe`                              | Custom startupProbe that overrides the default one                                                                                                        | `{}`                                                                                                                                                                                                                  |
| `resources.limits`                                | The resources limits for the openapi-merger containers                                                                                                    | `{}`                                                                                                                                                                                                                  |
| `resources.requests`                              | The requested resources for the openapi-merger containers                                                                                                 | `{}`                                                                                                                                                                                                                  |
| `podSecurityContext.enabled`                      | Enabled openapi-merger pods' Security Context                                                                                                             | `true`                                                                                                                                                                                                                |
| `podSecurityContext.fsGroup`                      | Set openapi-merger pod's Security Context fsGroup                                                                                                         | `1001`                                                                                                                                                                                                                |
| `containerSecurityContext.enabled`                | Enabled openapi-merger containers' Security Context                                                                                                       | `true`                                                                                                                                                                                                                |
| `containerSecurityContext.runAsUser`              | Set openapi-merger containers' Security Context runAsUser                                                                                                 | `1001`                                                                                                                                                                                                                |
| `containerSecurityContext.runAsNonRoot`           | Set openapi-merger containers' Security Context runAsNonRoot                                                                                              | `true`                                                                                                                                                                                                                |
| `containerSecurityContext.readOnlyRootFilesystem` | Set openapi-merger containers' Security Context runAsNonRoot                                                                                              | `false`                                                                                                                                                                                                               |
| `command`                                         | Override default container command (useful when using custom images)                                                                                      | `[]`                                                                                                                                                                                                                  |
| `args`                                            | Override default container args (useful when using custom images)                                                                                         | `[]`                                                                                                                                                                                                                  |
| `hostAliases`                                     | openapi-merger pods host aliases                                                                                                                          | `[]`                                                                                                                                                                                                                  |
| `podLabels`                                       | Extra labels for openapi-merger pods                                                                                                                      | `{}`                                                                                                                                                                                                                  |
| `podAnnotations`                                  | Annotations for openapi-merger pods                                                                                                                       | `{}`                                                                                                                                                                                                                  |
| `podAffinityPreset`                               | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                       | `""`                                                                                                                                                                                                                  |
| `podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                  | `soft`                                                                                                                                                                                                                |
| `pdb.create`                                      | Enable/disable a Pod Disruption Budget creation                                                                                                           | `false`                                                                                                                                                                                                               |
| `pdb.minAvailable`                                | Minimum number/percentage of pods that should remain scheduled                                                                                            | `1`                                                                                                                                                                                                                   |
| `pdb.maxUnavailable`                              | Maximum number/percentage of pods that may be made unavailable                                                                                            | `""`                                                                                                                                                                                                                  |
| `autoscaling.enabled`                             | Enable autoscaling for openapi-merger                                                                                                                     | `false`                                                                                                                                                                                                               |
| `autoscaling.minReplicas`                         | Minimum number of openapi-merger replicas                                                                                                                 | `""`                                                                                                                                                                                                                  |
| `autoscaling.maxReplicas`                         | Maximum number of openapi-merger replicas                                                                                                                 | `""`                                                                                                                                                                                                                  |
| `autoscaling.targetCPU`                           | Target CPU utilization percentage                                                                                                                         | `""`                                                                                                                                                                                                                  |
| `autoscaling.targetMemory`                        | Target Memory utilization percentage                                                                                                                      | `""`                                                                                                                                                                                                                  |
| `nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                 | `""`                                                                                                                                                                                                                  |
| `nodeAffinityPreset.key`                          | Node label key to match. Ignored if `affinity` is set                                                                                                     | `""`                                                                                                                                                                                                                  |
| `nodeAffinityPreset.values`                       | Node label values to match. Ignored if `affinity` is set                                                                                                  | `[]`                                                                                                                                                                                                                  |
| `affinity`                                        | Affinity for openapi-merger pods assignment                                                                                                               | `{}`                                                                                                                                                                                                                  |
| `nodeSelector`                                    | Node labels for openapi-merger pods assignment                                                                                                            | `{}`                                                                                                                                                                                                                  |
| `tolerations`                                     | Tolerations for openapi-merger pods assignment                                                                                                            | `[]`                                                                                                                                                                                                                  |
| `updateStrategy.type`                             | openapi-merger statefulset strategy type                                                                                                                  | `RollingUpdate`                                                                                                                                                                                                       |
| `priorityClassName`                               | openapi-merger pods' priorityClassName                                                                                                                    | `""`                                                                                                                                                                                                                  |
| `topologySpreadConstraints`                       | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                  | `[]`                                                                                                                                                                                                                  |
| `schedulerName`                                   | Name of the k8s scheduler (other than default) for openapi-merger pods                                                                                    | `""`                                                                                                                                                                                                                  |
| `terminationGracePeriodSeconds`                   | Seconds Redmine pod needs to terminate gracefully                                                                                                         | `""`                                                                                                                                                                                                                  |
| `lifecycleHooks`                                  | for the openapi-merger container(s) to automate configuration before or after startup                                                                     | `{}`                                                                                                                                                                                                                  |
| `extraEnvVars`                                    | Array with extra environment variables to add to openapi-merger nodes                                                                                     | `[]`                                                                                                                                                                                                                  |
| `extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for openapi-merger nodes                                                                             | `""`                                                                                                                                                                                                                  |
| `extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for openapi-merger nodes                                                                                | `""`                                                                                                                                                                                                                  |
| `extraVolumes`                                    | Optionally specify extra list of additional volumes for the openapi-merger pod(s)                                                                         | `[]`                                                                                                                                                                                                                  |
| `extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the openapi-merger container(s)                                                              | `[]`                                                                                                                                                                                                                  |
| `sidecars`                                        | Add additional sidecar containers to the openapi-merger pod(s)                                                                                            | `[]`                                                                                                                                                                                                                  |
| `initContainers`                                  | Add additional init containers to the openapi-merger pod(s)                                                                                               | `[]`                                                                                                                                                                                                                  |

### Persistence Parameters

| Name                        | Description                                                                                             | Value               |
| --------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------- |
| `persistence.enabled`       | Enable persistence using Persistent Volume Claims                                                       | `true`              |
| `persistence.mountPath`     | Path to mount the volume at.                                                                            | `/data`             |
| `persistence.subPath`       | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services | `""`                |
| `persistence.storageClass`  | Storage class of backing PVC                                                                            | `""`                |
| `persistence.annotations`   | Persistent Volume Claim annotations                                                                     | `{}`                |
| `persistence.accessModes`   | Persistent Volume Access Modes                                                                          | `["ReadWriteOnce"]` |
| `persistence.size`          | Size of data volume                                                                                     | `1Gi`               |
| `persistence.existingClaim` | The name of an existing PVC to use for persistence                                                      | `""`                |
| `persistence.selector`      | Selector to match an existing Persistent Volume for WordPress data PVC                                  | `{}`                |
| `persistence.dataSource`    | Custom PVC data source                                                                                  | `{}`                |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                  |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `service.type`                     | openapi-merger service type                                                                                                      | `ClusterIP`            |
| `service.ports.http`               | openapi-merger service HTTP port                                                                                                 | `3000`                 |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                   |
| `service.clusterIP`                | openapi-merger service Cluster IP                                                                                                | `""`                   |
| `service.loadBalancerIP`           | openapi-merger service Load Balancer IP                                                                                          | `""`                   |
| `service.loadBalancerSourceRanges` | openapi-merger service Load Balancer sources                                                                                     | `[]`                   |
| `service.externalTrafficPolicy`    | openapi-merger service external traffic policy                                                                                   | `Cluster`              |
| `service.annotations`              | Additional custom annotations for openapi-merger service                                                                         | `{}`                   |
| `service.extraPorts`               | Extra ports to expose in openapi-merger service (normally used with the `sidecars` value)                                        | `[]`                   |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                 |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                   |
| `ingress.enabled`                  | Enable ingress record generation for openapi-merger                                                                              | `true`                 |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                   |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `openapi-merger.local` |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                   |
| `ingress.paths`                    | Default paths for the ingress record                                                                                             | `[]`                   |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                   |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                   |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                   |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                   |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                   |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                   |

### cronJob parameters

| Name                            | Description                                                                                                                                                                 | Value             |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| `cronjob.schedule`              | Schedule in Cron format to save snapshots                                                                                                                                   | `*/1 * * * *`     |
| `cronjob.historyLimit`          | Number of successful finished jobs to retain                                                                                                                                | `3`               |
| `cronjob.podAnnotations`        | Pod annotations for cronjob pods                                                                                                                                            | `{}`              |
| `cronjob.resources.limits`      | Cronjob container resource limits                                                                                                                                           | `{}`              |
| `cronjob.resources.requests`    | Cronjob container resource requests                                                                                                                                         | `{}`              |
| `cronjob.initImage.registry`    | openapi-merger cronjob init container image registry                                                                                                                        | `docker.io`       |
| `cronjob.initImage.repository`  | openapi-merger cronjob container image repository                                                                                                                           | `node`            |
| `cronjob.initImage.tag`         | openapi-merger cronjob container image tag (immutable tags are recommended)                                                                                                 | `hydrogen-alpine` |
| `cronjob.initImage.digest`      | openapi-merger cronjob container image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`              |
| `cronjob.initImage.pullPolicy`  | openapi-merger ceonjob container image pull policy                                                                                                                          | `IfNotPresent`    |
| `cronjob.initImage.pullSecrets` | openapi-merger cronjob container image pull secrets                                                                                                                         | `[]`              |
| `cronjob.initImage.debug`       | Enable openapi-merger cronjob container image debug mode                                                                                                                    | `false`           |
| `cronjob.image.registry`        | openapi-merger cronjob image registry                                                                                                                                       | `docker.io`       |
| `cronjob.image.repository`      | openapi-merger cronjob image repository                                                                                                                                     | `curlimages/curl` |
| `cronjob.image.tag`             | openapi-merger cronjob image tag (immutable tags are recommended)                                                                                                           | `7.87.0`          |
| `cronjob.image.digest`          | openapi-merger cronjob image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)           | `""`              |
| `cronjob.image.pullPolicy`      | openapi-merger ceonjob image pull policy                                                                                                                                    | `IfNotPresent`    |
| `cronjob.image.pullSecrets`     | openapi-merger cronjob image pull secrets                                                                                                                                   | `[]`              |
| `cronjob.image.debug`           | Enable openapi-merger cronjob image debug mode                                                                                                                              | `false`           |
| `cronjob.nodeSelector`          | Node labels for cronjob pods assignment                                                                                                                                     | `{}`              |
| `cronjob.tolerations`           | Tolerations for cronjob pods assignment                                                                                                                                     | `[]`              |

### Other Parameters

| Name                                          | Description                                                      | Value  |
| --------------------------------------------- | ---------------------------------------------------------------- | ------ |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created             | `true` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                           | `""`   |
| `serviceAccount.annotations`                  | Additional Service Account annotations (evaluated as a template) | `{}`   |
| `serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account   | `true` |

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Digital Catapult will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/openapi-merger/configuration/configure-use-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/openapi-merger/administration/enable-tls/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as openapi-merger (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/openapi-merger/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## License

This chart is licensed under the Apache v2.0 license.

Copyright &copy; 2023 Digital Catapult

### Attribution

This chart is adapted from The [charts](<(https://github.com/bitnami/charts)>) provided by [Bitnami](https://bitnami.com/) which are licensed under the Apache v2.0 License which is reproduced here:

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```