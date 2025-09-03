require 'rails_helper'

RSpec.describe 'A01:2021 - Broken Access Control', type: :request do
  before do
    setup_test_data
  end

  it "I should not be able to access other user's  data" do
    login_as(@user)

    get "/users/#{@other_user.id}/admin_panel"

    expect(response.body).not_to include(@other_user.first_name)
    expect(response.body).to include(@user.first_name)
  end
end
