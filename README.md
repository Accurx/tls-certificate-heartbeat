# Accurx - tls-certificate-heartbeat Helm Chart

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
| namespaces.<namespace>.certificates | List of each certificate to check and in which cluster namespace these reside. | ``` - secretName: <secret name on the cluster>        heartBeatUrl: <external HTTP url to ping>``` |

