#!/bin/bash

# Builds and starts containers in background

COMPOSE=`which docker-compose`

if [ -z "$COMPOSE" ]; then
  echo 'Could not find docker-compose on your path'
  exit 1
fi

exec $COMPOSE up -d --build "$@"
