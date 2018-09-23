# frozen_string_literal: true

class ChannelSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :description, :youtube_id, :youtube_url, :avatar, :created_at
  attribute :videos_count do |record|
    record.videos.count
  end
end
