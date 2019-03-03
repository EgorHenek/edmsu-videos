class VideosDownload < ApplicationRecord
  belongs_to :video
  has_one_attached :download
end
