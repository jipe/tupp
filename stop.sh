# Stops and removes containers, networks and volumes

COMPOSE=`which docker-compose`

if [ -z $COMPOSE ]; then
  echo 'Could not find docker-compose on your path'
fi

$COMPOSE down -v
