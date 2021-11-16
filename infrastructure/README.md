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
- Grab your `~/.kube/config` file for your cluster and make a copy of it
- If you're deploying to the same K8s cluster you are running Jenkins from:
    - Edit the `~/.kube/config-copy`'s clusters.cluster.server to be `server: https://kubernetes.default`
    - This has jenkins use the internal kubeapi-server rather than going out to the Internet and back into the cluster
- If you're deploying to a separate cluster than when you are running Jenkins from, you're done.
- After making the kube config copy and editing it,
go to the Jenkins UI and add a `secret file` credential with an ID of `kube-config-v2`.
- You're done! That credential ID is automatically picked up by any steps in the Jenkinsfile using kapp and other carvel tools.

## Setup MetalLB Stuff

I can't get Kubectl to run inside a pod sadly, so this just can't be 100% automated sadly.

Follow the metallb [README](./metallb/README.md) for setup instructions.

Anytime Strigo changes public IP addresses,
you have to pray to the DNS Gods and cd into the metallb folder and run the `get_public_ips.sh` script.
Takes Strigo's DNS names to resolve when they first boot.

## Jenkins Build Images

- For container building, using kaniko's image
    - gcr.io/kaniko-project/executor:v1.5.0-debug
- For deploying stuff via kapp (from dockerhub, I know...)
    - k14s/image
    - If it needs helm installed, will need to swap to:
        - k14s/kapp-controller