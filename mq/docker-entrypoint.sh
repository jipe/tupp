#!/bin/sh
server=rabbitmq-server
ctl=rabbitmqctl
plugins=rabbitmq-plugins
delay=3

echo '[Configuration] Starting RabbitMQ in detached mode.'

$server -detached

echo "[Configuration] Waiting $delay seconds for RabbitMQ to start."

sleep $delay

echo '*** Enabling plugins ***'
$plugins enable --online rabbitmq_management

echo '*** Creating virtual hosts ***'
$ctl add_vhost /ds2

echo '*** Setting virtual host permissions ***'
$ctl set_permissions -p / guest '.*' '.*' '.*'
$ctl set_permissions -p /ds2 guest '.*' '.*' '.*'

$ctl stop

echo "[Configuration] Waiting $delay seconds for RabbitMQ to stop."

sleep $delay

echo 'Starting RabbitMQ in foreground (CTRL-C to exit)'

exec $server
