#!/bin/bash

DOCKER_PROJ=~/docker/wildfly
#Build java project
JAVA_PROJ=~/samples/earTemplate

cd $JAVA_PROJ
./gradlew clean build ear

cp $JAVA_PROJ/build/libs/earTemplate.ear $DOCKER_PROJ

cd $DOCKER_PROJ

docker build --tag=wildfly/admin .

docker run -p 8080:8080 -p 9990:9990 --user=root -t wildfly/admin
