require 'test_helper'

class ServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider = Provider.create!(
      name: 'Test Provider',
      email: 'provider@test.com',
      password: 'password123',
      service_type_id: 2,
      introduction: 'intro'
    )
    @other_provider = Provider.create!(
      name: 'Other Provider',
      email: 'other@test.com',
      password: 'password123',
      service_type_id: 2,
      introduction: 'intro'
    )
    @service = Service.create!(
      departure_id: 2,
      destination_id: 2,
      service_type_id: 2,
      price: 10000,
      lead_time: 7,
      option_id: 1,
      description: 'desc',
      provider_id: @provider.id
    )
    @other_service = Service.create!(
      departure_id: 2,
      destination_id: 2,
      service_type_id: 2,
      price: 20000,
      lead_time: 14,
      option_id: 1,
      description: 'desc',
      provider_id: @other_provider.id
    )
  end

  test 'index returns success without login' do
    get root_path
    assert_response :success
  end

  test 'show returns success without login' do
    get service_path(@service)
    assert_response :success
  end

  test 'new redirects to provider login when not signed in' do
    get new_service_path
    assert_redirected_to new_provider_session_path
  end

  test 'create redirects to provider login when not signed in' do
    post services_path, params: { service: { departure_id: 2, destination_id: 2, service_type_id: 2, price: 10000, lead_time: 7, option_id: 1, description: 'x', provider_id: @provider.id } }
    assert_redirected_to new_provider_session_path
  end

  test 'edit redirects to login when not signed in' do
    get edit_service_path(@service)
    assert_redirected_to new_provider_session_path
  end

  test 'edit redirects to root with alert when signed in as other provider' do
    sign_in @other_provider
    get edit_service_path(@service)
    assert_redirected_to root_path
    assert_equal '権限がありません', flash[:alert]
  end

  test 'edit returns success when signed in as owner' do
    sign_in @provider
    get edit_service_path(@service)
    assert_response :success
  end

  test 'update redirects to root with alert when signed in as other provider' do
    sign_in @other_provider
    patch service_path(@service), params: { service: { price: 9999 } }
    assert_redirected_to root_path
    assert_equal '権限がありません', flash[:alert]
  end

  test 'destroy redirects to root with alert when signed in as other provider' do
    sign_in @other_provider
    assert_no_difference('Service.count') do
      delete service_path(@service)
    end
    assert_redirected_to root_path
    assert_equal '権限がありません', flash[:alert]
  end

  test 'search without params returns success' do
    get search_services_path
    assert_response :success
  end
end
