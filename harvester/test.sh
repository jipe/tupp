#!/bin/bash
docker run --rm -t tupp/harvester bundle exec rspec -I /app -I /spec /spec
