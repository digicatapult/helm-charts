# veritable-node helm chart

Forked from https://paritytech.github.io/helm-charts/
## Installing the chart

```console
helm repo add digicatapult https://digicatapult.github.io/helm-charts/
helm install sqnc-node helm-charts/sqnc-node
```

This will deploy a single Polkadot node with the default configuration.

### Deploying a node with data synced from a snapshot archive (eg. [Polkashot](https://polkashots.io/))

Polkadot:
```console
helm install polkadot-node parity/node --set node.chainDataSnapshotUrl=https://dot-rocksdb.polkashots.io/snapshot --set node.chainDataSnapshotFormat=7z
```

Kusama:
```console
helm install kusama-node parity/node --set node.chainDataSnapshotUrl=https://ksm-rocksdb.polkashots.io/snapshot --set node.chainDataSnapshotFormat=7z --set node.chainPath=ksmcc3
```
⚠️ For some chains where the local directory name is different from the chain ID, `node.chainPath` needs to be set to a custom value.

## Parameters

### Common parameters

| Name               | Description                                 | Value |
| ------------------ | ------------------------------------------- | ----- |
| `nameOverride`     | String to partially override chart.fullname | `""`  |
| `fullnameOverride` | String to fully override chart.fullname     | `""`  |
| `imagePullSecrets` | Labels to add to all deployed objects       | `[]`  |
| `podAnnotations`   | Annotations to add to pods                  | `{}`  |
| `nodeSelector`     | Node labels for pod assignment              | `{}`  |
| `tolerations`      | Tolerations for pod assignment              | `[]`  |
| `affinity`         | Affinity for pod assignment                 | `{}`  |
| `storageClass`     | The storage class to use for volumes        | `""`  |

### Node parameters

