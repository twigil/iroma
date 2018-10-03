require 'telegram/bot'

MESSAGES = [
  'ШАО-ФАО ФСЬ',
  'ЧМОШКА',
  'ВСМЫСИ',
  'КАЛОМ БУР, А ТЕЛОМ БЕЛ',
  'МИСТАР МЫШ ВЫ КУДА?',
  'ТРУНЬ',
  'НУ ТАКОЕ',
  'НИЧЕГО НЕ ЗНАЮ ОБ ЭТОМ',
  'ААААЭЭ',
  'Я КОТИК',
  'ЧМОШКА',
  'ГЛАВНАЯ ПРОБЛЕМА В НАШЕЙ КОМАНДЕ — ЭТО ЛИЧНО ТЫ',
  'ОПЯТЬ В РЕЙТИНГЕ СКАТИМСЯ',
  'ПЕРЕСТАНЬ',
  'АЛЛО',
  'ОЧЕНЬ ПЛОХО',
  'МНЕ ТЯЖЕЛО',
  'А ПО СУТИ',
  'Я РАБОТАЮ',
  'Я БОЛЕЮ',
  'ЧТО ТЫ ЗА ЧЕЛОВЕК ТАКОЙ',
  'КАК СИДИМ, ТАК И СИДИМ',
  'ЛЕСТЬ? КУДА ЛЕСТЬ?',
  'А ЗРЯ',
  'ТЕБЕ НЕЛЬЗЯ',
  'Я ГНУСЬ'
].freeze

TOKEN = 'NO_TOKEN'.freeze

CHANNEL_ID = 'NO_ID'.freeze

message_times = []

Telegram::Bot::Client.run(TOKEN) do |bot|
  if ARGV[0] && !ARGV[0].empty?
    bot.api.sendMessage chat_id: CHANNEL_ID, text: ARGV[0]
  else
    begin
      bot.listen do |message|
        message_times.push Time.now
        if message_times.length > 20
          time_difference = message_times.last - message_times.first
          if time_difference < (20 * 60)
            if time_difference > 10
              sleep 2
              bot.api.sendMessage chat_id: CHANNEL_ID, text: MESSAGES.sample
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
