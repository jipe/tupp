FROM debian:jessie
MAINTAINER docker@dtic.dk

RUN apt-get -qq update && \
    apt-get -yq install wget && \
    wget -O- https://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add - && \
    echo 'deb http://www.rabbitmq.com/debian/ testing main' > /etc/apt/sources.list.d/rabbitmq.list && \
    apt-get -qq update && \
    apt-get -yq install rabbitmq-server

EXPOSE 5671 5672 15671 15672

CMD exec rabbitmq-server
