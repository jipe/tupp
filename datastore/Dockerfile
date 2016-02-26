FROM debian:jessie
MAINTAINER docker@dtic.dk

# Create non-root user for running app
RUN useradd -U tupp

# Set up build environment
RUN apt-get -q update && \
    apt-get -yq install --no-install-recommends ruby build-essential bundler

# Install gem dependencies
ADD datastore/Gemfile /app/Gemfile
WORKDIR /app
RUN exec bundle install

# Add application files
ADD datastore/app /app
ADD lib/ruby /ruby-lib

# Tear down build environment
RUN apt-get -yqq purge bundler build-essential

USER tupp
ENTRYPOINT exec ruby -I /ruby-lib /app/app.rb 
