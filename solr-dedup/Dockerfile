FROM solr:5.3
MAINTAINER docker@dtic.dk
ENV REFRESHED_AT "2016-02-17"

ADD conf /solr-conf

WORKDIR /opt/solr/bin

RUN ./solr start && \
    ./solr create -c dedup -d /solr-conf/dedup/conf -p 8983 && \
    ./solr stop

CMD exec /opt/solr/bin/solr start -f
