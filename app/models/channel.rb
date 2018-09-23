# frozen_string_literal: true

class Channel < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :user, optional: true
  has_many :videos
  validates :title, length: { in: 3..255 }, uniqueness: true, presence: true
  validates :youtube_id, presence: true
  validates :youtube_url,
            presence: true,
            uniqueness: true,
            format: { with: /(https?:\/\/)?(www\.)?youtu((\.be)|(be\..{2,5}))\/((user)|(channel))\// }
  validates :slug, presence: true
  attr_readonly :title, :youtube_id, :avatar

  after_initialize do
    if youtube_url.nil?
      errors.add(:youtube_url, :presence)
      raise ActiveRecord::RecordInvalid, self
    end
    if new_record?
      channel = Yt::Models::Channel.new(id: Yt::URL.new(youtube_url).id)
      self.youtube_id = channel.id
      self.title = channel.title
      self.description = channel.description
      self.avatar = channel.thumbnail_url
    end
  end
end
