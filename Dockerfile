FROM ruby:2.7.2

WORKDIR /app

COPY Gemfile* ./
COPY package.json ./
COPY yarn.lock ./

RUN apt-get update && \
    apt-get install build-essential -y --no-install-recommends \
    vim

RUN apt-get update && \
    apt-get install curl --no-install-recommends -y

# Install Node 16.x
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get install nodejs --no-install-recommends -y

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn --no-install-recommends -y
RUN yarn install --check-files

RUN gem install bundler -v 2.1.4
RUN bundle install

COPY . /app

RUN rm -rf storage/* nod_modules config/application.yml tmp/cache log/*

COPY docker/entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
