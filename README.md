# Nestor the chronicler

An application for helping teams have a one point of all chat histories from different chat applications.
There are many cases when internally team chats in Slack, but with client in Skype and there are many situations when info was in different chats. 

## Setup

```sh
docker-compose build
docker-compose run app bundle install
docker-compose run app bundle exec rake db:create db:migrate db:seed
docker-compose run app bundle exec yarn install
```

## Local run

```sh
docker-compose run -p 3000:3000 -p 3035:3035 app
```

## Local tests

### DB Setup

```sh
docker-compose run tests rake db:create db:migrate
```

### Run
```sh
docker-compose run tests rake
```
