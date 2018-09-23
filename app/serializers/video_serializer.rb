# frozen_string_literal: true

class VideoSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :description, :youtube_url, :youtube_id, :published_at, :avatar, :duration, :is_stream, :slug, :created_at
  belongs_to :channel
  attributes :stream_start, :stream_end, if: proc { |record|
    record.is_stream
  }
  attributes :live_now, if: proc { |record| record.is_stream}
end
