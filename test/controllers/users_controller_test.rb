require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: 'Test User',
      email: 'user@test.com',
      password: 'password123',
      user_type_id: 1,
      product_id: 1,
      introduction: 'intro'
    )
  end

  test 'show redirects to login when not signed in' do
    get user_path(@user)
    assert_redirected_to new_user_session_path
  end

  test 'show returns success when signed in as that user' do
    sign_in @user
    get user_path(@user)
    assert_response :success
  end
end
