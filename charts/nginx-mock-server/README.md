# nginx-mock-server

The nginx-mock-server is a very simple helm chart that brings up an nginx instance and mocks out specific responses at specific locations on specific ports, with specific headers. It is intended to be used for testing purposes only, I.E testing out helm charts whereby the chart being tested requires a specific response from a specific 3rd party endpoint.

Heavily based on the [bitnami/nginx](https://github.com/bitnami/charts/tree/master/bitnami/nginx) chart.

## TL;DR

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/nginx-mock-server
```

## Introduction

This chart bootstraps a nginx-mock-server deployment on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/nginx-mock-server
```

The command deploys nginx-mock-server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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

### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`           | String to partially override nginx.fullname template (will maintain the release name)   | `""`            |
| `fullnameOverride`       | String to fully override nginx.fullname template                                        | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                               | `cluster.local` |
| `extraDeploy`            | Extra objects to deploy (value evaluated as a template)                                 | `[]`            |
| `commonLabels`           | Add labels to all the deployed resources                                                | `{}`            |
| `commonAnnotations`      | Add annotations to all the deployed resources                                           | `{}`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the deployment(s)/statefulset(s)              | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the deployment(s)/statefulset(s)                 | `["infinity"]`  |

### Custom NGINX application parameters

| Name                           | Description                                                                                                                                                           | Value |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `customResponses`              | Custom NGINX responses for a location.  Any port number specified here will also be added to the service created.  See [values.yaml](values.yaml#L62) for an example. | `[]`  |
| `serverBlock`                  | Custom server block to be added to NGINX configuration                                                                                                                | `""`  |
| `existingServerBlockConfigmap` | ConfigMap with custom server block to be added to NGINX configuration                                                                                                 | `""`  |

### NGINX parameters

| Name                 | Description                                                                                           | Value                 |
| -------------------- | ----------------------------------------------------------------------------------------------------- | --------------------- |
| `image.registry`     | NGINX image registry                                                                                  | `docker.io`           |
| `image.repository`   | NGINX image repository                                                                                | `bitnami/nginx`       |
| `image.tag`          | NGINX image tag (immutable tags are recommended)                                                      | `1.25.2-debian-11-r3` |
| `image.digest`       | NGINX image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                  |
| `image.pullPolicy`   | NGINX image pull policy                                                                               | `IfNotPresent`        |
| `image.pullSecrets`  | Specify docker-registry secret names as an array                                                      | `[]`                  |
| `image.debug`        | Set to true if you would like to see extra information on logs                                        | `false`               |
| `hostAliases`        | Deployment pod host aliases                                                                           | `[]`                  |
| `command`            | Override default container command (useful when using custom images)                                  | `[]`                  |
| `args`               | Override default container args (useful when using custom images)                                     | `[]`                  |
| `extraEnvVars`       | Extra environment variables to be set on NGINX containers                                             | `[]`                  |
| `extraEnvVarsCM`     | ConfigMap with extra environment variables                                                            | `""`                  |
| `extraEnvVarsSecret` | Secret with extra environment variables                                                               | `""`                  |

### NGINX deployment parameters

| Name                                          | Description                                                                               | Value           |
| --------------------------------------------- | ----------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`                                | Number of NGINX replicas to deploy                                                        | `1`             |
| `revisionHistoryLimit`                        | The number of old history to retain to allow rollback                                     | `10`            |
| `updateStrategy.type`                         | NGINX deployment strategy type                                                            | `RollingUpdate` |
| `updateStrategy.rollingUpdate`                | NGINX deployment rolling update configuration parameters                                  | `{}`            |
| `podLabels`                                   | Additional labels for NGINX pods                                                          | `{}`            |
| `podAnnotations`                              | Annotations for NGINX pods                                                                | `{}`            |
| `podAffinityPreset`                           | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `nodeAffinityPreset.key`                      | Node label key to match Ignored if `affinity` is set.                                     | `""`            |
| `nodeAffinityPreset.values`                   | Node label values to match. Ignored if `affinity` is set.                                 | `[]`            |
| `affinity`                                    | Affinity for pod assignment                                                               | `{}`            |
| `hostNetwork`                                 | Specify if host network should be enabled for NGINX pod                                   | `false`         |
| `hostIPC`                                     | Specify if host IPC should be enabled for NGINX pod                                       | `false`         |
| `nodeSelector`                                | Node labels for pod assignment. Evaluated as a template.                                  | `{}`            |
| `tolerations`                                 | Tolerations for pod assignment. Evaluated as a template.                                  | `[]`            |
| `priorityClassName`                           | NGINX pods' priorityClassName                                                             | `""`            |
| `schedulerName`                               | Name of the k8s scheduler (other than default)                                            | `""`            |
| `terminationGracePeriodSeconds`               | In seconds, time the given to the NGINX pod needs to terminate gracefully                 | `""`            |
| `topologySpreadConstraints`                   | Topology Spread Constraints for pod assignment                                            | `[]`            |
| `podSecurityContext.enabled`                  | Enabled NGINX pods' Security Context                                                      | `false`         |
| `podSecurityContext.fsGroup`                  | Set NGINX pod's Security Context fsGroup                                                  | `1001`          |
| `podSecurityContext.sysctls`                  | sysctl settings of the NGINX pods                                                         | `[]`            |
| `containerSecurityContext.enabled`            | Enabled NGINX containers' Security Context                                                | `false`         |
| `containerSecurityContext.runAsUser`          | Set NGINX container's Security Context runAsUser                                          | `1001`          |
| `containerSecurityContext.runAsNonRoot`       | Set NGINX container's Security Context runAsNonRoot                                       | `true`          |
| `containerPorts.http`                         | Sets http port inside NGINX container                                                     | `8080`          |
| `containerPorts.https`                        | Sets https port inside NGINX container                                                    | `""`            |
| `extraContainerPorts`                         | Array of additional container ports for the Nginx container                               | `[]`            |
| `resources.limits`                            | The resources limits for the NGINX container                                              | `{}`            |
| `resources.requests`                          | The requested resources for the NGINX container                                           | `{}`            |
| `lifecycleHooks`                              | Optional lifecycleHooks for the NGINX container                                           | `{}`            |
| `startupProbe.enabled`                        | Enable startupProbe                                                                       | `false`         |
| `startupProbe.initialDelaySeconds`            | Initial delay seconds for startupProbe                                                    | `30`            |
| `startupProbe.periodSeconds`                  | Period seconds for startupProbe                                                           | `10`            |
| `startupProbe.timeoutSeconds`                 | Timeout seconds for startupProbe                                                          | `5`             |
| `startupProbe.failureThreshold`               | Failure threshold for startupProbe                                                        | `6`             |
| `startupProbe.successThreshold`               | Success threshold for startupProbe                                                        | `1`             |
| `livenessProbe.enabled`                       | Enable livenessProbe                                                                      | `true`          |
| `livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                   | `30`            |
| `livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                          | `10`            |
| `livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                         | `5`             |
| `livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                       | `6`             |
| `livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                       | `1`             |
| `readinessProbe.enabled`                      | Enable readinessProbe                                                                     | `true`          |
| `readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                  | `5`             |
| `readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                         | `5`             |
| `readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                        | `3`             |
| `readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                      | `3`             |
| `readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                      | `1`             |
| `customStartupProbe`                          | Custom liveness probe for the Web component                                               | `{}`            |
| `customLivenessProbe`                         | Override default liveness probe                                                           | `{}`            |
| `customReadinessProbe`                        | Override default readiness probe                                                          | `{}`            |
| `autoscaling.enabled`                         | Enable autoscaling for NGINX deployment                                                   | `false`         |
| `autoscaling.minReplicas`                     | Minimum number of replicas to scale back                                                  | `""`            |
| `autoscaling.maxReplicas`                     | Maximum number of replicas to scale out                                                   | `""`            |
| `autoscaling.targetCPU`                       | Target CPU utilization percentage                                                         | `""`            |
| `autoscaling.targetMemory`                    | Target Memory utilization percentage                                                      | `""`            |
| `extraVolumes`                                | Array to add extra volumes                                                                | `[]`            |
| `extraVolumeMounts`                           | Array to add extra mount                                                                  | `[]`            |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for nginx pod                                           | `false`         |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                                    | `""`            |
| `serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template.                                 | `{}`            |
| `serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod                                           | `false`         |
| `sidecars`                                    | Sidecar parameters                                                                        | `[]`            |
| `sidecarSingleProcessNamespace`               | Enable sharing the process namespace with sidecars                                        | `false`         |
| `initContainers`                              | Extra init containers                                                                     | `[]`            |
| `pdb.create`                                  | Created a PodDisruptionBudget                                                             | `false`         |
| `pdb.minAvailable`                            | Min number of pods that must still be available after the eviction.                       | `1`             |
| `pdb.maxUnavailable`                          | Max number of pods that can be unavailable after the eviction.                            | `0`             |

### Traffic Exposure parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Service type                                                                                                                     | `LoadBalancer`           |
| `service.ports.http`               | Service HTTP port                                                                                                                | `80`                     |
| `service.ports.https`              | Service HTTPS port                                                                                                               | `443`                    |
| `service.nodePorts`                | Specify the nodePort(s) value(s) for the LoadBalancer and NodePort service types.                                                | `{}`                     |
| `service.targetPort`               | Target port reference value for the Loadbalancer service types can be specified explicitly.                                      | `{}`                     |
| `service.clusterIP`                | NGINX service Cluster IP                                                                                                         | `""`                     |
| `service.loadBalancerIP`           | LoadBalancer service IP address                                                                                                  | `""`                     |
| `service.loadBalancerSourceRanges` | NGINX service Load Balancer sources                                                                                              | `[]`                     |
| `service.extraPorts`               | Extra ports to expose (normally used with the `sidecar` value)                                                                   | `[]`                     |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.annotations`              | Service annotations                                                                                                              | `{}`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `ingress.enabled`                  | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress resource                                                                                            | `nginx.local`            |
| `ingress.path`                     | The Path to Nginx. You may need to set this to '/*' in order to use this with ALB ingress controllers.                           | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.ingressClassName`         | Set the ingerssClassName on the ingress record for k8s 1.18+                                                                     | `""`                     |
| `ingress.tls`                      | Create TLS Secret                                                                                                                | `false`                  |
| `ingress.extraHosts`               | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`               | The list of additional rules to be added to this ingress record. Evaluated as a template                                         | `[]`                     |
| `healthIngress.enabled`            | Set to true to enable health ingress record generation                                                                           | `false`                  |
| `healthIngress.selfSigned`         | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `healthIngress.pathType`           | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `healthIngress.hostname`           | When the health ingress is enabled, a host pointing to this will be created                                                      | `example.local`          |
| `healthIngress.path`               | Default path for the ingress record                                                                                              | `/`                      |
| `healthIngress.annotations`        | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `healthIngress.tls`                | Enable TLS configuration for the hostname defined at `healthIngress.hostname` parameter                                          | `false`                  |
| `healthIngress.extraHosts`         | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `healthIngress.extraPaths`         | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `healthIngress.extraTls`           | TLS configuration for additional hostnames to be covered                                                                         | `[]`                     |
| `healthIngress.secrets`            | TLS Secret configuration                                                                                                         | `[]`                     |
| `healthIngress.ingressClassName`   | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `healthIngress.extraRules`         | The list of additional rules to be added to this ingress record. Evaluated as a template                                         | `[]`                     |

### Metrics parameters

| Name                                       | Description                                                                                                                               | Value                    |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `metrics.enabled`                          | Start a Prometheus exporter sidecar container                                                                                             | `false`                  |
| `metrics.port`                             | NGINX Container Status Port scraped by Prometheus Exporter                                                                                | `""`                     |
| `metrics.image.registry`                   | NGINX Prometheus exporter image registry                                                                                                  | `docker.io`              |
| `metrics.image.repository`                 | NGINX Prometheus exporter image repository                                                                                                | `bitnami/nginx-exporter` |
| `metrics.image.tag`                        | NGINX Prometheus exporter image tag (immutable tags are recommended)                                                                      | `0.11.0-debian-11-r324`  |
| `metrics.image.digest`                     | NGINX Prometheus exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                 | `""`                     |
| `metrics.image.pullPolicy`                 | NGINX Prometheus exporter image pull policy                                                                                               | `IfNotPresent`           |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                                                          | `[]`                     |
| `metrics.podAnnotations`                   | Additional annotations for NGINX Prometheus exporter pod(s)                                                                               | `{}`                     |
| `metrics.securityContext.enabled`          | Enabled NGINX Exporter containers' Security Context                                                                                       | `false`                  |
| `metrics.securityContext.runAsUser`        | Set NGINX Exporter container's Security Context runAsUser                                                                                 | `1001`                   |
| `metrics.service.port`                     | NGINX Prometheus exporter service port                                                                                                    | `9113`                   |
| `metrics.service.annotations`              | Annotations for the Prometheus exporter service                                                                                           | `{}`                     |
| `metrics.resources.limits`                 | The resources limits for the NGINX Prometheus exporter container                                                                          | `{}`                     |
| `metrics.resources.requests`               | The requested resources for the NGINX Prometheus exporter container                                                                       | `{}`                     |
| `metrics.serviceMonitor.enabled`           | Creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                               | `false`                  |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                                                                  | `""`                     |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.                                                         | `""`                     |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                                                              | `""`                     |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                                                   | `""`                     |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                                                       | `{}`                     |
| `metrics.serviceMonitor.labels`            | Additional labels that can be used so PodMonitor will be discovered by Prometheus                                                         | `{}`                     |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                                                        | `[]`                     |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                                                                 | `[]`                     |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels                                                                  | `false`                  |
| `metrics.prometheusRule.enabled`           | if `true`, creates a Prometheus Operator PrometheusRule (also requires `metrics.enabled` to be `true` and `metrics.prometheusRule.rules`) | `false`                  |
| `metrics.prometheusRule.namespace`         | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                                                             | `""`                     |
| `metrics.prometheusRule.additionalLabels`  | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                                     | `{}`                     |
| `metrics.prometheusRule.rules`             | Prometheus Rule definitions                                                                                                               | `[]`                     |


## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Digital Catapult will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Using an external Kafka

Sometimes you may want to have Schema Registry connect to an external Kafka cluster rather than installing one as dependency. To do this, the chart allows you to specify credentials for an existing Kafka cluster under the [`externalKafka` parameter](#kafka-chart-parameters). You should also disable the Kafka installation with the `kafka.enabled` option.

For example, use the parameters below to connect Schema Registry with an existing Kafka installation using SASL authentication:

```console
kafka.enabled=false
externalKafka.brokers=SASL_PLAINTEXT://kafka-0.kafka-headless.default.svc.cluster.local:9092
externalKafka.auth.protocol=sasl
externalKafka.auth.jaas.user=myuser
externalKafka.auth.jaas.password=mypassword
```

### Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/main/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host. [Learn more about configuring and using Ingress](https://docs.bitnami.com/kubernetes/apps/wasp-event-service/configuration/configure-use-ingress/).

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/wasp-event-service/administration/enable-tls/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as wasp-event-service (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/wasp-event-service/administration/configure-use-sidecars/).

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
