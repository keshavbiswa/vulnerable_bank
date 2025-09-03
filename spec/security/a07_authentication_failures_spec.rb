require 'rails_helper'

RSpec.describe 'A07:2021 - Identification and Authentication Failures', type: :system do
  before do
    setup_test_data
  end

  it 'I should not be able to go directly to /admin/dashboard?' do
    visit '/admin/dashboard'

    expect(page).not_to have_content('Admin Dashboard')
    expect(page).not_to have_content('Total Users')
  end

  it 'I should not be able to access admin stuff without logging in first?' do
    visit "/users/#{@admin_user.id}/admin_panel"

    expect(page).not_to have_content('Admin Panel')
    expect(page).not_to have_content('All Users')
  end

  it 'what happens if I visit someone elses profile?' do
    visit "/users/#{@admin_user.id}"

    expect(page).not_to have_content(@admin_user.email)
    expect(page).not_to have_content('Admin')
  end


  it 'What if I try logging in with wrong password many times' do
    5.times do |i|
      visit '/login'
      fill_in 'email', with: @user.email
      fill_in 'password', with: "wrong#{i}"
      click_button 'Sign in'
    end

    fill_in 'email', with: @user.email
    fill_in 'password', with: 'password123'
    click_button 'Sign in'

    expect(page).to have_content('Account locked')
    expect(page).to have_content('Too many failed attempts')
  end
end
