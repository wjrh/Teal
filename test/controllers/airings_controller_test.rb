require 'test_helper'

class AiringsControllerTest < ActionController::TestCase
  setup do
    @airing = airings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:airings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create airing" do
    assert_difference('Airing.count') do
      post :create, airing: { end_time: @airing.end_time, listens: @airing.listens, start_time: @airing.start_time }
    end

    assert_redirected_to airing_path(assigns(:airing))
  end

  test "should show airing" do
    get :show, id: @airing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @airing
    assert_response :success
  end

  test "should update airing" do
    patch :update, id: @airing, airing: { end_time: @airing.end_time, listens: @airing.listens, start_time: @airing.start_time }
    assert_redirected_to airing_path(assigns(:airing))
  end

  test "should destroy airing" do
    assert_difference('Airing.count', -1) do
      delete :destroy, id: @airing
    end

    assert_redirected_to airings_path
  end
end
