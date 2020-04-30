# Teknoid cluster manifest

This repository contains all the manifest for the **Teknoid** cluster, which hosts the Edutech Media SA applications on Google Kubernetes Engine.

Proudly maintained by:

- Valentin Pollart <valentin@mathrix.fr>
- Mathieu Bour <mathieu@mathrix.fr>

## Structure

The manifests are grouped by **application** and are based on Kustomize v3.
Kustomize may be installed alongside kubectl with the following [script](https://github.com/mathrix-education/useful-scripts/blob/master/kustomize/install-ubuntu.sh).

### Namespaces
The "shared" namespaces are in the `/src/namespaces` directory.
The "application" namespaces are in their respective directory.

### Single overlay applications
Single overlay applications directory structure fulfills the following conventions:

1. The configuration files, if any, go into the `config` folder. They may be passed to deployments as secrets using the Kustomize [`secretGenerator`](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/secretGeneratorPlugin.md) if they contain sensitive data.
2. Other Kubernetes manifests go directly aside the `kustomization.yaml` file.

Example of redis manifests:

```
src/redis/
├── config
│   └── redis.conf
├── deployment.yaml
├── kustomization.yaml
├── pvc.yaml
└── service.yaml
```

### Multi overlay applications
Multi overlay applications are usually sandboxed using namespaces.
The standard Edutech Media SA conventions on environements are the following:

| Environment / namespace | Git branch |
|-------------------------|------------|
| production              | production |
| stage                   | stage      |
| edge                    | master     |

1. The "base" manifests go into the `base` directory and follows the *single overlay applications* conventions.
2. The overlays go into the `overlay` directory.

Therefore, using the example of the railgun manifest:

```
src/railgun/
├── base
│   ├── ingress.yaml
│   ├── kustomization.yaml
│   ├── nginx.conf
│   ├── server.deployment.yaml
│   ├── server.service.yaml
│   └── worker.deployment.yaml
└── overlays
    ├── edge
    │   ├── ingress.yaml
    │   ├── keychain
    │   │   ├── login.json
    │   │   └── reset.json
    │   ├── kustomization.yaml
    │   └── service-account.yaml
    ├── production
    │   ├── ingress.yaml
    │   ├── keychain
    │   │   ├── login.json
    │   │   └── reset.json
    │   ├── kustomization.yaml
    │   ├── server.deployment.yaml
    │   ├── service-account.yaml
    │   └── worker.deployment.yaml
    └── stage
        ├── ingress.yaml
        ├── keychain
        │   ├── login.json
        │   └── reset.json
        ├── kustomization.yaml
        └── service-account.yaml
```

## Applying manifests

Teknoid applications manifests can be applied using the following script:

```bash
./scripts/apply.sh <app> [overlay]
```

The script will apply the latest changes on the Teknoid cluster and purge any outdated ConfigMap or Secret.
