#!/bin/zsh

kubectl create ns harbor
helm repo add harbor https://helm.goharbor.io  
helm upgrade my-harbor harbor/harbor -i -n harbor -f infrastructure/harbor/my_values.yaml