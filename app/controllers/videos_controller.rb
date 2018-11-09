class VideosController < ApplicationController
  before_action :set_video, only: [:show, :update, :destroy]
  load_and_authorize_resource

  # GET /videos
  def index
    if params[:channel_id].present?
      @videos = paginate Channel.friendly.find(params[:channel_id]).videos
    else
      @videos = paginate Video.all
    end

    render json: VideoSerializer.new(@videos).serialized_json
  end

  # GET /videos/1
  def show
    related_videos = Video.unscope(:select, :order)
                          .select("videos.*, title <-> '#{@video.title}' AS dist,CASE WHEN videos.stream_start < NOW() \
AND videos.stream_end IS NULL OR videos.stream_end > NOW() THEN TRUE ELSE FALSE END as live_now")
                          .order('DIST')
                          .limit(3)
                          .offset(1)
    render json: VideoSerializer.new(@video, params: { related: related_videos }).serialized_json
  end

  # POST /videos
  def create
    @video = Video.new(video_params)

    if @video.save
      render json: VideoSerializer.new(@video).serialized_json, status: :created, location: @video
    else
      render json: {success: false, errors: @video.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /videos/1
  def update
    if @video.update(edit_video_params)
      related_videos = Video.unscope(:select, :order)
                           .select("videos.*, title <-> '#{@video.title}' AS dist,CASE WHEN videos.stream_start < NOW() \
AND videos.stream_end IS NULL OR videos.stream_end > NOW() THEN TRUE ELSE FALSE END as live_now")
                           .order('DIST')
                           .limit(3)
                           .offset(1)
      render json: VideoSerializer.new(@video, params: { related: related_videos }).serialized_json
    else
      render json: {success: false, errors: @video.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # DELETE /videos/1
  def destroy
    @video.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def video_params
      params.require(:video).permit(:youtube_url, :description, :channel_id)
    end

    def edit_video_params
      params.require(:video).permit(:description, :channel_id, :is_stream)
    end
end
