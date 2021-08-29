FROM ruby:2.6.3

RUN mkdir /smar-003

WORKDIR /smar-003

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y \
    chromium-driver \
    gcc \
    libmagickwand-dev \
    libpq-dev \
    nodejs \
    pkg-config \
    postgresql-client \
    yarn
COPY Gemfile /smar-003/Gemfile
COPY Gemfile.lock /smar-003/Gemfile.lock
RUN bundle install -j4 \
    && yarn install --check-files \
    && yarn cache clean
COPY . /smar-003

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["foreman", "start"]