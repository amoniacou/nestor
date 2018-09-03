source 'https://rubygems.org'

gem 'rails', '~> 5.2.0'
gem 'pg', '>= 1.0', '< 2.0'
gem 'activerecord-import'
gem 'sentry-raven'
gem 'webpacker', '~> 3.5.0'
gem 'actioncable', '~> 5.2.0'
gem 'anycable-rails', group: [:production, :development]
gem 'bcrypt', '~> 3.1.7'
gem 'devise', '~> 4.4'

# Slack
gem 'eventmachine'
gem 'celluloid-io'
gem 'slack-ruby-bot'
# Telegram
gem 'telegram-bot-ruby'

group :development, :test do
  gem 'puma'
  gem 'pry-rails'
  gem 'foreman'
  gem 'rspec-rails'
  gem 'factory_bot_rails', '~> 4.0'
  gem 'rubocop', require: false
end

group :test do
  gem 'simplecov', require: false
  gem 'webmock', require: false
  gem 'vcr', require: false
  gem 'database_rewinder', require: false
  gem 'faker'
  gem 'email_spec'
  gem 'shoulda-matchers', github: 'thoughtbot/shoulda-matchers', require: false
end

group :development do
  gem 'listen'
  gem 'letter_opener_web', github: 'fgrehm/letter_opener_web'
end
