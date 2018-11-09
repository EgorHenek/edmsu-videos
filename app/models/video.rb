# frozen_string_literal: true

class Video < ApplicationRecord
  include AlgoliaSearch
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :user, optional: true
  belongs_to :channel, optional: true
  validates :title, presence: true
  validates :youtube_url,
            presence: true,
            uniqueness: true,
            format: { with: /(?:(?:http(?:s?):\/\/)|(?:www\.)|(?:http(?:s?):\/\/www\.))(?:youtu\.?be(?:\.com)?\/(?!oembed))(?:(?:watch\?v(?:=|%3D))|(?:v\/))?([a-z0-9_-]+)/i }
  validates :youtube_id, presence: true, uniqueness: true
  validates :duration, numericality: { only_integer: true }
  validates :slug, presence: true, uniqueness: true
  attr_readonly :title, :youtube_url, :youtube_id, :avatar
  default_scope do
    select('videos.*, CASE WHEN videos.stream_start < NOW() AND videos.stream_end IS NULL OR videos.stream_end > NOW() THEN TRUE ELSE FALSE END as live_now')
      .where('is_stream=true OR duration > 1200')
      .order('live_now DESC', published_at: :desc)
  end

  after_initialize do
    if youtube_url.nil?
      errors.add(:youtube_url, :blank)
      raise ActiveRecord::RecordInvalid, self
    end
    if new_record?
      video = Yt::Models::Video.new(id: Yt::URL.new(youtube_url).id)
      self.youtube_id = video.id
      self.title = video.title
      self.published_at = video.published_at if video.published_at.present?
      self.description = video.description if description.blank?
      self.avatar = video.thumbnail_url
      self.duration = video.duration
      self.is_stream = %w[live upcoming].include?(video.live_broadcast_content)
      self.stream_start = video.actual_start_time || video.scheduled_start_time
      self.stream_end = video.actual_end_time || video.actual_end_time
    end
  end

  algoliasearch per_environment: true do
    attributes :title, :slug, :duration, :avatar, :published_at
    searchableAttributes ['title']
    customRanking ['desc(published_at)']
  end
end
