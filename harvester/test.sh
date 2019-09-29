#!/bin/bash
docker run --rm -t tupp/harvester bundle exec rspec -I /app -I /spec -r spec_helper.rb -f d /spec
