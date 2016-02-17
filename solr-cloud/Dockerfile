FROM solr:5.3
MAINTAINER docker@dtic.dk
ENV REFRESHED_AT "2016-02-17"

ADD conf /solr-conf
ADD lib /opt/solr/server/solr/lib

WORKDIR /opt/solr/bin

RUN ./solr start && \
    ./solr create -c metastore -d /solr-conf/metastore/conf -p 8983 && \
    ./solr create -c toc -d /solr-conf/toc/conf -p 8983 && \
    ./solr stop

CMD exec /opt/solr/bin/solr start -f
