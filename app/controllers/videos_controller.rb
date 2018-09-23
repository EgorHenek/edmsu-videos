class VideosController < ApplicationController
  before_action :set_video, only: [:show, :update, :destroy]
  load_and_authorize_resource

  # GET /videos
  def index
    @videos = paginate Video.all

    render json: VideoSerializer.new(@videos).serialized_json
  end

  # GET /videos/1
  def show
    render json: VideoSerializer.new(@video).serialized_json
  end

  # POST /videos
  def create
    @video = Video.new(video_params)

    if @video.save
      render json: VideoSerializer.new(@video).serialized_json, status: :created, location: @video
    else
      render json: @video.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /videos/1
  def update
    if @video.update(video_params)
      render json: VideoSerializer.new(@video).serialized_json
    else
      render json: @video.errors, status: :unprocessable_entity
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
      params.require(:video).permit(:youtube_url, :description)
    end
end
