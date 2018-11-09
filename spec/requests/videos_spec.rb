require 'rails_helper'

RSpec.describe "Videos", type: :request do
  before(:all) do
    @video = create(:video)
    @admin = create(:user_with_admin)
    @user = create(:user)
  end
  describe "GET /videos" do
    it "return 200" do
      get videos_path
      expect(response).to have_http_status(200)
    end
  end
  describe 'GET /videos/:id' do
    it 'return 200' do
      get video_path(@video.id)
      expect(response).to have_http_status(200)
    end
  end
  describe 'POST /videos' do
    it 'return 200' do
      post videos_path,
           params: { video: { youtube_url: 'https://www.youtube.com/watch?v=P_LLry8BUtQ' } },
           headers: auth_headers(@admin)
      expect(response).to have_http_status(201)
    end
    describe 'Ошибки доступа' do
      it 'Без прав' do
        post videos_path,
             params: { video: { youtube_url: 'https://www.youtube.com/watch?v=P_LLry8BUtQ' } },
             headers: auth_headers(@user)
        expect(response).not_to have_http_status(201)
      end
      it 'Без авторизации' do
        post videos_path,
             params: { video: { youtube_url: 'https://www.youtube.com/watch?v=P_LLry8BUtQ' } }
        expect(response).not_to have_http_status(201)
      end
    end
    it 'Попытка создания без youtube_url' do
      expect do
        post videos_path,
             params: { video: { description: 'https://www.youtube.com/watch?v=P_LLry8BUtQ' } },
             headers: auth_headers(@admin)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  describe 'PUT /videos/:id' do
    describe 'return 200' do
      it 'Изменение описания' do
        put video_path(@video.id),
            params: { video: { description: 'Новое описание' } },
            headers: auth_headers(@admin)
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body, object_class: OpenStruct).data.attributes.description).to eq 'Новое описание'
      end
    end
    describe 'Ошибки доступа' do
      it 'Без прав' do
        put video_path(@video.id),
            params: { video: { description: 'Новое описание' } },
            headers: auth_headers(@user)
        expect(response).not_to have_http_status(204)
      end
      it 'Без авторизации' do
        put video_path(@video.id), params: { video: { description: 'Новое описание' } }
        expect(response).not_to have_http_status(204)
      end
    end
  end
  describe 'DELETE /videos/:id' do
    it 'return 200' do
      delete video_path(@video.id), headers: auth_headers(@admin)
      expect(response).to have_http_status(204)
    end
    describe 'Ошибки доступа' do
      it 'Без прав' do
        delete video_path(@video.id), headers: auth_headers(@user)
        expect(response).not_to have_http_status(204)
      end
      it 'Без авторизации' do
        delete video_path(@video.id)
        expect(response).not_to have_http_status(204)
      end
    end
  end
end
