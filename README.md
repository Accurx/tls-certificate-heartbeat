# Accurx - tls-certificate-heartbeat Helm Chart

## Use as a sub-chart (dependency)

Example requirements.yaml:
```yaml
dependencies:
  - name: 'tls-certificate-heartbeat' 
    version: 0.1.1
    repository: https://accurx.github.io/tls-certificate-heartbeat
```
Example values.yaml config:
```yaml
tls-certificate-heartbeat:
  schedule: "*/10 * * * *"  # every 10m
  expiryThresholdSeconds: 604800  # 7 days
  namespaces:
    default:
      certificates:
        - secretName: accurx-certificate
          heartBeatUrl: https://accurx.com/heartbeat/ACCURX-1234
        - secretName: wildcard-accurx-certificate
          heartBeatUrl: https://accurx.com/heartbeat/ACCURX-5678
```

## Get Repo

```console
helm repo add tls-certificate-heartbeat https://accurx.github.io/tls-certificate-heartbeat/chart
helm repo update
```

## Install Chart

```console
# Helm install with cronjobs namespace already created
helm install -n cronjobs [RELEASE_NAME] tls-certificate-heartbeat

# Helm install and create namespace
helm install -n cronjobs [RELEASE_NAME] tls-certificate-heartbeat --create-namespace
```

_See [parameters](#parameters) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrade Chart

```console
helm upgrade -n cronjobs [RELEASE_NAME] tls-certificate-heartbeat
```

## Parameters

| Parameter                          | Description                                                                                                                       | Default                                                 |
| :--------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------ |
| schedule | cron formatted schedule, of how frequently to run the heartbeat & validated the certificate expiry | `*/15 * * * *` |
| expiryThresholdSeconds | If the target certificate will expire within the specified timeframe, the heartbeat will not be sent! This allows for visibility on a soon to expire certificate on the cluster. | `604800` |
| namespaces.\<namespace\>.certificates | List of each certificate to check and in which cluster namespace these reside. | ``` - secretName: <secret name on the cluster>        heartBeatUrl: <external HTTP url to ping>``` |

## Example values file:
```
schedule: "*/10 * * * *"  # every 10m
expiryThresholdSeconds: 604800  # 7 days
namespaces:
  default:
    certificates:
      - secretName: accurx-certificate
        heartBeatUrl: https://accurx.com/heartbeat/ACCURX-1234
      - secretName: wildcard-accurx-certificate
        heartBeatUrl: https://accurx.com/heartbeat/ACCURX-5678
  metrics:
    certificates:
      - secretName: accurx-metrics-certificate
        heartBeatUrl: https://accurx.com/heartbeat/ACCURX-1234
```

## Debugging cronjob process
`kubectl get pods -n <namespace> | grep "tls-certificate-heartbeat"`

`kubectl logs -n <namespace> <pod>`


## Testing locally:

Ensure docker is running:
`docker ps`

Using kind create a new local cluster:
`kind create cluster`

Run install of chart:
```
cd tls-certificate-heartbeat/chart
helm install -f values.yaml tls-certificate-heartbeat . -n cronjobs
```

## Publishing a new version:

1. Bump the version number in chart/Chart.yaml to an appropriate semantic version based on changes.

2. Package a new version of the chart.
  `helm package chart/`

3. Generate a new index to point to the new release with:
  `helm repo index --url https://accurx.github.io/tls-certificate-heartbeat .`

4. Add the built .tgz & index.html files to github.

