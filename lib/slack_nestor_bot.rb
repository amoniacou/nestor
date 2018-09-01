class SlackNestorBot < SlackRubyBot::Bot
  help do
    title 'Nestor the Chronicler'
    desc 'This bot store the chat history'

    command 'assign to room <room>' do
      desc 'Asign to exist Room'
    end
  end
end