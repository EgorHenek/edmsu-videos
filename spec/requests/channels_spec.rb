# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Channels', type: :request do
  before(:all) do
    @channel = create(:channel)
    @admin = create(:user_with_admin)
    @user = create(:user)
  end
  describe 'GET /channels' do
    it 'return 200' do
      get channels_path
      expect(response).to have_http_status(200)
      expect(response).to match_json_schema('channels/get_channels')
    end
  end

  describe 'GET /channels/:id' do
    it 'return 200' do
      get channel_path(@channel.id)
      expect(response).to have_http_status(200)
      expect(response).to match_json_schema('channels/get_channel')
    end
  end

  describe 'DELETE /channels/:id' do
    it 'return 200' do
      delete channel_path(@channel.id), headers: auth_headers(@admin)
      expect(response).to have_http_status(204)
    end
    describe 'Ошибки доступа' do
      it 'Без прав' do
        delete channel_path(@channel.id), headers: auth_headers(@user)
        expect(response).not_to have_http_status(204)
      end
      it 'Без авторизации' do
        delete channel_path(@channel.id)
        expect(response).not_to have_http_status(204)
      end
    end
  end

  describe 'PUT /channels/:id' do
    describe 'return 200' do
      it 'Изменение описания' do
        description = 'Новое описание'
        put channel_path(@channel.id),
            params: { channel: { description: description } },
            headers: auth_headers(@admin)
        expect(response).to have_http_status(200)
        expect(response).to match_json_schema('channels/get_channel')
        expect(JSON.parse(response.body, object_class: OpenStruct).data.attributes.description).to eq description
      end
    end
    describe 'Ошибки доступа' do
      it 'Без прав' do
        put channel_path(@channel.id),
            params: { channel: { description: 'Новое описание' } },
            headers: auth_headers(@user)
        expect(response).not_to have_http_status(204)
      end
      it 'Без авторизации' do
        put channel_path(@channel.id), params: { channel: { description: 'Новое описание' } }
        expect(response).not_to have_http_status(204)
      end
    end
  end

  describe 'POST /channels/:id' do
    it 'return 200' do
      post channels_path,
           params: { channel: { youtube_url: 'https://www.youtube.com/channel/UCOloc4MDn4dQtP_U6asWk2w' } },
           headers: auth_headers(@admin)
      expect(response).to have_http_status(201)
      expect(response).to match_json_schema('channels/get_channel')
    end
    describe 'Ошибки доступа' do
      it 'Без прав' do
        post channels_path,
             params: { channel: { youtube_url: 'https://www.youtube.com/channel/UCOloc4MDn4dQtP_U6asWk2w' } },
             headers: auth_headers(@user)
        expect(response).not_to have_http_status(201)
      end
      it 'Без авторизации' do
        post channels_path, params: { channel: { youtube_url: 'https://www.youtube.com/channel/UCOloc4MDn4dQtP_U6asWk2w' } }
        expect(response).not_to have_http_status(201)
      end
    end
    it 'Попытка создания без youtube_url' do
      expect do
        post channels_path,
             params: { channel: { description: 'https://www.youtube.com/channel/UCOloc4MDn4dQtP_U6asWk2w' } },
             headers: auth_headers(@admin)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
