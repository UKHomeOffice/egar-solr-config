#!/bin/sh
kubectl delete -f /home/centos/egar-solr-config/scripts/kube/solr-config-deployment.yaml
kubectl delete -f /home/centos/egar-solr-config/scripts/kube/solr-config-service.yaml