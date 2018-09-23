# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
channels = [
    'https://www.youtube.com/channel/UCOloc4MDn4dQtP_U6asWk2w',
    'https://www.youtube.com/channel/UCPKT_csvP72boVX0XrMtagQ',
    'https://www.youtube.com/channel/UCJEKlziKdxoos1qbptjGgLg',
    'https://www.youtube.com/channel/UCQdCIrTpkhEH5Z8KPsn7NvQ',
    'https://www.youtube.com/channel/UCAEwCfBRlB3jIY9whEfSP5Q'
]

channels.each { |channel| Channel.create(youtube_url: channel) }
