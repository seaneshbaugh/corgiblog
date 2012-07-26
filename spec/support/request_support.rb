module RequestSupport
  def sign_in user = nil
    user ? @user = user : @user = create(:user)
    page.driver.post user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
  end
end
