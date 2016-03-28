FROM ruby:2.2
RUN apt-get update && apt-get install -y \
      curl \
      ruby \
      && rm -rf /var/lib/apt/lists/*

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ./Gemfile /usr/src/app/
COPY ./Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app