require 'eventmachine'

namespace :daemon do
  desc 'Running slack bot server'
  task :slack => :environment do
    SlackNestorBot.instance.on :message, ::SlackBot::MessageProcessor.new
    SlackNestorBot.run
  end
end
