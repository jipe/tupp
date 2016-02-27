FROM debian:jessie
MAINTAINER docker@dtic.dk

# Add PostgreSQL Apt Repository for using any version of PostgreSQL
#RUN apt-get update -q && \
#    apt-get install -yqq wget && \
#    echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
#    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

RUN apt-get -q update && \
    apt-get -yq install postgresql-9.4

USER postgres

RUN pg_ctlcluster 9.4 main start && \
    createuser --createdb tupp && \
    echo "alter role tupp with password 'tupp'" | psql && \
    export PGHOST=localhost PGUSER=tupp PGPASSWORD=tupp && \
    createdb enqueueing && \
    createdb index_doc_generation && \
    unset PGHOST PGUSER PGPASSWORD && \
    pg_ctlcluster 9.4 main stop

VOLUME /var/lib/postgresql

EXPOSE 5432

CMD exec pg_ctlcluster --foreground 9.4 main start
