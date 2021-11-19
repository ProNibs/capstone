# Overview

This is my capstone project for Flatiron school.
The capstone utilizes 3 git repos for deploying 3 microservices to display a React Frontend.
The rest of this README details my work and what I did.

## Setup Git repo

* Create repo on Github
* `git clone` the repo
* `git checkout -b develop` to create a new branch named "develop"
* Fork **all** of the repos provided by Flatiron to personal Github
    * This is so I can edit the code on my own if desired
* Use [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to pull in the three forked repos
    * `git submodule add "URL"`
    * If looking to clone this from scratch, need to run the following:
        * `git submodule init`
        * `git submodule update`
    * In order to update the submodules:
        * cd to the directory the submodule corresponds to
        * `git fetch`
        * Changes are now available locally

## Developer Steps

After setting up git with the forks and submodules,
the next logical step for me was to put my "developer hat" on.

Detailed instructions [here](DEVELOPER_README.md), but to summarize:

- Created Dockerfile for each Service and ran locally
- Created docker-compose to bring them all together and test Front End functionality
- Created /health endpoints and added them to docker-compose
- Created environment variables for hostnames, ports, usernames, and passwords amongst the services

Biggest struggle was ensuring default values were populated if environment variables were not set
and configuring the flyway database migrations in Spring Boot.

## Configure and Run the Cluster

From here on out, things get interesting.
Assumed that a kind cluster has already been created.
- `kind create cluster` if you haven't already.

## Run Pre-reqs.sh

`./pre-reqs.sh`

The script does the following:

- Install Kapp-Controller
- Prepare a secret `memberlist` and configure kubelet with `strictARP: true` for MetalLB
- Create Jenkins Namespace and Install Jenkins
- Create ~/.kube/config-test for usage inside Jenkins
- Install Harbor and credentials

## After Pre-Reqs

- Upload `~/.kube/config-test` as a secret file in Jenkins
- Configure harbor's nip.io domain name to be forwarded to appropriate k8s service internally
    - `kubectl edit cm/coredns -n kube-system`
    - Above the line `cache 30`, add the following line:
    ```
        rewrite name harbor.127.0.0.1.nip.io my-service.harbor.svc.cluster.local
    ```
- Exec into the KinD docker container and append the following to `/etc/containerd/config.toml`
    - ```
        [plugins."io.containerd.grpc.v1.cri".registry]
          [plugins."io.containerd.grpc.v1.cri".registry.configs]
            [plugins."io.containerd.grpc.v1.cri".registry.configs."harbor.127.0.0.1.nip.io:8443".tls]
              insecure_skip_verify = true
      ```
    - `systemctl restart containerd` afterwards

## After the "After Pre-Reqs"

In a separate terminal, run `kubectl port-forward svc/jenkins -n jenkins 8081:8080`.
Go to https://jenkins.127.0.0.1:8081 to browse the Jenkins UI.

Click the `capstone` project and click `Build Now`.

Watch the magic as the pipeline runs!

## Mid-Jenkins Pause Items to do

- Firstly, check that Ingress+Metallb is working correctly
    - `kubectl get svc -n ingress-nginx`, should see the controller has an External-IP
-Port forward the ingress controller locally
    - `kubectl port-forward svc/ingress-nginx-controller -n ingress-nginx 8080:80 8443:443`
- Navigate the Harbor UI and add a project called `my-repo`
    - https://harbor.127.0.0.1.nip.io:8443
- Run `harborPullSecretSetup.sh`
- Exec into the kind container and run `kubectl port-forward svc/ingress-nginx-controller -n ingress-nginx 8080:80 8443:443`
    - If you don't do the above two steps, you'll get ImageBackOffErrors or worse
    
## After Jenkins Build

Hopefully, you have a properly populated cluster now with the following installed:

- Metallb
- Ingress-nginx
- cert-manager
- Harbor
- Containers for the moisture farm were made and pushed to Harbor
- Moisture farm apps were deployed in k8s