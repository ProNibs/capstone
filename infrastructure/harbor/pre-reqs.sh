#!/bin/zsh

kubectl create ns harbor
helm repo add harbor https://helm.goharbor.io  

echo "Installing Harbor..."
helm upgrade my-harbor harbor/harbor -i --wait -n harbor -f infrastructure/harbor/my_values.yaml --timeout 10m0s