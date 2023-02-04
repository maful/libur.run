# Use the Alpine Linux distribution as the base image
FROM ruby:3.1.2-alpine

# Variable
ARG WORK_DIR=/liburrun_app
ARG BUNDLER_VERSION=2.3.24

ENV BUNDLER_VERSION=${BUNDLER_VERSION}

# Set the working directory in the container
WORKDIR ${WORK_DIR}

# Install dependencies
RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    tzdata \
    nodejs \
    yarn \
    git \
    bash \
    && rm -rf /var/cache/apk/*

# add libvips for the image analysis and transformations
RUN apk add --update --no-cache file vips

# Fix [Linux musl] "Error loading shared library"
RUN apk add --update --no-cache gcompat

# Copy the Gemfile and Gemfile.lock to the image
COPY Gemfile Gemfile.lock package.json yarn.lock ./

# Install specific bundler
RUN gem install bundler:${BUNDLER_VERSION} --no-document

# Install the gems
RUN bundle install --retry=2

# Install the packages
RUN yarn install

# Copy the rest of the application code to the image
COPY . .

EXPOSE 3000

CMD ["/bin/sh"]
