#!/bin/bash

echo "time = $(date +"%Y-%m-%dT%H:%M:%S.%3N%:z") level = INFO module = tharmigan/conference_service message = Executing the Ballerina application"

if [ "$1" = "graalvm" ];
then
    ./target/bin/conference_service
else
    java -jar ./target/bin/conference_service.jar
fi
