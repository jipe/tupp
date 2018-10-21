FROM ruby:2.5-alpine

# Add Nokogiri runtime dependencies
RUN apk add --no-cache \
    libxml2 \
    libxslt

# Add Nokogiri build dependencies
RUN apk add --no-cache --virtual .nokogiri-builddeps \
    gcc \
    libc-dev \
    libxml2-dev \
    libxslt-dev \
    make

# Create non-root user for running app
RUN adduser -S tupp

# Install gem dependencies
COPY harvester/Gemfile /app/Gemfile
COPY lib /lib
WORKDIR /app

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle install

# Remove Nokogiri build dependencies
RUN apk del .nokogiri-builddeps

# Add application files
COPY harvester/app /app

# Add spec files
COPY harvester/spec /spec

USER tupp

CMD ["bundle", "exec", "ruby", "-I", "/app", "/app/tupp/app.rb"]

