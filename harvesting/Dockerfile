FROM debian:jessie
MAINTAINER docker@dtic.dk

# Create non-root user for running app
RUN useradd -U tupp

# Set up build environment
RUN apt-get -q update && \
    apt-get -yq install --no-install-recommends ruby build-essential bundler git

# Install gem dependencies
COPY harvesting/Gemfile /app/Gemfile
COPY lib /lib
WORKDIR /app
RUN exec bundle install

# Add application files
COPY harvesting/app /app

USER tupp
ENTRYPOINT exec bundle exec ruby /app/app.rb 