| Name                                                                    | Description                                                                                                                          | Value                                                                                |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------ |
| `node.chain`                                                            | Network to connect the node to (i.e. --chain)                                                                                        | `local`                                                                              |
| `node.chainSpecConfigMap`                                               | Existing configmap which contains the chainspec named as chainspec.json                                                              | `""`                                                                                 |
| `node.command`                                                          | Command to be invoked to launch the node binary                                                                                      | `./sqnc-node`                                                                        |
| `node.flags`                                                            | Node flags other than --name (set from the helm release name), --base-path and --chain (both set with node.chain)                    | `["--rpc-external","--rpc-methods=Unsafe","--rpc-cors=all","--unsafe-rpc-external"]` |
| `node.perNodeServices.createApiService`                                 | If enabled, create a generic service to expose common node APIs                                                                      | `true`                                                                               |
| `node.perNodeServices.createP2pService`                                 | If enabled, create a generic P2P network layer                                                                                       | `true`                                                                               |
| `node.perNodeServices.p2pServiceType`                                   | Must be type ClusterIP, NodePort or LoadBalancer. If using type NodePort or LoadBalancer, then you must set NodeSelector accordingly | `ClusterIP`                                                                          |
| `node.perNodeServices.setPublicAddressToExternal.enabled`               | If true sets the `--public-addr` flag to be the NodePort P2P services external address                                               | `true`                                                                               |
| `node.perNodeServices.setPublicAddressToExternal.ipRetrievalServiceUrl` | The external service to return the NodePort IP                                                                                       | `https://ifconfig.io/ip`                                                             |
| `node.keys`                                                             | The list of keys to inject on the node before startup (object{ type, scheme, seed })                                                 | `{}`                                                                                 |
| `node.persistGeneratedNodeKey`                                          | Persist the auto-generated node key inside the data volume (at /data/node-key)                                                       | `false`                                                                              |
| `node.customNodeKey`                                                    | Use a custom node-key, if node.persistGeneratedNodeKey is true then this will not be used. (Must be 64 byte hex key)                 | `nil`                                                                                |
| `node.enableStartupProbe`                                               | If true, enable the startup probe check                                                                                              | `true`                                                                               |
| `node.enableReadinessProbe`                                             | If true, enable the readiness probe check                                                                                            | `true`                                                                               |
| `node.dataVolumeSize`                                                   | The size of the chain data PersistentVolume                                                                                          | `10Gi`                                                                               |
| `node.replicas`                                                         | Number of replicas in the node's StatefulSet                                                                                         | `1`                                                                                  |
| `node.role`                                                             | Set the role of the node: full, authority/validator, collator or light                                                               | `full`                                                                               |
| `node.chainDataSnapshotUrl`                                             | Download and load chain data from a snapshot archive http URL                                                                        | `""`                                                                                 |
| `node.chainDataSnapshotFormat`                                          | The snapshot archive format (tar or 7z)                                                                                              | `tar`                                                                                |
| `node.chainPath`                                                        | Path at which the chain database files are located (/data/chains/${CHAIN_PATH})                                                      | `nil`                                                                                |
| `node.chainDataKubernetesVolumeSnapshot`                                | Initialize the chain data volume from a Kubernetes VolumeSnapshot                                                                    | `""`                                                                                 |
| `node.chainDataGcsBucketUrl`                                            | Sync chain data files from a GCS bucket (eg. gs://bucket-name/folder-name)                                                           | `""`                                                                                 |
| `node.customChainspecUrl`                                               | Download and use a custom chainspec file from a URL                                                                                  | `nil`                                                                                |
| `node.collator.isParachain`                                             | If true, configure the node as a parachain (set the relay-chain flags after --)                                                      | `false`                                                                              |
| `node.collator.relayChain`                                              | Custom relay-chain name                                                                                                              | `nil`                                                                                |
| `node.collator.relayChainCustomChainspecUrl`                            | Download and use a custom relay-chain chainspec file from a URL                                                                      | `nil`                                                                                |
| `node.collator.relayChainDataSnapshotUrl`                               | Download and load relay-chain data from a snapshot archive HTTP URL                                                                  | `nil`                                                                                |
| `node.collator.relayChainDataSnapshotFormat`                            | The relay-chain snapshot archive format (tar or 7z)                                                                                  | `nil`                                                                                |
| `node.collator.relayChainPath`                                          | Path at which the chain database files are located (/data/polkadot/chains/${RELAY_CHAIN_PATH})                                       | `nil`                                                                                |
| `node.collator.relayChainDataKubernetesVolumeSnapshot`                  | Initialize the relay-chain data volume from a Kubernetes VolumeSnapshot                                                              | `nil`                                                                                |
| `node.collator.relayChainDataGcsBucketUrl`                              | Sync relay-chain data files from a GCS bucket (eg. gs://bucket-name/folder-name)                                                     | `nil`                                                                                |
| `node.collator.relayChainFlags`                                         | Relay-chain node flags other than --name (set from the helm release name), --base-path and --chain                                   | `nil`                                                                                |
| `node.podManagementPolicy`                                              | The pod management policy to apply to the StatefulSet                                                                                | `{}`                                                                                 |
| `node.resources`                                                        | Resource requirements and limits for nodes                                                                                           | `{}`                                                                                 |
| `node.serviceMonitor.enabled`                                           | If true, creates a Prometheus Operator ServiceMonitor                                                                                | `false`                                                                              |
| `node.serviceMonitor.namespace`                                         | Prometheus namespace                                                                                                                 | `nil`                                                                                |
| `node.serviceMonitor.internal`                                          | Prometheus scrape interval                                                                                                           | `nil`                                                                                |
| `node.serviceMonitor.scrapeTimeout`                                     | Prometheus scrape timeout                                                                                                            | `nil`                                                                                |
| `node.tracing.enabled`                                                  | If true, creates a Jaeger agent sidecar                                                                                              | `false`                                                                              |
| `node.substrateApiSidecar.enabled`                                      | If true, creates a Substrate API sidecar                                                                                             | `false`                                                                              |

### Image parameters

| Name               | Description            | Value                    |
| ------------------ | ---------------------- | ------------------------ |
| `image.repository` | Node image name        | `digicatapult/sqnc-node` |
| `image.tag`        | Node image tag         | `v12.2.1`                |
| `image.pullPolicy` | Node image pull policy | `Always`                 |

### Init container parameters

| Name                               | Description                                                                                           | Value              |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------- | ------------------ |
| `initContainer.image.repository`   | The chain-snapshot init container image name                                                          | `crazymax/7zip`    |
| `initContainer.image.tag`          | The chain-snapshot init container image tag                                                           | `latest`           |
| `kubectl.image.repository`         | The Kubernetes CLI container image name                                                               | `bitnami/kubectl`  |
| `kubectl.image.tag`                | The Kubernetes CLI container image tag                                                                | `latest`           |
| `googleCloudSdk.image.repository`  | The sync-chain-gcs init container image name                                                          | `google/cloud-sdk` |
| `googleCloudSdk.image.tag`         | The sync-chain-gcs init container image tag                                                           | `slim`             |
| `googleCloudSdk.serviceAccountKey` | Service account key (JSON) to inject into the Sync-chain-gcs init container using a Kubernetes secret | `nil`              |

### Other parameters

| Name                            | Description                                             | Value  |
| ------------------------------- | ------------------------------------------------------- | ------ |
| `serviceAccount.create`         | Specifies whether a service account should be created   | `true` |
| `serviceAccount.annotations`    | Annotations to add to the service account               | `{}`   |
| `serviceAccount.name`           | The name of the service account to use.                 | `""`   |
| `extraLabels`                   | Additional labels to tag resources created by the chart | `{}`   |
| `podSecurityContext.runAsUser`  | Provide the user ID for executing pods                  | `1000` |
| `podSecurityContext.runAsGroup` | Provide the group ID for executing pods                 | `1000` |
| `podSecurityContext.fsGroup`    | Set the file system group for volume mounts             | `1000` |
| `terminationGracePeriodSeconds` | Define the duration for a pod's graceful termination    | `60`   |

### Traffic exposure parameters

| Name                  | Description                                         | Value   |
| --------------------- | --------------------------------------------------- | ------- |
| `ingress.enabled`     | If true, creates an ingress                         | `false` |
| `ingress.annotations` | Annotations to add to the ingress (key/value pairs) | `{}`    |
| `ingress.rules`       | Set rules on the ingress                            | `[]`    |
| `ingress.tls`         | Set TLS configuration on the ingress                | `[]`    |

### Monitoring parameters

| Name                                   | Description                                                | Value                          |
| -------------------------------------- | ---------------------------------------------------------- | ------------------------------ |
| `substrateApiSidecar.image.repository` | The Substrate API sidecar image repository                 | `parity/substrate-api-sidecar` |
| `substrateApiSidecar.image.tag`        | The Substrate API sidecar image tag                        | `latest`                       |
| `substrateApiSidecar.env`              | Environment variables for the sidecar's container          | `[]`                           |
| `substrateApiSidecar.resources`        | Resource requirements and limits for the sidecar           | `{}`                           |
| `jaegerAgent.image.repository`         | The Jaeger agent image repository                          | `jaegertracing/jaeger-agent`   |
| `jaegerAgent.image.tag`                | The Jaeger agent image tag                                 | `1.28.0`                       |
| `jaegerAgent.ports.compactPort`        | Port to use for jaeger.thrift over compact thrift protocol | `6831`                         |
| `jaegerAgent.ports.binaryPort`         | Port to use for jaeger.thrift over binary thrift protocol  | `6832`                         |
| `jaegerAgent.ports.samplingPort`       | Port for HTTP sampling strategies                          | `5778`                         |
| `jaegerAgent.collector.url`            | The URL to which the agent sends data                      | `nil`                          |
| `jaegerAgent.collector.port`           | The port to which the agent sends data                     | `14250`                        |
| `jaegerAgent.env`                      | Environment variables for the agent's container            | `[]`                           |
| `jaegerAgent.resources`                | Resource requirements and limits for the agent             | `{}`                           |

### Test parameters

| Name                                 | Description                                                                                 | Value              |
| ------------------------------------ | ------------------------------------------------------------------------------------------- | ------------------ |
| `tests.backoffLimit`                 | A limit on retry attempts                                                                   | `4`                |
| `tests.osShell.image.repository`     | The utility init container image name                                                       | `bitnami/os-shell` |
| `tests.osShell.image.tag`            | The utility init container image tag                                                        | `latest`           |
| `tests.blockAuthor.enabled`          | A toggle to enable or disable the container that checks the validator is authoring blocks   | `true`             |
| `tests.blockAuthor.pollSeconds`      | The delay in seconds between polls of the current block synchronisation state               | `5`                |
| `tests.blockAuthor.timeoutSeconds`   | The timeout in seconds to allow the validator to author a finalised block                   | `300`              |
| `tests.nodeConnection.minPeerCounts` | The minimum number of peers needed for production chains; dev and local chains require none | `2`                |
