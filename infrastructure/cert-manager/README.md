# Overview

Need cert-manager for stuff to work like ever.
Ugh.

## Kapp-Controller

Attempted to do kapp-controller. However, the git repo doesn't have real Chart.yaml file, it has Chart.yaml.template.
Never figured out how to properly pull from helm repo, so have to resort to a `kapp deploy`.

## Kapp Deploy

`kapp deploy -a cert-manager.kapp -f https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml`

## Create self-signed cert

`kapp deploy -a self-signed.kapp -f infrastructure/cert-manager/k8s/`

## Reference

[cert-manager helm chart values file](https://github.com/jetstack/cert-manager/blob/release-1.7/deploy/charts/cert-manager/values.yaml)