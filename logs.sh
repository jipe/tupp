#!/bin/bash
COMPOSE=`which docker-compose`

if [ -z $COMPOSE ]; then
  echo 'Could not find docker-compose on your path'
fi

# Use -f for log following
$COMPOSE logs -t $1
