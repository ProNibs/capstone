#!/bin/zsh

kapp deploy -y -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
kapp deploy -y -a default-cluster-rbac -f infrastructure/kapp-controller-sa/serviceAccount.yaml