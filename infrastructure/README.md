# Overview

Idea here is to run minimal amounts to get started, then auto-deploy the rest.

Currently, we need to run the following to get up and running:

- Strigo and k8s cluster
    - Calico install is part of this setup process
- kapp-controller via `kapp deploy`
- Jenkins

Yup, that's it. Get it up and running, pull out the .kube/config file, and have it apply everything.
Of note is the fact that we'll need to initially `kubectl port-forward` until we can install ingress.


## Setup Strigo

Just follow the infrastructre/strigo/ README.md's instructions.


## Jenkins Build Images

- For container building, using kaniko's image
    - gcr.io/kaniko-project/executor:v1.5.0-debug
- For deploying stuff via kapp (from dockerhub, I know...)
    - k14s/image
    - If it needs helm installed, will need to swap to:
        - k14s/kapp-controller