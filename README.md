Solr config for Egar
-- Egar uses two cores to index and search GAR and Person information --

It uses upstream solr:latest as the base image

to build the image:
docker build . -t egar-solr-image

to run the container:
docker run --name egar-solr -d -p 8983:8983 egar-solr-image:latest

The two Solr cores have been initialised within the container in the following manner:

docker exec -it egar-solr solr create_core -c egar-gar-search -d /opt/solr/egar-conf-template/gar-search

docker exec -it egar-solr solr create_core -c egar-gar-search -d /opt/solr/egar-conf-template/people-search

The image (version 7.2.1) was then saved and pushed to the eGar repository, so no initialisation is now required. Only the startup procedure as shown below:

docker run --name egar-solr -d -p 8983:8983 egar-solr-image:7.2.1

Alternately, the image can be brought up using 'docker-compose' against the following docker-compose.yml file:

solr-config:
  container_name: solr-config
  image: pipe.egarteam.co.uk/solr-config:7.2.0
  expose:
  - "8983"
  
The above configuration exposes the running port (8983) to the rest of the containers. If you want to view the application in a browser aimed at the host running the image, amend the above script in the following way:

solr-config:
  container_name: solr-config
  image: pipe.egarteam.co.uk/solr-config:7.2.0
  ports:
  - "8983:8983"