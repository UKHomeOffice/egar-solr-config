Solr config for Egar
-- Egar uses two cores to index and search GAR and Person information --

It uses upstream solr:latest as the base image

to build the image:
docker build . -t egar-solr-image

to run the container:
docker run --name egar-solr -d -p 8983:8983 egar-solr-image:latest

The two Solr cores have been initialised within the container in the following manner:

docker exec -it egar-solr solr create_core -c egar-gar-search -d /opt/solr/egar-conf-template/gar-search

docker exec -it egar-solr solr create_core -c egar-people-search -d /opt/solr/egar-conf-template/people-search

The image (version 7.2.1) was then saved and pushed to the eGar repository, so no initialisation is now required. Only the startup procedure as shown below:

docker run --name egar-solr -d -p 8983:8983 egar-solr-image:7.2.1

Alternately, the image can be brought up using 'docker-compose' against the following docker-compose.yml file:
```yaml
solr-config:
  container_name: solr-config
  image: pipe.egarteam.co.uk/solr-config:7.2.0
  expose:
  - "8983"
  volumes:
  - ./solr/egar-gar-search/:/opt/solr/server/solr/egar-gar-search
  - ./solr/egar-people-search/:/opt/solr/server/solr/egar-people-search
```
The above configuration exposes the running port (8983) to the rest of the containers. If you want to view the application in a browser aimed at the host running the image, amend the above script in the following way:
```yaml
solr-config:
  container_name: solr-config
  image: pipe.egarteam.co.uk/solr-config:7.2.0
  ports:
  - "8983:8983"
  volumes:
  - ./solr/egar-gar-search/:/opt/solr/server/solr/egar-gar-search
  - ./solr/egar-people-search/:/opt/solr/server/solr/egar-people-search
``` 
The volumes directive in the above configurations map two local folders (solr/egar-gar-search and solr/egar-people-search) to folder mounts within the container. In Kubernetes, this is accomplished
in the samme way using a nodeName definition within the configuration file for the node. An example of this is shown below:
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    io.kompose.service: solr-config
  name: solr-config
spec:
  replicas: 1
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        io.kompose.service: solr-config
    spec:
      nodeSelector:
        name: minion02
      containers:
      - image: solr:latest
        name: solr-config
        ports:
        - containerPort: 8983
        resources: {}
        volumeMounts:
        - mountPath: /opt/solr/server/solr/egar-gar-search/
          name: egar-gar-search
        - mountPath: /opt/solr/server/solr/egar-people-search/
          name: egar-people-search
      restartPolicy: Always
      volumes:
      - name: egar-gar-search
        hostPath:
          path: /home/centos/solr/egar-gar-search
      - name: egar-people-search
        hostPath:
          path: /home/centos/solr/egar-people-search
status: {}
```
The above configuration assumes the contents of the two mapped folders have the configuration for each of the Solr Cores within each. These configs are located within this repository under the 'solr'
folder.

Permissions on these folders must be set on the node the volumes are located. For this particular service, the owner/group for all folders should be set to '8983' and the permissions set to (chmod) 700 across
the entire subfolder/file structure.
