#!/bin/sh
echo Starting Solr version: $SOLR_CONFIG_VER
kubectl create -f /home/centos/egar-solr-config/scripts/kube/solr-config-deployment.yaml
kubectl create -f /home/centos/egar-solr-config/scripts/kube/solr-config-service.yaml