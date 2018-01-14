#!/bin/bash
COMPOSE=`which docker-compose`

if [ -z "$COMPOSE" ]; then
  echo 'Could not find docker-compose on your path'
  exit 1
fi

# Use -f for log following
exec $COMPOSE logs -t $@
