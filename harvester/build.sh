#!/bin/bash
docker build -t tupp/harvester -f Dockerfile ..
container=$(docker run -d --rm tupp/harvester sh)
docker cp $container:/app/Gemfile.lock .
docker stop $container
