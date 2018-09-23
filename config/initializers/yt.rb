# frozen_string_literal: true

Yt.configure do |config|
  config.api_key = Rails.application.credentials[Rails.env.to_sym][:youtube_api_key]
end
