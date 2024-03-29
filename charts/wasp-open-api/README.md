# DEPRECATED USE openapi-merger instead
This chart will no longer be maintained and the majority of functionality has been moved to `openapi-merger` chart as it is more generic than just something used in the WASP ecosystem.
# wasp-open-api

The wasp-open-api is a component of the WASP (Wide-Area-Sensor-Platform), an IoT platform designed to normalise and consolidate data from multiple IoT data services into one place. The wasp-open-api service creates a merged OpenAPI spec from several microservices and hosts a Swagger interface. See [https://github.com/digicatapult/wasp-documentation](https://github.com/digicatapult/wasp-documentation) for details.

## TL;DR

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/wasp-open-api
```

## Introduction

This chart bootstraps a [wasp-open-api](https://github.com/digicatapult/wasp-open-api/) deployment on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/wasp-open-api
```

The command deploys wasp-open-api on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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


### WASP Event Service config parameters

| Name                                              | Description                                                                                                                                              | Value                                                                                                                                                                                                                 |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `logLevel`                                        | Allowed values: error, warn, info, debug                                                                                                                 | `info`                                                                                                                                                                                                                |
| `paths`                                           | An array of URLs to the OpenAPI specs to merge                                                                                                           | `["http://wasp-reading-service/v1/api-docs","http://wasp-event-service/v1/api-docs","http://wasp-thing-service/v1/api-docs","http://wasp-authentication-service/v1/api-docs","http://wasp-user-service/v1/api-docs"]` |
| `output`                                          | The path to the output file                                                                                                                              | `output/output.swagger.json`                                                                                                                                                                                          |
| `baseUrl`                                         | The base URL of the API                                                                                                                                  | `http://localhost:3000/api`                                                                                                                                                                                           |
| `apiDocsFilePath`                                 | The path to the API docs file                                                                                                                            | `/data/api-docs.json`                                                                                                                                                                                                 |
| `prepend`                                         | what to prepend to the pathModification in the merged OpenAPI spec                                                                                       | `""`                                                                                                                                                                                                                  |
| `apiDocsMock.enabled`                             | Enable API docs mock                                                                                                                                     | `false`                                                                                                                                                                                                               |
| `image.registry`                                  | wasp-open-api image registry                                                                                                                             | `docker.io`                                                                                                                                                                                                           |
| `image.repository`                                | wasp-open-api image repository                                                                                                                           | `digicatapult/wasp-open-api`                                                                                                                                                                                          |
| `image.tag`                                       | wasp-open-api image tag (immutable tags are recommended)                                                                                                 | `v0.1.0`                                                                                                                                                                                                              |
| `image.digest`                                    | wasp-open-api image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`                                                                                                                                                                                                                  |
| `image.pullPolicy`                                | wasp-open-api image pull policy                                                                                                                          | `IfNotPresent`                                                                                                                                                                                                        |
| `image.pullSecrets`                               | wasp-open-api image pull secrets                                                                                                                         | `[]`                                                                                                                                                                                                                  |
| `image.debug`                                     | Enable wasp-open-api image debug mode                                                                                                                    | `false`                                                                                                                                                                                                               |
| `replicaCount`                                    | Number of wasp-open-api replicas to deploy                                                                                                               | `1`                                                                                                                                                                                                                   |
| `containerPorts.http`                             | wasp-open-api HTTP container port                                                                                                                        | `3000`                                                                                                                                                                                                                |
| `livenessProbe.enabled`                           | Enable livenessProbe on wasp-open-api containers                                                                                                         | `true`                                                                                                                                                                                                                |
| `livenessProbe.path`                              | Path for to check for livenessProbe                                                                                                                      | `/health`                                                                                                                                                                                                             |
| `livenessProbe.initialDelaySeconds`               | Initial delay seconds for livenessProbe                                                                                                                  | `10`                                                                                                                                                                                                                  |
| `livenessProbe.periodSeconds`                     | Period seconds for livenessProbe                                                                                                                         | `10`                                                                                                                                                                                                                  |
| `livenessProbe.timeoutSeconds`                    | Timeout seconds for livenessProbe                                                                                                                        | `5`                                                                                                                                                                                                                   |
| `livenessProbe.failureThreshold`                  | Failure threshold for livenessProbe                                                                                                                      | `3`                                                                                                                                                                                                                   |
| `livenessProbe.successThreshold`                  | Success threshold for livenessProbe                                                                                                                      | `1`                                                                                                                                                                                                                   |
| `readinessProbe.enabled`                          | Enable readinessProbe on wasp-open-api containers                                                                                                        | `true`                                                                                                                                                                                                                |
| `readinessProbe.path`                             | Path for to check for readinessProbe                                                                                                                     | `/health`                                                                                                                                                                                                             |
| `readinessProbe.initialDelaySeconds`              | Initial delay seconds for readinessProbe                                                                                                                 | `5`                                                                                                                                                                                                                   |
| `readinessProbe.periodSeconds`                    | Period seconds for readinessProbe                                                                                                                        | `10`                                                                                                                                                                                                                  |
| `readinessProbe.timeoutSeconds`                   | Timeout seconds for readinessProbe                                                                                                                       | `5`                                                                                                                                                                                                                   |
| `readinessProbe.failureThreshold`                 | Failure threshold for readinessProbe                                                                                                                     | `5`                                                                                                                                                                                                                   |
| `readinessProbe.successThreshold`                 | Success threshold for readinessProbe                                                                                                                     | `1`                                                                                                                                                                                                                   |
| `startupProbe.enabled`                            | Enable startupProbe on wasp-open-api containers                                                                                                          | `false`                                                                                                                                                                                                               |
| `startupProbe.path`                               | Path for to check for startupProbe                                                                                                                       | `/health`                                                                                                                                                                                                             |
| `startupProbe.initialDelaySeconds`                | Initial delay seconds for startupProbe                                                                                                                   | `30`                                                                                                                                                                                                                  |
| `startupProbe.periodSeconds`                      | Period seconds for startupProbe                                                                                                                          | `10`                                                                                                                                                                                                                  |
| `startupProbe.timeoutSeconds`                     | Timeout seconds for startupProbe                                                                                                                         | `5`                                                                                                                                                                                                                   |
| `startupProbe.failureThreshold`                   | Failure threshold for startupProbe                                                                                                                       | `10`                                                                                                                                                                                                                  |
| `startupProbe.successThreshold`                   | Success threshold for startupProbe                                                                                                                       | `1`                                                                                                                                                                                                                   |
| `customLivenessProbe`                             | Custom livenessProbe that overrides the default one                                                                                                      | `{}`                                                                                                                                                                                                                  |
| `customReadinessProbe`                            | Custom readinessProbe that overrides the default one                                                                                                     | `{}`                                                                                                                                                                                                                  |
| `customStartupProbe`                              | Custom startupProbe that overrides the default one                                                                                                       | `{}`                                                                                                                                                                                                                  |
| `resources.limits`                                | The resources limits for the wasp-open-api containers                                                                                                    | `{}`                                                                                                                                                                                                                  |
| `resources.requests`                              | The requested resources for the wasp-open-api containers                                                                                                 | `{}`                                                                                                                                                                                                                  |
| `podSecurityContext.enabled`                      | Enabled wasp-open-api pods' Security Context                                                                                                             | `true`                                                                                                                                                                                                                |
| `podSecurityContext.fsGroup`                      | Set wasp-open-api pod's Security Context fsGroup                                                                                                         | `1001`                                                                                                                                                                                                                |
| `containerSecurityContext.enabled`                | Enabled wasp-open-api containers' Security Context                                                                                                       | `true`                                                                                                                                                                                                                |
| `containerSecurityContext.runAsUser`              | Set wasp-open-api containers' Security Context runAsUser                                                                                                 | `1001`                                                                                                                                                                                                                |
| `containerSecurityContext.runAsNonRoot`           | Set wasp-open-api containers' Security Context runAsNonRoot                                                                                              | `true`                                                                                                                                                                                                                |
| `containerSecurityContext.readOnlyRootFilesystem` | Set wasp-open-api containers' Security Context runAsNonRoot                                                                                              | `false`                                                                                                                                                                                                               |
| `command`                                         | Override default container command (useful when using custom images)                                                                                     | `[]`                                                                                                                                                                                                                  |
| `args`                                            | Override default container args (useful when using custom images)                                                                                        | `[]`                                                                                                                                                                                                                  |
| `hostAliases`                                     | wasp-open-api pods host aliases                                                                                                                          | `[]`                                                                                                                                                                                                                  |
| `podLabels`                                       | Extra labels for wasp-open-api pods                                                                                                                      | `{}`                                                                                                                                                                                                                  |
| `podAnnotations`                                  | Annotations for wasp-open-api pods                                                                                                                       | `{}`                                                                                                                                                                                                                  |
| `podAffinityPreset`                               | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                      | `""`                                                                                                                                                                                                                  |
| `podAntiAffinityPreset`                           | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                 | `soft`                                                                                                                                                                                                                |
| `pdb.create`                                      | Enable/disable a Pod Disruption Budget creation                                                                                                          | `false`                                                                                                                                                                                                               |
| `pdb.minAvailable`                                | Minimum number/percentage of pods that should remain scheduled                                                                                           | `1`                                                                                                                                                                                                                   |
| `pdb.maxUnavailable`                              | Maximum number/percentage of pods that may be made unavailable                                                                                           | `""`                                                                                                                                                                                                                  |
| `autoscaling.enabled`                             | Enable autoscaling for wasp-open-api                                                                                                                     | `false`                                                                                                                                                                                                               |
| `autoscaling.minReplicas`                         | Minimum number of wasp-open-api replicas                                                                                                                 | `""`                                                                                                                                                                                                                  |
| `autoscaling.maxReplicas`                         | Maximum number of wasp-open-api replicas                                                                                                                 | `""`                                                                                                                                                                                                                  |
| `autoscaling.targetCPU`                           | Target CPU utilization percentage                                                                                                                        | `""`                                                                                                                                                                                                                  |
| `autoscaling.targetMemory`                        | Target Memory utilization percentage                                                                                                                     | `""`                                                                                                                                                                                                                  |
| `nodeAffinityPreset.type`                         | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                | `""`                                                                                                                                                                                                                  |
| `nodeAffinityPreset.key`                          | Node label key to match. Ignored if `affinity` is set                                                                                                    | `""`                                                                                                                                                                                                                  |
| `nodeAffinityPreset.values`                       | Node label values to match. Ignored if `affinity` is set                                                                                                 | `[]`                                                                                                                                                                                                                  |
| `affinity`                                        | Affinity for wasp-open-api pods assignment                                                                                                               | `{}`                                                                                                                                                                                                                  |
| `nodeSelector`                                    | Node labels for wasp-open-api pods assignment                                                                                                            | `{}`                                                                                                                                                                                                                  |
| `tolerations`                                     | Tolerations for wasp-open-api pods assignment                                                                                                            | `[]`                                                                                                                                                                                                                  |
| `updateStrategy.type`                             | wasp-open-api statefulset strategy type                                                                                                                  | `RollingUpdate`                                                                                                                                                                                                       |
| `priorityClassName`                               | wasp-open-api pods' priorityClassName                                                                                                                    | `""`                                                                                                                                                                                                                  |
| `topologySpreadConstraints`                       | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                 | `[]`                                                                                                                                                                                                                  |
| `schedulerName`                                   | Name of the k8s scheduler (other than default) for wasp-open-api pods                                                                                    | `""`                                                                                                                                                                                                                  |
| `terminationGracePeriodSeconds`                   | Seconds Redmine pod needs to terminate gracefully                                                                                                        | `""`                                                                                                                                                                                                                  |
| `lifecycleHooks`                                  | for the wasp-open-api container(s) to automate configuration before or after startup                                                                     | `{}`                                                                                                                                                                                                                  |
| `extraEnvVars`                                    | Array with extra environment variables to add to wasp-open-api nodes                                                                                     | `[]`                                                                                                                                                                                                                  |
| `extraEnvVarsCM`                                  | Name of existing ConfigMap containing extra env vars for wasp-open-api nodes                                                                             | `""`                                                                                                                                                                                                                  |
| `extraEnvVarsSecret`                              | Name of existing Secret containing extra env vars for wasp-open-api nodes                                                                                | `""`                                                                                                                                                                                                                  |
| `extraVolumes`                                    | Optionally specify extra list of additional volumes for the wasp-open-api pod(s)                                                                         | `[]`                                                                                                                                                                                                                  |
| `extraVolumeMounts`                               | Optionally specify extra list of additional volumeMounts for the wasp-open-api container(s)                                                              | `[]`                                                                                                                                                                                                                  |
| `sidecars`                                        | Add additional sidecar containers to the wasp-open-api pod(s)                                                                                            | `[]`                                                                                                                                                                                                                  |
| `initContainers`                                  | Add additional init containers to the wasp-open-api pod(s)                                                                                               | `[]`                                                                                                                                                                                                                  |


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

| Name                               | Description                                                                                                                      | Value                 |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `service.type`                     | wasp-open-api service type                                                                                                       | `ClusterIP`           |
| `service.ports.http`               | wasp-open-api service HTTP port                                                                                                  | `3000`                |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                  |
| `service.clusterIP`                | wasp-open-api service Cluster IP                                                                                                 | `""`                  |
| `service.loadBalancerIP`           | wasp-open-api service Load Balancer IP                                                                                           | `""`                  |
| `service.loadBalancerSourceRanges` | wasp-open-api service Load Balancer sources                                                                                      | `[]`                  |
| `service.externalTrafficPolicy`    | wasp-open-api service external traffic policy                                                                                    | `Cluster`             |
| `service.annotations`              | Additional custom annotations for wasp-open-api service                                                                          | `{}`                  |
| `service.extraPorts`               | Extra ports to expose in wasp-open-api service (normally used with the `sidecars` value)                                         | `[]`                  |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                  |
| `ingress.enabled`                  | Enable ingress record generation for wasp-open-api                                                                               | `true`                |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                  |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `wasp-open-api.local` |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                  |
| `ingress.paths`                    | Default paths for the ingress record                                                                                             | `[]`                  |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                  |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`               |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`               |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                  |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                  |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                  |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                  |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                  |


### cronJob parameters

| Name                            | Description                                                                                                                                                                | Value             |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| `cronjob.schedule`              | Schedule in Cron format to save snapshots                                                                                                                                  | `*/1 * * * *`     |
| `cronjob.historyLimit`          | Number of successful finished jobs to retain                                                                                                                               | `3`               |
| `cronjob.podAnnotations`        | Pod annotations for cronjob pods                                                                                                                                           | `{}`              |
| `cronjob.resources.limits`      | Cronjob container resource limits                                                                                                                                          | `{}`              |
| `cronjob.resources.requests`    | Cronjob container resource requests                                                                                                                                        | `{}`              |
| `cronjob.initImage.registry`    | wasp-open-api cronjob init container image registry                                                                                                                        | `docker.io`       |
| `cronjob.initImage.repository`  | wasp-open-api cronjob container image repository                                                                                                                           | `node`            |
| `cronjob.initImage.tag`         | wasp-open-api cronjob container image tag (immutable tags are recommended)                                                                                                 | `hydrogen-alpine` |
| `cronjob.initImage.digest`      | wasp-open-api cronjob container image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended) | `""`              |
| `cronjob.initImage.pullPolicy`  | wasp-open-api ceonjob container image pull policy                                                                                                                          | `IfNotPresent`    |
| `cronjob.initImage.pullSecrets` | wasp-open-api cronjob container image pull secrets                                                                                                                         | `[]`              |
| `cronjob.initImage.debug`       | Enable wasp-open-api cronjob container image debug mode                                                                                                                    | `false`           |
| `cronjob.image.registry`        | wasp-open-api cronjob image registry                                                                                                                                       | `docker.io`       |
| `cronjob.image.repository`      | wasp-open-api cronjob image repository                                                                                                                                     | `curlimages/curl` |
| `cronjob.image.tag`             | wasp-open-api cronjob image tag (immutable tags are recommended)                                                                                                           | `7.87.0`          |
| `cronjob.image.digest`          | wasp-open-api cronjob image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag image tag (immutable tags are recommended)           | `""`              |
| `cronjob.image.pullPolicy`      | wasp-open-api ceonjob image pull policy                                                                                                                                    | `IfNotPresent`    |
| `cronjob.image.pullSecrets`     | wasp-open-api cronjob image pull secrets                                                                                                                                   | `[]`              |
| `cronjob.image.debug`           | Enable wasp-open-api cronjob image debug mode                                                                                                                              | `false`           |
| `cronjob.nodeSelector`          | Node labels for cronjob pods assignment                                                                                                                                    | `{}`              |
| `cronjob.tolerations`           | Tolerations for cronjob pods assignment                                                                                                                                    | `[]`              |


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

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/wasp-open-api/configuration/configure-use-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/wasp-open-api/administration/enable-tls/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as wasp-open-api (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/wasp-open-api/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## License

This chart is licensed under the Apache v2.0 license.

Copyright &copy; 2023 Digital Catapult

### Attribution

This chart is adapted from The [charts]((https://github.com/bitnami/charts)) provided by [Bitnami](https://bitnami.com/) which are licensed under the Apache v2.0 License which is reproduced here:

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
