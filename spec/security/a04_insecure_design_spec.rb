require 'rails_helper'

RSpec.describe 'A04:2021 - Insecure Design', type: :request do
  before do
    setup_test_data
  end

  it 'I should not be able to reset other user passwords' do
    guessed_token = "token_#{@admin_user.id}_#{Date.today}"

    patch "/reset_password/#{guessed_token}",
          params: { password: 'hacked123' }

    expect(response).not_to have_http_status(:ok)
  end
end
