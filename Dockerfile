FROM ghcr.io/graalvm/native-image:ol8-java11-22.3.3 as build

WORKDIR /app/build

COPY target/bin/conference_service.jar .

RUN native-image -jar conference_service.jar --no-fallback

FROM debian:stable-slim

RUN apt-get install coreutils

WORKDIR /home/ballerina

COPY --from=build /app/build/conference_service .

CMD echo "time = $(date +"%Y-%m-%dT%H:%M:%S.%3NZ") level = INFO module = tharmigan/conference_service message = Executing the Ballerina application" && "./conference_service"