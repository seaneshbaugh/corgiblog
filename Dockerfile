FROM ruby:2.5.3

ENV APP_HOME /portfolio
ENV BUNDLER_VERSION 1.17.2
ENV APP_PORT 3000

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y -q build-essential libpq-dev libvips libvips-dev nodejs yarn && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock
COPY package.json $APP_HOME/package.json
COPY yarn.lock $APP_HOME/yarn.lock
RUN yarn --pure-lockfile
RUN gem install bundler -v $BUNDLER_VERSION && \
    bundle install && \
    yarn install
RUN npm rebuild node-sass
COPY . $APP_HOME

EXPOSE $APP_PORT

CMD ["bundle", "exec", "rails", "server", "-p", $APP_PORT, "-b", "0.0.0.0"]
