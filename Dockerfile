FROM ruby:2.6.3

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -yqq --no-install-recommends \
    && apt-get install -yqq --no-install-recommends \
       chromium-driver \
       gcc \
       libmagickwand-dev \
       nodejs \
       pkg-config \
       mariadb-client \
       yarn

WORKDIR /smar-003

COPY Gemfile* /smar-003
RUN bundle install -j4 \
    && yarn install --check-files

COPY . /smar-003

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["foreman", "start"]