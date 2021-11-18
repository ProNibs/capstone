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

