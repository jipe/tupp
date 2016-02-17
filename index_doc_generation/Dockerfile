FROM debian:jessie
MAINTAINER docker@dtic.dk
ENV REFRESHED_AT 2016-02-16

RUN useradd -U tupp

RUN apt-get update -q && \
    apt-get --no-install-recommends -yq install ruby ruby-bunny ruby-pg

ADD index_doc_generation/app /app
ADD ruby-lib /ruby-lib
USER tupp
ENTRYPOINT exec ruby -I /ruby-lib /app/app.rb
