# Builds and starts containers in background

COMPOSE=`which docker-compose`

if [ -z $COMPOSE ]; then
  echo 'Could not find docker-compose on your path'
fi

$COMPOSE up -d --build
