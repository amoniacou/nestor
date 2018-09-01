require 'eventmachine'

namespace :daemon do
  desc 'Running telegram bot server'
  task :telegram => :environment do
    TelegramNestorBot.run
  end
end
