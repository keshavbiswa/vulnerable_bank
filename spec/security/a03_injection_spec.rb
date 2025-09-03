require 'rails_helper'

RSpec.describe 'A03:2021 - Injection', type: :request do
  before(:each) do
    setup_test_data
  end

  it 'I should not be able to use SQL on inputs' do
    login_as(@user)
    malicious_query = "%' OR '1'='1"
    get '/search', params: { query: malicious_query }

    expect(response.body).not_to include(@admin_user.email)
    expect(response.body).not_to include('Admin')
    expect(response.body).not_to include('Password Hash')
  end

  it 'I should not be able to mess with the database through profile updates?' do
    login_as(@user)
    original_admin_name = @admin_user.first_name
    original_user_admin_status = @user.admin
    malicious_name = "NewName', admin=true WHERE id=#{@user.id} OR id=#{@admin_user.id}; --"

    patch "/users/#{@user.id}/update_profile",
          params: {
            user: {
              first_name: malicious_name,
              last_name: 'Doe'
            }
          }

    @admin_user.reload
    @user.reload

    expect(@user.admin).to eq(original_user_admin_status)
    expect(@user.admin).not_to be true

    expect(@admin_user.first_name).to eq(original_admin_name)
  end

  it 'I should not be able to get admin privileges without authorizations' do
    login_as(@user)
    expect(@user.admin).to be_falsey
    expect(@user.role).to eq('customer')

    patch "/users/#{@user.id}",
          params: {
            user: {
              first_name: @user.first_name,
              last_name: @user.last_name,
              email: @user.email,
              admin: true,
              role: 'admin',
              balance: 1000000.00
            }
          }

    @user.reload

    expect(@user.admin).to be_falsey
    expect(@user.role).not_to eq('admin')
    expect(@user.balance).not_to eq(1000000.00)
  end
end
