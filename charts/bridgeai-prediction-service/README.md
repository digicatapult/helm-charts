# bridgeai-prediction-service

The bridgeai-prediction-service is a component of the [BridgeAI](https://iuk.ktn-uk.org/programme/bridgeai/) MLOps workflow. This is a FastAPI service that performs house price predictions. It interacts with an MLFlow model and uses the Swagger UI for documentation. See [digicatapult/bridgeai-prediction-service](https://github.com/digicatapult/bridgeai-prediction-service) for details.

## TL;DR

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/bridgeai-prediction-service
```

## Introduction

This chart bootstraps a [bridgeai-prediction-service](https://github.com/digicatapult/bridgeai-prediction-service/) deployment on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add digicatapult https://digicatapult.github.io/helm-charts
$ helm install my-release digicatapult/bridgeai-prediction-service
```

The command deploys bridgeai-prediction-service on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

The application only accepts a single ENVAR, so you should always update `modelPredictionEndpoint` to the URL that contains the model.

## Parameters

### Container Image Parameters

| Name               | Description                          | Value                                      |
| ------------------ | ------------------------------------ | ------------------------------------------ |
| `image.repository` | Prediction service image repository  | `digicatapult/bridgeai-prediction-service` |
| `image.pullPolicy` | Prediction service image pull policy | `IfNotPresent`                             |
| `image.tag`        | Prediction service image tag         | `v0.3.5`                                   |
| `imagePullSecrets` | Specify image pull secrets           | `[]`                                       |

### Chart Parameters

| Name               | Description                      | Value |
| ------------------ | -------------------------------- | ----- |
| `nameOverride`     | Override name for the chart      | `""`  |
| `fullnameOverride` | Override full name for the chart | `""`  |

### Config Parameters

| Name                      | Description                                      | Value                              |
| ------------------------- | ------------------------------------------------ | ---------------------------------- |
| `modelPredictionEndpoint` | Endpoint for the prediction model                | `http://model/prediction/endpoint` |
| `command`                 | Command to override default container entrypoint | `["uvicorn","src.main:app"]`       |
| `args`                    | Args to override default container arguments     | `["--host","0.0.0.0","--reload"]`  |

### Service Account Parameters

| Name                         | Description                                            | Value  |
| ---------------------------- | ------------------------------------------------------ | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created  | `true` |
| `serviceAccount.automount`   | Automatically mount a ServiceAccount's API credentials | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account              | `{}`   |
| `serviceAccount.name`        | The name of the service account to use                 | `""`   |

### Init Container Parameters

| Name                             | Description                                           | Value                                                                     |
| -------------------------------- | ----------------------------------------------------- | ------------------------------------------------------------------------- |
| `initDbCreate.image.registry`    | PostgreSQL image registry                             | `docker.io`                                                               |
| `initDbCreate.image.repository`  | PostgreSQL image repository                           | `postgres`                                                                |
| `initDbCreate.image.tag`         | PostgreSQL image tag (immutable tags are recommended) | `18.6-alpine`                                                             |
| `initDbCreate.image.digest`      | PostgreSQL image digest (sha256)                      | `sha256:10a5c69a83035ab5239f5620d708520e8b28f5aa1f2b20143e6024532edadfb5` |
| `initDbCreate.image.pullPolicy`  | PostgreSQL image pull policy                          | `IfNotPresent`                                                            |
| `initDbCreate.image.pullSecrets` | PostgreSQL image pull secrets                         | `[]`                                                                      |
| `initDbMigrate.enable`           | Run database migration in an init container           | `true`                                                                    |
| `initDbMigrate.environment`      | Database configuration environment to run migration   | `production`                                                              |
| `initDbMigrate.args`             | Arguments to pass to alembic to migrate the database  | `["upgrade","head"]`                                                      |

### Database Parameters

| Name                                                 | Description                                                                          | Value                                                                     |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------- |
| `postgresql.enabled`                                 | Enable or disable PostgreSQL helm chart                                              | `true`                                                                    |
| `postgresql.auth.username`                           | Custom PostgreSQL user                                                               | `admin`                                                                   |
| `postgresql.auth.password`                           | Custom PostgreSQL user password                                                      | `""`                                                                      |
| `postgresql.auth.database`                           | Custom PostgreSQL database                                                           | `prediction`                                                              |
| `postgresql.auth.existingSecret`                     | Existing secret for PostgreSQL credentials                                           | `""`                                                                      |
| `postgresql.architecture`                            | PostgreSQL architecture (`standalone` or `replication`)                              | `standalone`                                                              |
| `postgresql.global.security.allowInsecureImages`     | Allow usage of `bitnamilegacy` repository`                                           | `true`                                                                    |
| `postgresql.image.repository`                        | Repository to use for pulling postgres container images                              | `bitnamilegacy/postgresql`                                                |
| `postgresql.image.tag`                               | PostgreSQL image tag (pinned to the subchart's last published bitnamilegacy default) | `17.5.0-debian-12-r15`                                                    |
| `postgresql.image.digest`                            | PostgreSQL image digest (sha256)                                                     | `sha256:b03f623716969693bf2f5ecf6578df3498024b38da2d8eb0565570fbec537dfc` |
| `postgresql.volumePermissions.image.repository`      | Repository to use for pulling os-shell container images                              | `bitnamilegacy/os-shell`                                                  |
| `postgresql.volumePermissions.image.tag`             | os-shell image tag                                                                   | `12-debian-12-r42`                                                        |
| `postgresql.volumePermissions.image.digest`          | os-shell image digest (sha256)                                                       | `sha256:afa5e8fd849f05a3773b38e43fe1c08423577900a967bd9fe1ab65406406d505` |
| `postgresql.metrics.image.repository`                | Repository to use for pulling postgres exporter container images                     | `bitnamilegacy/postgres-exporter`                                         |
| `postgresql.metrics.image.tag`                       | postgres-exporter image tag                                                          | `0.17.1-debian-12-r5`                                                     |
| `postgresql.metrics.image.digest`                    | postgres-exporter image digest (sha256)                                              | `sha256:44ebaadb1cac59f0d40ae4177fc8340c3d4d02a3b91e4b5d3b571c53b118e5c9` |
| `externalDatabase.host`                              | External database host                                                               | `""`                                                                      |
| `externalDatabase.port`                              | External database port number                                                        | `5432`                                                                    |
| `externalDatabase.user`                              | Username for external database                                                       | `admin`                                                                   |
| `externalDatabase.password`                          | Password for external database                                                       | `""`                                                                      |
| `externalDatabase.database`                          | External database name                                                               | `prediction`                                                              |
| `externalDatabase.create`                            | Enable PostgreSQL user and database creation (external DB)                           | `true`                                                                    |
| `externalDatabase.postgresqlPostgresUser`            | External Database admin user                                                         | `postgres`                                                                |
| `externalDatabase.postgresqlPostgresPassword`        | External Database admin password                                                     | `""`                                                                      |
| `externalDatabase.existingSecret`                    | Existing secret containing database credentials                                      | `""`                                                                      |
| `externalDatabase.existingSecretPasswordKey`         | Secret key for user credentials                                                      | `""`                                                                      |
| `externalDatabase.existingSecretPostgresPasswordKey` | Secret key for admin credentials                                                     | `""`                                                                      |

### Pod Configuration Parameters

| Name                 | Description                         | Value |
| -------------------- | ----------------------------------- | ----- |
| `podAnnotations`     | Extra annotations for the pod       | `{}`  |
| `podLabels`          | Extra labels for the pod            | `{}`  |
| `podSecurityContext` | Pod security context settings       | `{}`  |
| `securityContext`    | Container security context settings | `{}`  |

### Service Parameters

| Name           | Description                                                 | Value       |
| -------------- | ----------------------------------------------------------- | ----------- |
| `service.type` | Kubernetes service type (ClusterIP, NodePort, LoadBalancer) | `ClusterIP` |
| `service.port` | Service port to expose                                      | `8000`      |

### Ingress Parameters

| Name                                 | Description                                                        | Value                    |
| ------------------------------------ | ------------------------------------------------------------------ | ------------------------ |
| `ingress.enabled`                    | Enable or disable ingress controller                               | `false`                  |
| `ingress.className`                  | IngressClass to use for resource implementation                    | `""`                     |
| `ingress.annotations`                | Annotations to add to the Ingress resource                         | `{}`                     |
| `ingress.hosts[0].host`              | Hostname to route requests                                         | `model-prediction.local` |
| `ingress.hosts[0].paths[0].path`     | Path to match against requests                                     | `/predict`               |
| `ingress.hosts[0].paths[0].pathType` | Type of path matching rule (`Prefix` or `Exact`)                   | `Prefix`                 |
| `ingress.hosts[0].paths[1].path`     | Path to match against requests for /data                           | `/data`                  |
| `ingress.hosts[0].paths[1].pathType` | Type of path matching rule (`Prefix` or `Exact`) for /data         | `Prefix`                 |
| `ingress.hosts[0].paths[2].path`     | Path to match against requests for /swagger                        | `/swagger`               |
| `ingress.hosts[0].paths[2].pathType` | Type of path matching rule (`Prefix` or `Exact`) for /swagger      | `Prefix`                 |
| `ingress.hosts[0].paths[3].path`     | Path to match against requests for /openapi.json                   | `/openapi.json`          |
| `ingress.hosts[0].paths[3].pathType` | Type of path matching rule (`Prefix` or `Exact`) for /openapi.json | `Prefix`                 |
| `ingress.tls`                        | TLS configuration for ingress                                      | `[]`                     |

### Resources Parameters

| Name                          | Description                                                       | Value  |
| ----------------------------- | ----------------------------------------------------------------- | ------ |
| `resources`                   | Resource requests and limits                                      | `{}`   |
| `envVars`                     | Additional environment variables for prediction service container | `[]`   |
| `livenessProbe.httpGet.path`  | Path to perform liveness probe on container                       | `/`    |
| `livenessProbe.httpGet.port`  | Port to perform liveness probe on container                       | `http` |
| `readinessProbe.httpGet.path` | Path to perform readiness probe on container                      | `/`    |
| `readinessProbe.httpGet.port` | Port to perform readiness probe on container                      | `http` |

### Autoscaling Parameters

| Name                                         | Description                                              | Value   |
| -------------------------------------------- | -------------------------------------------------------- | ------- |
| `autoscaling.enabled`                        | Enable or disable autoscaling for the prediction service | `false` |
| `autoscaling.minReplicas`                    | Minimum number of replicas                               | `1`     |
| `autoscaling.maxReplicas`                    | Maximum number of replicas                               | `10`    |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization for autoscaling                   | `80`    |

### Volume Parameters

| Name           | Description                                         | Value |
| -------------- | --------------------------------------------------- | ----- |
| `volumes`      | Additional volumes for the prediction service       | `[]`  |
| `volumeMounts` | Additional volume mounts for the prediction service | `[]`  |
| `nodeSelector` | Node labels for pod assignment                      | `{}`  |
| `tolerations`  | Tolerations for pod assignment                      | `[]`  |
| `affinity`     | Affinity rules for pod assignment                   | `{}`  |
