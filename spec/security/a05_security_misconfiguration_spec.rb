require 'rails_helper'

RSpec.describe 'A05:2021 - Security Misconfiguration', type: :system do
  before do
    setup_test_data
  end

  it 'I should not be able to run my own JavaScript in search results?' do
    login_as(@user)

    visit "/search?query=<script>alert(123);window.xssExecuted=true</script>"

    alert_present = false
    begin
      page.driver.browser.switch_to.alert.accept
      alert_present = true
    rescue Selenium::WebDriver::Error::NoSuchAlertError
      alert_present = false
    end
    expect(alert_present).to be false

    visit "/search?query=<script>window.stolenCookie=document.cookie</script>"
    sleep 0.5

    stolen_cookie = page.evaluate_script('window.stolenCookie') rescue nil
    expect(stolen_cookie).to be_nil

    visit "/search?query=<script>document.body.style.backgroundColor='red'</script>"
    sleep 0.5

    bg_color = page.evaluate_script("getComputedStyle(document.body).backgroundColor") rescue nil
    expect(bg_color).not_to eq('red')

    visit "/search?query=<script>window.sessionData=sessionStorage.getItem('user_session')</script>"
    sleep 0.5

    session_data = page.evaluate_script('window.sessionData') rescue nil
    expect(session_data).to be_nil
  end

  it 'I should not be able to create admin users from the browser?' do
    visit '/login'
    fill_in 'email', with: @admin_user.email
    fill_in 'password', with: 'password123'
    click_button 'Sign in'

    create_attack = <<~JS
      fetch('/admin/users', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          user: {
            email: 'csrf-hacker@example.com',
            first_name: 'CSRF',
            admin: true,
            password: 'hacked123',
            password_confirmation: 'hacked123'
          }
        })
      }).then(response => {
        window.createAttackSucceeded = response.ok;
      }).catch(() => { window.createAttackSucceeded = false; });
    JS

    page.execute_script(create_attack)
    sleep 1

    create_succeeded = page.evaluate_script('window.createAttackSucceeded === true') rescue false
    expect(create_succeeded).to be false
    expect(User.find_by(email: 'csrf-hacker@example.com')).to be_nil
  end
end
