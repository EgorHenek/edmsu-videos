# frozen_string_literal: true

class ChannelsController < ApplicationController
  before_action :set_channel, only: %i[show update destroy]
  load_and_authorize_resource

  # GET /channels
  def index
    @channels = Channel.all

    render json: ChannelSerializer.new(@channels).serialized_json
  end

  # GET /channels/1
  def show
    @videos = paginate @channel.videos
    render json: ChannelSerializer.new(@channel).serializable_hash
  end

  # POST /channels
  def create
    @channel = Channel.new(channel_params)
    @channel.user = current_user

    if @channel.save
      render json: ChannelSerializer.new(@channel).serialized_json, status: :created, location: @channel
    else
      render json: {success: false, errors: @channel.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /channels/1
  def update
    if @channel.update(update_channel_params)
      render json: ChannelSerializer.new(@channel).serialized_json
    else
      render json: {success: false, errors: @channel.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # DELETE /channels/1
  def destroy
    @channel.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_channel
    @channel = Channel.friendly.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def channel_params
    params.require(:channel).permit(:youtube_url, :description)
  end

  def update_channel_params
    params.require(:channel).permit(:description)
  end
end
