FROM debian:jessie
MAINTAINER docker@dtic.dk

RUN apt-get -q update && \
    apt-get -yq install postgresql-9.4

USER postgres

RUN pg_ctlcluster 9.4 main start && \
    createuser --createdb tupp && \
    echo "alter role tupp with password 'tupp'" | psql && \
    pg_ctlcluster 9.4 main stop && \
    echo "host all tupp 0.0.0.0/0 md5" >> /etc/postgresql/9.4/main/pg_hba.conf && \
    echo "listen_addresses = '*'" >> /etc/postgresql/9.4/main/postgresql.conf

EXPOSE 5432

CMD exec pg_ctlcluster --foreground 9.4 main start
