#!/bin/bash
DOCKER_PROJ=~/docker/ubuntu-git

cd $DOCKER_PROJ

docker build --tag=ubuntu/git2 .

docker run -it ubuntu/git2
