FROM quay.io/billhartcivica/egar-solr-config:7.2.5
MAINTAINER  Keshava.Grama@civica.co.uk
WORKDIR /opt/solr/
RUN mkdir -p egar-conf-template
ADD gar-search /opt/solr/egar-conf-template/gar-search
ADD people-search /opt/solr/egar-conf-template/people-search
ADD start.sh /opt/solr
