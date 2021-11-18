#!/bin/zsh

# Create jenkins namespace
kubectl create ns jenkins
# Setup GitHub PAT Secret in jenkins namespace
source ./infrastructure/jenkins/github_pat.sh

# MetalLB requires strictARP=false beforehand
source ./infrastructure/metallb/pre-reqs.sh
# Install Kapp-Controller
source ./infrastructure/kapp-controller-sa/pre-reqs.sh
# Install Jenkins
kapp deploy -y -a jenkins.kapp -f infrastructure/jenkins/app/

# Create config-test file from config file
rm ~/.kube/config-test
sed -E 's/127.0.0.1:[0-9]+/kubernetes.default/g' ~/.kube/config > ~/.kube/config-test

# Run nip.io for local sanity and hostname resolving without editing /etc/hosts like a madman
# Only needs to be done last night
#cd nip.io && source ./build_and_run_docker.sh

# Reminder for next steps
echo "Remember to create a jenkins secret file with ID=kube-config-v2 based on ~/.kube/config-test"

# Get Jenkins admin password
echo "Jenkins Password:" 
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo