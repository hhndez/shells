#!/bin/bash

GITREPO=ssh://ehuhern@gerrit.ericsson.se:29418/DCOM
WORKSPACE=~/Repositories/
APPS="aaa bbb ccc ddd"


#. test1.sh $GITREPO $WORKSPACE $APPS
. test1.sh $GITREPO $WORKSPACE $APPS


GITREPO=ssh://ehuhern@gerrit.ericsson.se:29418/DCOM1
WORKSPACE=~/Repositories1
APPS="xxx aaa bbb ccc ddd"
