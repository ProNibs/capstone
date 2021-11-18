#!/bin/zsh

helm repo add https://helm.goharbor.io  
helm upgrade my-harbor harbor/harbor -i -n harbor -f infrastructure/harbor/my_values.yaml