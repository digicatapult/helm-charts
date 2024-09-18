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
