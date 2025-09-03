require 'rails_helper'

RSpec.describe 'A02:2021 - Cryptographic Failures', type: :request do
  before do
    setup_test_data
  end

  it 'I should not get personal info in the API' do
    login_as(@user)

    get "/api/v1/users/#{@user.id}"

    expect(response.body).not_to include('password_digest')
    expect(response.body).not_to include('raw_password')
    expect(response.body).not_to include('123-45-6789')
    expect(response.body).not_to include('4532-1234-5678-9012')
    expect(response.body).not_to include('sk_live_abc123xyz789')
  end
end
