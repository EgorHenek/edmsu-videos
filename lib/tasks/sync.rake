namespace :sync do
  task :get_new_videos_from_channels => :environment do
    channels = Channel.all
    channels.each do |channel|
      yt_channel = Yt::Models::Channel.new(id: channel.youtube_id)
      yt_channel.videos.each do |yt_video|
        next if Video.find_by_youtube_id(yt_video.id).present?
        puts yt_video.id
        video = Video.new(youtube_url: "https://www.youtube.com/watch?v=#{yt_video.id}")
        video.channel = channel
        puts video.save
      end
    end
  end
end
