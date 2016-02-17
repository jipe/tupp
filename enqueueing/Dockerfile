FROM debian:jessie
MAINTAINER docker@dtic.dk
ENV REFRESHED_AT 2016-02-16

RUN useradd -U tupp

RUN apt-get -yq update && \
    apt-get -yq --no-install-recommends install ruby ruby-bunny ruby-pg

ADD enqueueing/app /app
ADD ruby-lib /ruby-lib
USER tupp
ENTRYPOINT exec ruby -I /ruby-lib /app/app.rb
