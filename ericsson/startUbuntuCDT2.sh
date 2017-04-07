#!/bin/bash

DOCKER_PROJ=~/docker/ubuntu
#Build java project


cd $DOCKER_PROJ

docker build --tag=ubuntu/cdt2 .

#docker run -p 8080:8080 -p 9990:9990 --user=root -t wildfly/admin
#docker run --user=hhndez -it ubuntu/cdt2
docker run -it ubuntu/cdt2
