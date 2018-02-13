#!/bin/sh
sleep 20
solr create_core -c egar-gar-search -d /opt/solr/egar-conf-template/gar-search
solr create_core -c egar-people-search -d /opt/solr/egar-conf-template/people-search
