require 'rails_helper'

RSpec.describe 'A10:2021 - Server-Side Request Forgery (SSRF)', type: :request do
  before do
    setup_test_data
  end

  it 'I should not be able to use localhost URLs for my profile picture?' do
    login_as(@user)

    post '/upload_avatar',
         params: { avatar_url: 'http://127.0.0.1:3000/admin/dashboard' }

    expect(response).to have_http_status(:forbidden)
    expect(response.body).to include('Invalid host')
  end

  it 'I should be able to use a safe CDN link for my avatar' do
    login_as(@user)

    post '/upload_avatar',
         params: { avatar_url: 'http://cdn.example.com/avatar.png' }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Avatar uploaded')
  end
end
