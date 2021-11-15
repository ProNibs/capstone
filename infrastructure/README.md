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

## Setup Kapp-controller

We need to setup a service account for Kapp-Controller to utilize after we install kapp-controller itself

- `kapp deploy -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml`
- `kapp deploy -a default-cluster-rbac -f infrastructure/kapp-controller-sa/serviceAccount.yaml`

## Setup Jenkins

Can't just name the "app" jenkins as kapp will get confused, so labeling it as "jenkins.kapp" to avoid that conflict;
otherwise, you'll get a `kapp disallowed labels` type of error.

- `kubectl create ns jenkins`
- If you're following the [Jenkins README](jenkins/README.md),
you might be importing your GitHub Personal Access Token(s). Do that first!
- `kapp deploy -a jenkins.kapp -f infrastructure/jenkins/app/`
- You might see it fail, that's okay. Kapp is just dumb.
    - Manually watch and verify via `kubectl get pods -n jenkins`
- Grab your `~/.kube/config` file and upload it as a Jenkins credential.

## Jenkins Build Images

- For container building, using kaniko's image
    - gcr.io/kaniko-project/executor:v1.5.0-debug
- For deploying stuff via kapp (from dockerhub, I know...)
    - k14s/image
    - If it needs helm installed, will need to swap to:
        - k14s/kapp-controller