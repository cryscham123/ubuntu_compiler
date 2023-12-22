#!/bin/bash

export RESOURCE_PWD=${HOME}/boj/resource
# validate current path's files
cp -r . ${RESOURCE_PWD}/files
if [ $? -ne 0 ]; then
	exit 1
fi
docker-compose -f ${RESOURCE_PWD}/docker-compose.yaml build
if [ $? -ne 0 ]; then
	exit 1
fi
docker-compose -f ${RESOURCE_PWD}/docker-compose.yaml up
if [ $? -ne 0 ]; then
	exit 1
fi
# display output
rm -r ${RESOURCE_PWD}/files
