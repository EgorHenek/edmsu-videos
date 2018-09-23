# frozen_string_literal: true

FactoryBot.define do
  factory :channel do
    initialize_with { new(youtube_url: 'https://www.youtube.com/user/djmagtv') }
  end
end
