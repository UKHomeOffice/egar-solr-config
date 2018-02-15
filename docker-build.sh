#!/bin/sh
NAME="${1}"
version=$(./scripts/bash/get-site-version.sh)

docker build -t $NAME:interim .
docker run --name $NAME -d $NAME:interim
sleep 20
docker exec $NAME ./start.sh
docker commit $NAME $NAME:$version
docker stop $NAME
docker rm $NAME
docker rmi $NAME:interim --force
