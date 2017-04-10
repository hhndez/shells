#!/bin/bash
DOCKER_PROJ=~/docker/build-kpe16

cd $DOCKER_PROJ

docker build --tag=ubuntu/build-kpe16 .

docker run -it ubuntu/build-kpe16
