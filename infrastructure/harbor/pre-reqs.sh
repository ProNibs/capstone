#!/bin/zsh

kubectl create ns harbor
kubectl apply -f infrastructure/harbor/my_service.yaml
kubectl create secret docker-registry regcred \
    --docker-server=https://harbor.127.0.0.1.nip.io:8443 \
    --docker-username=admin \
    --docker-password=Harbor12345 \
    -n jenkins

helm repo add harbor https://helm.goharbor.io  

echo "Installing Harbor..."
helm upgrade my-harbor harbor/harbor -i -n harbor -f infrastructure/harbor/my_values.yaml
echo "Giving Harbor 3 minutes to stand up"
sleep 180

# Do I auto-add the nip.io rewrite for coredns?
#if grep -q "nip.io"  

# Create projects in Harbor via API
baseURL='harbor.127.0.0.1.nip.io:8443/api/v2.0/'
# Nvm...
echo "Remember to create a project in Harbor for pushing images to."


