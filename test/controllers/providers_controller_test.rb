require 'test_helper'

class ProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider = Provider.create!(
      name: 'Test Provider',
      email: 'provider@test.com',
      password: 'password123',
      service_type_id: 2,
      introduction: 'intro'
    )
  end

  test 'mypage redirects to provider login when not signed in' do
    get mypage_provider_path
    assert_redirected_to new_provider_session_path
  end

  test 'mypage returns success when signed in' do
    sign_in @provider
    get mypage_provider_path
    assert_response :success
  end

  test 'show (public profile) returns success without login' do
    get provider_path(@provider)
    assert_response :success
  end
end
