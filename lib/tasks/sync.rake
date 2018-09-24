# frozen_string_literal: true

namespace :sync do
  task get_new_videos_from_channels: :environment do
    channels = Channel.all
    channels.each do |channel|
      yt_channel = Yt::Models::Channel.new(id: channel.youtube_id)
      next if channel.videos.first.youtube_id == yt_channel.videos.first.id

      yt_channel.videos.each do |yt_video|
        break if Video.find_by_youtube_id(yt_video.id).present?

        video = Video.new(youtube_url: "https://www.youtube.com/watch?v=#{yt_video.id}")
        video.channel = channel
        video.save
      end
    end
  end
  task update_lives: :environment do
    videos = Video.where('is_stream = ? AND DATE(stream_start) < ? AND stream_end = NULL', true, DateTime.now)
    videos.each do |video|
      yt_video = Yt::Models::Video.new(id: video.youtube_id)
      video.stream_end = yt_video.actual_end_time || yt_video.scheduled_end_time
      video.duration = yt_video.duration if video.stream_end
      video.save
    end
  end
end
