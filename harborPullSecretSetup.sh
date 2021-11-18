#!/bin/zsh

kubectl create secret docker-registry harborcred \
    --docker-server=https://harbor.127.0.0.1.nip.io:8443 \
    --docker-username=admin \
    --docker-password=Harbor12345 \
    --docker-email=andrewsgraham1995@gmail.com \
    -n dashboard-web

kubectl create secret docker-registry harborcred \
    --docker-server=https://harbor.127.0.0.1.nip.io:8443 \
    --docker-username=admin \
    --docker-password=Harbor12345 \
    --docker-email=andrewsgraham1995@gmail.com \
    -n dashboard-api

kubectl create secret docker-registry harborcred \
    --docker-server=https://harbor.127.0.0.1.nip.io:8443 \
    --docker-username=admin \
    --docker-password=Harbor12345 \
    --docker-email=andrewsgraham1995@gmail.com \
    -n aggregator-service

kubectl create secret docker-registry harborcred \
    --docker-server=https://harbor.127.0.0.1.nip.io:8443 \
    --docker-username=admin \
    --docker-password=Harbor12345 \
    --docker-email=andrewsgraham1995@gmail.com \
    -n supplemental-service