FROM phusion/passenger-ruby24:0.9.28

ENV PG_MAJOR 10
ENV APP_HOME /home/app/webapp
ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV NODE_VER 8

EXPOSE 3000
VOLUME /home/app/webapp/public/uploads

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

RUN rm /etc/nginx/sites-enabled/default
ADD docker/nginx.conf /etc/nginx/sites-enabled/default
ADD docker/deploy_tasks.sh /etc/my_init.d/deploy_tasks.sh
RUN rm -f /etc/service/nginx/down
CMD ["/sbin/my_init"]
COPY Gemfile /home/app/bundle-cache/Gemfile
COPY Gemfile.lock /home/app/bundle-cache/Gemfile.lock
RUN chown -R app /home/app/bundle-cache
RUN su app -c 'cd /home/app/bundle-cache && \
                       bundle install \
                            --without development test \
                            --jobs=2 \
                            --path=/home/app/bundle \
                            --no-cache'
RUN cp -a /home/app/bundle-cache/.bundle /home/app/webapp
# Install node_modules with yarn
ADD package.json yarn.lock /tmp/
RUN cd /tmp && yarn
WORKDIR $APP_HOME
RUN mkdir -p ${APP_HOME} && ln -s /tmp/node_modules
COPY / $APP_HOME
ADD docker/dokku.nginx.sigil $APP_HOME/nginx.conf.sigil
ADD docker/default_env.conf /etc/nginx/main.d/default_env.conf
RUN mkdir -p log tmp/pids public
RUN chown -R app:app /home/app/webapp
RUN su app -c 'cd /home/app/webapp && bundle exec ./bin/rake assets:precompile SKIP_SIDEKIQ=1'
RUN rm -rf /tmp/*