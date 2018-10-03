require 'dotenv'
require 'telegram/bot'

Dotenv.load(File.join(__dir__, '.env'))

messages = JSON.parse(File.read(File.join(__dir__, 'messages.json')))
message_times = []
Telegram::Bot::Client.run(ENV['API_TOKEN']) do |bot|
  if ARGV[0] && !ARGV[0].empty?
    bot.api.sendMessage chat_id: ENV['CHANNEL_ID'], text: ARGV[0]
  else
    begin
      bot.listen do |message|
        message_times.push Time.now
        if message_times.length > 20
          time_difference = message_times.last - message_times.first
          if time_difference < (20 * 60)
            if time_difference > 10
              sleep 2
              bot.api.sendMessage chat_id: ENV['CHANNEL_ID'], text: messages.sample
            end
            message_times = []
          end
          message_times.shift
        end
      end
    rescue Telegram::Bot::Exceptions::ResponseError => e
      if e.error_code.to_s == '502'
        puts 'telegram stuff, nothing to worry!'
        retry
      end
    end
  end
end
