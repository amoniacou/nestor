FROM ruby:2.5.1

ENV PG_MAJOR 10
ENV APP_HOME /app
ENV RACK_ENV=development
ENV NODE_VER 8

EXPOSE 3000
EXPOSE 3035

RUN curl -sS -L https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list \
    && sed -i "s/jessie main/jessie main contrib non-free/" /etc/apt/sources.list \
    && echo "deb http://http.debian.net/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list \
    && curl -sL https://deb.nodesource.com/setup_$NODE_VER.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y libpq-dev postgresql-client-$PG_MAJOR libxml2-dev libxslt1-dev unzip imagemagick \
    nodejs yarn \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $APP_HOME

CMD bundle exec puma