#!/bin/bash
echo "PARAMS $#"
echo "values $@"
if [ $# -lt 3 ]
then
	echo "ERROR $#"
	exit 1;
else
	echo "OK"
fi

gitRepo=$1
Workspace=$2
Apps=( "$@" )

echo $Apps[@]
counter=3
for (( c=$counter; $counter<=$#; c++))
do
	echo $c
	echo $Apps[$c]
	let counter=counter+1
done






echo "REpo=$gitRepo"
echo "Work=$Workspace"
echo "Apps=$Apps"
