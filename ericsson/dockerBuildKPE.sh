#!/bin/bash
DOCKER_PROJ=~/docker/build-kpe

cd $DOCKER_PROJ

docker build --tag=ubuntu/build-kpe14 .

docker run -it ubuntu/build-kpe14
