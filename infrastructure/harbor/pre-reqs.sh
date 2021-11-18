#!/bin/zsh

kubectl create ns harbor
helm repo add harbor https://helm.goharbor.io  

echo "Installing Harbor..."
helm upgrade my-harbor harbor/harbor -i --wait -n harbor -f infrastructure/harbor/my_values.yaml --timeout 10m0s

# Create projects in Harbor via API
baseURL='harbor.127.0.0.1.nip.io:8443/api/v2.0/'
# Nvm...
echo "Remember to create a project in Harbor for pushing images to."


